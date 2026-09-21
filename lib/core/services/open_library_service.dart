import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_provider.dart';

class BookMetadata {
  const BookMetadata({required this.title, required this.author, this.coverUrl});
  final String title;
  final String author;
  final String? coverUrl;
}

class OpenLibraryLookupFailure implements Exception {
  const OpenLibraryLookupFailure(this.message);
  final String message;
}

/// Looks up book metadata by ISBN via the Open Library Books API
/// (https://openlibrary.org/dev/docs/api/books). Used by the books feature
/// to prefill title/author/cover after a barcode scan (SRS §3.2).
class OpenLibraryService {
  OpenLibraryService(this._dio);
  final Dio _dio;

  static const _endpoint = 'https://openlibrary.org/api/books';

  /// Returns null if Open Library has no record for [isbn].
  Future<BookMetadata?> lookupByIsbn(String isbn) async {
    final key = 'ISBN:${isbn.trim()}';
    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        _endpoint,
        queryParameters: {'bibkeys': key, 'format': 'json', 'jscmd': 'data'},
      );
    } on DioException catch (e) {
      throw OpenLibraryLookupFailure(
        'Could not look up ISBN $isbn: ${e.message}',
      );
    }

    final data = response.data?[key] as Map<String, dynamic>?;
    if (data == null) return null;

    final authors = (data['authors'] as List<dynamic>?)
        ?.map((author) => (author as Map<String, dynamic>)['name'] as String)
        .join(', ');
    final cover = data['cover'] as Map<String, dynamic>?;

    return BookMetadata(
      title: data['title'] as String? ?? '',
      author: authors ?? '',
      coverUrl: (cover?['medium'] ?? cover?['large']) as String?,
    );
  }
}

final openLibraryServiceProvider = Provider<OpenLibraryService>(
  (ref) => OpenLibraryService(ref.watch(dioProvider)),
);
