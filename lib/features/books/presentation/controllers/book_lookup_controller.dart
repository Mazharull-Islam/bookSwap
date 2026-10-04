import 'dart:async';

import 'package:flutter/widgets.dart';
import '../../../../core/services/book_enrichment_service.dart';
import '../../../../core/services/open_library_service.dart';
import '../../../../shared/genre_normalizer.dart';
import '../../domain/book_genres.dart';
import '../../domain/entities/book.dart';

/// How an ISBN lookup ended, so the screen can say the right thing.
enum IsbnLookupOutcome { selected, notFound, unreachable }

/// Everything about finding the book to add: suggestions as you type a title,
/// looking one up by ISBN, and the details (genres, synopsis, cover) of the
/// book that ends up chosen. The screen only has to draw it and save the form.
class BookLookupController extends ChangeNotifier {
  BookLookupController({
    required this.catalogue,
    required this.enrichment,
    Book? existing,
    this.searchDelay = const Duration(milliseconds: 350),
  }) : title = TextEditingController(text: existing?.title),
       description = TextEditingController(text: existing?.description),
       _author = existing?.author ?? '',
       _genre = existing?.genre ?? '',
       _coverPhotoUrl = existing?.coverPhotoUrl,
       _isbn = existing?.isbn,
       _workKey = existing?.workKey {
    _genres = _genre.isEmpty
        ? []
        : _genre.split(',').map((g) => g.trim()).toList();
    title.addListener(_onTitleChanged);
  }

  final OpenLibraryService catalogue;
  final BookEnrichmentService enrichment;

  /// How long the title must sit still before a search starts.
  final Duration searchDelay;

  final TextEditingController title;
  final TextEditingController description;
  final FocusNode titleFocus = FocusNode();

  Timer? _debounce;
  bool _disposed = false;

  List<BookMetadata> _suggestions = [];
  bool _searching = false;
  bool _lookingUp = false;
  bool _refreshing = false;
  bool _fetchingSynopsis = false;

  String _author;
  String _genre;
  late List<String> _genres;
  String? _publishedYear;
  String? _coverPhotoUrl;
  String? _isbn;
  String? _workKey;

  List<BookMetadata> get suggestions => _suggestions;
  bool get searching => _searching;
  bool get lookingUp => _lookingUp;
  bool get refreshing => _refreshing;
  bool get fetchingSynopsis => _fetchingSynopsis;

  String get author => _author;

  /// Comma-joined, as stored on the book.
  String get genre => _genre;
  List<String> get genres => _genres;
  String? get publishedYear => _publishedYear;
  String? get coverPhotoUrl => _coverPhotoUrl;
  String? get isbn => _isbn;
  String? get workKey => _workKey;

  /// A book has been chosen (or is being edited), so the rest can be filled in.
  bool get hasSelection => _author.isNotEmpty;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void clearSuggestions() {
    if (_suggestions.isEmpty) return;
    _suggestions = [];
    _notify();
  }

  void _onTitleChanged() {
    _debounce?.cancel();
    final query = title.text;
    if (query.trim().length < 3) {
      _suggestions = [];
      _notify();
      return;
    }
    _debounce = Timer(searchDelay, () => _search(query));
  }

  Future<void> _search(String query) async {
    _searching = true;
    _notify();
    try {
      final results = await catalogue.searchByTitle(query);
      if (!_disposed && title.text == query) {
        _suggestions = results;
      }
    } on BookLookupFailure {
      // Suggestions are a convenience; a lookup failure shouldn't block typing.
    } finally {
      _searching = false;
      _notify();
    }
  }

  /// Chooses [suggestion]: its details appear straight away, then are refined
  /// once the second source has answered.
  Future<void> selectSuggestion(BookMetadata suggestion) async {
    title.removeListener(_onTitleChanged);
    title.text = suggestion.title;
    title.addListener(_onTitleChanged);
    // Standard genres from the subject tags right away (no network).
    final quickGenres = standardGenres(subjects: suggestion.genres);
    _author = suggestion.author;
    _genres = quickGenres;
    _genre = quickGenres.join(', ');
    _publishedYear = suggestion.publishedYear;
    _coverPhotoUrl = suggestion.coverUrl;
    _isbn = suggestion.isbn;
    _workKey = suggestion.workKey;
    _suggestions = [];
    _fetchingSynopsis = true;
    _notify();
    titleFocus.unfocus();
    final details = await enrichment.enrich(suggestion);
    if (_disposed) return;
    _genres = details.genres;
    _genre = details.genres.join(', ');
    description.text = details.synopsis ?? '';
    _fetchingSynopsis = false;
    _notify();
  }

  Future<IsbnLookupOutcome> lookupIsbn(String isbn) async {
    _lookingUp = true;
    _notify();
    try {
      final found = await catalogue.lookupByIsbn(isbn);
      if (_disposed) return IsbnLookupOutcome.selected;
      if (found == null) return IsbnLookupOutcome.notFound;
      await selectSuggestion(found);
      return IsbnLookupOutcome.selected;
    } on BookLookupFailure {
      return IsbnLookupOutcome.unreachable;
    } finally {
      _lookingUp = false;
      _notify();
    }
  }

  /// For a book already on the shelf: re-reads its genres and synopsis from
  /// the catalogues, keeping what's there if nothing better turns up. True if
  /// the details were updated.
  Future<bool> refreshDetails() async {
    if (_refreshing) return false;
    _refreshing = true;
    _notify();
    try {
      final details = await enrichment.enrich(
        BookMetadata(
          title: title.text,
          author: _author,
          isbn: _isbn,
          workKey: _workKey,
          genres: bookGenreList(_genre),
        ),
      );
      if (_disposed) return false;
      _genres = details.genres;
      _genre = details.genres.join(', ');
      if (details.synopsis != null) description.text = details.synopsis!;
      return true;
    } finally {
      _refreshing = false;
      _notify();
    }
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _debounce?.cancel();
    title.removeListener(_onTitleChanged);
    title.dispose();
    description.dispose();
    titleFocus.dispose();
    super.dispose();
  }
}
