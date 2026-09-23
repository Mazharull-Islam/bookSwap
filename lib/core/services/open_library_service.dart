import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_provider.dart';

class BookMetadata {
  const BookMetadata({
    required this.title,
    required this.author,
    this.coverUrl,
    this.isbn,
    this.genres = const [],
    this.publishedYear,
    this.workKey,
  });
  final String title;
  final String author;
  final String? coverUrl;
  final String? isbn;
  final List<String> genres;
  final String? publishedYear;

  final String? workKey;
}

class BookLookupFailure implements Exception {
  const BookLookupFailure(this.message);
  final String message;
}

class OpenLibraryService {
  OpenLibraryService(this._dio);
  final Dio _dio;

  static const _endpoint = 'https://openlibrary.org/api/books';

  Future<BookMetadata?> lookupByIsbn(String isbn) async {
    final key = 'ISBN:${isbn.trim()}';
    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        _endpoint,
        queryParameters: {'bibkeys': key, 'format': 'json', 'jscmd': 'data'},
      );
    } on DioException catch (e) {
      throw BookLookupFailure('Could not look up ISBN $isbn: ${e.message}');
    }

    final data = response.data?[key] as Map<String, dynamic>?;
    if (data == null) return null;

    final authors = (data['authors'] as List<dynamic>?)
        ?.map((author) => (author as Map<String, dynamic>)['name'] as String)
        .join(', ');
    final cover = data['cover'] as Map<String, dynamic>?;
    final subjects = (data['subjects'] as List<dynamic>?)
        ?.map((s) => (s as Map<String, dynamic>)['name'] as String)
        .take(3)
        .toList();

    return BookMetadata(
      title: data['title'] as String? ?? '',
      author: authors ?? '',
      coverUrl: (cover?['medium'] ?? cover?['large']) as String?,
      genres: subjects ?? const [],
      publishedYear: data['publish_date'] as String?,
    );
  }

  static const _searchEndpoint = 'https://openlibrary.org/search.json';

  Future<List<BookMetadata>> searchByTitle(
    String query, {
    int limit = 8,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];
    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        _searchEndpoint,
        queryParameters: {
          'title': trimmed,
          'limit': limit,
          'fields':
              'key,title,author_name,cover_i,isbn,first_publish_year,subject',
        },
      );
    } on DioException catch (e) {
      throw BookLookupFailure('Could not search for "$trimmed": ${e.message}');
    }

    final docs = response.data?['docs'] as List<dynamic>? ?? const [];
    return docs.map((doc) {
      final map = doc as Map<String, dynamic>;
      final coverId = map['cover_i'] as int?;
      final isbns = map['isbn'] as List<dynamic>?;
      final subjects = (map['subject'] as List<dynamic>?)
          ?.cast<String>()
          .take(3)
          .toList();
      return BookMetadata(
        title: map['title'] as String? ?? '',
        author: (map['author_name'] as List<dynamic>?)?.join(', ') ?? '',
        coverUrl: coverId == null
            ? null
            : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg',
        isbn: isbns == null || isbns.isEmpty ? null : isbns.first as String,
        genres: subjects ?? const [],
        publishedYear: (map['first_publish_year'] as int?)?.toString(),
        workKey: map['key'] as String?,
      );
    }).toList();
  }

  Future<String?> fetchSynopsis(BookMetadata suggestion) async {
    final workKey = suggestion.workKey;
    if (workKey == null) return null;
    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        'https://openlibrary.org$workKey.json',
      );
    } on DioException {
      return null;
    }
    final description = response.data?['description'];
    if (description is String) return description;
    if (description is Map<String, dynamic>) {
      return description['value'] as String?;
    }
    return null;
  }
}

final openLibraryServiceProvider = Provider<OpenLibraryService>(
  (ref) => OpenLibraryService(ref.watch(dioProvider)),
);
