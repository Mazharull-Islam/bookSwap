import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/genre_normalizer.dart';
import '../utils/synopsis.dart';
import 'google_books_service.dart' as google;
import 'open_library_service.dart' as ol;

class BookDetails {
  const BookDetails({required this.genres, this.synopsis});

  /// One to three of the standard genres (or "Other").
  final List<String> genres;
  final String? synopsis;
}

/// Turns a catalogue search hit into clean genres and a real synopsis by
/// combining Open Library and Google Books. Never throws: a failed source
/// just contributes nothing, so adding a book still works offline.
class BookEnrichmentService {
  BookEnrichmentService({
    required ol.OpenLibraryService openLibrary,
    required google.GoogleBooksService googleBooks,
  }) : _openLibrary = openLibrary,
       _google = googleBooks;
  final ol.OpenLibraryService _openLibrary;
  final google.GoogleBooksService _google;

  /// Google descriptions shorter than this are usually a one-line teaser;
  /// Open Library's is preferred when it has something longer.
  static const _usefulLength = 80;

  Future<String?> _openLibrarySynopsis(ol.BookMetadata book) async {
    try {
      return await _openLibrary.fetchSynopsis(book);
    } catch (_) {
      return null;
    }
  }

  Future<google.BookMetadata?> _googleMatch(ol.BookMetadata book) async {
    try {
      return await _google.findBest(
        title: book.title,
        author: book.author,
        isbn: book.isbn,
      );
    } catch (_) {
      return null;
    }
  }

  Future<BookDetails> enrich(ol.BookMetadata book) async {
    final results = await Future.wait<Object?>([
      _openLibrarySynopsis(book),
      _googleMatch(book),
    ]);
    final openLibrarySynopsis = cleanSynopsis(results[0] as String?);
    final match = results[1] as google.BookMetadata?;
    final googleSynopsis = cleanSynopsis(match?.synopsis);

    final synopsis =
        googleSynopsis != null && googleSynopsis.length >= _usefulLength
        ? googleSynopsis
        : (openLibrarySynopsis ?? googleSynopsis);
    return BookDetails(
      genres: standardGenres(
        subjects: book.genres,
        categories: match?.genres ?? const [],
        description: synopsis,
      ),
      synopsis: synopsis,
    );
  }
}

final bookEnrichmentServiceProvider = Provider<BookEnrichmentService>(
  (ref) => BookEnrichmentService(
    openLibrary: ref.watch(ol.openLibraryServiceProvider),
    googleBooks: ref.watch(google.googleBooksServiceProvider),
  ),
);
