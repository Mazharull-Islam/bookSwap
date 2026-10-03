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

  String? get workKey => null;
}

class BookLookupFailure implements Exception {
  const BookLookupFailure(this.message);
  final String message;
}

/// The title without a subtitle ("Dune: Book One" -> "Dune"), lower-cased,
/// minus punctuation and a leading article.
String _mainTitle(String title) => title
    .split(RegExp(r'[:–—(]| - '))
    .first
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
    .replaceAll(RegExp(r'^\s*(the|a|an) '), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

/// Same main title. A longer title without a colon or dash is a different
/// book ("Dune Messiah" is not "Dune").
bool _sameTitle(String a, String b) {
  final x = _mainTitle(a);
  final y = _mainTitle(b);
  return x.isNotEmpty && x == y;
}

/// The candidate that is really [title] by [author], or null. Accepting a
/// near-miss would attach another book's synopsis, which is worse than none.
BookMetadata? pickBestVolume(
  List<BookMetadata> candidates, {
  required String title,
  required String author,
}) {
  final lastName = author.trim().isEmpty
      ? null
      : author.split(',').first.trim().split(RegExp(r'\s+')).last.toLowerCase();
  for (final c in candidates) {
    if (!_sameTitle(c.title, title)) continue;
    if (lastName == null || c.author.trim().isEmpty) return c;
    if (c.author.toLowerCase().contains(lastName)) return c;
  }
  return null;
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

  /// The Google Books record for this exact book, or null. Tries the ISBN
  /// first (unambiguous), then title + author.
  Future<BookMetadata?> findBest({
    required String title,
    String author = '',
    String? isbn,
  }) async {
    if (isbn != null && isbn.trim().isNotEmpty) {
      final byIsbn = await lookupByIsbn(isbn);
      if (byIsbn != null) return byIsbn;
    }
    final firstAuthor = author.split(',').first.trim();
    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        _endpoint,
        queryParameters: _withKey({
          'q':
              'intitle:"${title.trim()}"'
              '${firstAuthor.isEmpty ? '' : '+inauthor:"$firstAuthor"'}',
          'maxResults': 5,
        }),
      );
    } on DioException catch (e) {
      throw BookLookupFailure('Could not look up "$title": ${e.message}');
    }
    final items = response.data?['items'] as List<dynamic>? ?? const [];
    return pickBestVolume(
      items.map((i) => _fromVolume(i as Map<String, dynamic>)).toList(),
      title: title,
      author: author,
    );
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
