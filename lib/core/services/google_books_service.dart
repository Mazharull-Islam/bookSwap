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
    this.synopsis,
  });
  final String title;
  final String author;
  final String? coverUrl;
  final String? isbn;
  final List<String> genres;
  final String? publishedYear;
  final String? synopsis;
}

class BookLookupFailure implements Exception {
  const BookLookupFailure(this.message);
  final String message;
}

class GoogleBooksService {
  GoogleBooksService(this._dio);
  final Dio _dio;

  static const _endpoint = 'https://www.googleapis.com/books/v1/volumes';
  static const _apiKey = String.fromEnvironment('GOOGLE_BOOKS_API_KEY');

  Map<String, dynamic> _withKey(Map<String, dynamic> params) =>
      _apiKey.isEmpty ? params : {...params, 'key': _apiKey};

  BookMetadata _fromVolume(Map<String, dynamic> item) {
    final info = item['volumeInfo'] as Map<String, dynamic>? ?? const {};
    final images = info['imageLinks'] as Map<String, dynamic>?;
    final identifiers = info['industryIdentifiers'] as List<dynamic>?;
    String? isbn13, isbn10;
    for (final entry in identifiers ?? const []) {
      final id = entry as Map<String, dynamic>;
      if (id['type'] == 'ISBN_13') isbn13 = id['identifier'] as String?;
      if (id['type'] == 'ISBN_10') isbn10 = id['identifier'] as String?;
    }
    final publishedDate = info['publishedDate'] as String?;
    return BookMetadata(
      title: info['title'] as String? ?? '',
      author: (info['authors'] as List<dynamic>?)?.join(', ') ?? '',
      coverUrl: (images?['thumbnail'] ?? images?['smallThumbnail']) as String?,
      isbn: isbn13 ?? isbn10,
      genres:
          (info['categories'] as List<dynamic>?)?.cast<String>() ?? const [],
      publishedYear: publishedDate != null && publishedDate.length >= 4
          ? publishedDate.substring(0, 4)
          : null,
      synopsis: info['description'] as String?,
    );
  }

  Future<String?> fetchSynopsis(BookMetadata suggestion) =>
      Future.value(suggestion.synopsis);

  Future<BookMetadata?> lookupByIsbn(String isbn) async {
    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        _endpoint,
        queryParameters: _withKey({'q': 'isbn:${isbn.trim()}'}),
      );
    } on DioException catch (e) {
      throw BookLookupFailure('Could not look up ISBN $isbn: ${e.message}');
    }
    final items = response.data?['items'] as List<dynamic>?;
    if (items == null || items.isEmpty) return null;
    return _fromVolume(items.first as Map<String, dynamic>);
  }

  Future<List<BookMetadata>> searchByTitle(
    String query, {
    int limit = 8,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];
    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        _endpoint,
        queryParameters: _withKey({
          'q': 'intitle:$trimmed',
          'maxResults': limit,
        }),
      );
    } on DioException catch (e) {
      throw BookLookupFailure('Could not search for "$trimmed": ${e.message}');
    }
    final items = response.data?['items'] as List<dynamic>? ?? const [];
    return items
        .map((item) => _fromVolume(item as Map<String, dynamic>))
        .toList();
  }
}

final googleBooksServiceProvider = Provider<GoogleBooksService>(
  (ref) => GoogleBooksService(ref.watch(dioProvider)),
);
