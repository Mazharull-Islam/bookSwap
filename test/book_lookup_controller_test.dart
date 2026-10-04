import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/core/services/book_enrichment_service.dart';
import 'package:bookswap_login/core/services/open_library_service.dart';
import 'package:bookswap_login/features/books/domain/entities/book.dart';
import 'package:bookswap_login/features/books/presentation/controllers/book_lookup_controller.dart';
import 'support/fake_google_books.dart';

/// A catalogue whose answers the test controls, so races can be reproduced.
class _FakeCatalogue extends OpenLibraryService {
  _FakeCatalogue() : super(Dio());

  final searches = <String>[];
  Completer<List<BookMetadata>>? pendingSearch;
  List<BookMetadata> searchResult = const [];
  bool searchFails = false;

  BookMetadata? isbnResult;
  bool isbnFails = false;
  Completer<BookMetadata?>? pendingIsbn;

  @override
  Future<List<BookMetadata>> searchByTitle(String query, {int limit = 8}) {
    searches.add(query);
    if (searchFails) throw const BookLookupFailure('offline');
    // Only the first search is held back; later ones answer normally.
    final held = pendingSearch;
    pendingSearch = null;
    return held?.future ?? Future.value(searchResult);
  }

  @override
  Future<BookMetadata?> lookupByIsbn(String isbn) {
    if (isbnFails) throw const BookLookupFailure('offline');
    return pendingIsbn?.future ?? Future.value(isbnResult);
  }

  @override
  Future<String?> fetchSynopsis(BookMetadata suggestion) async => null;
}

class _FakeEnrichment extends BookEnrichmentService {
  _FakeEnrichment()
    : super(openLibrary: _FakeCatalogue(), googleBooks: FakeGoogleBooks());

  BookDetails details = const BookDetails(
    genres: ['Fantasy'],
    synopsis: 'A synopsis.',
  );
  Completer<BookDetails>? pending;
  int calls = 0;
  BookMetadata? lastBook;

  @override
  Future<BookDetails> enrich(BookMetadata book) {
    calls++;
    lastBook = book;
    return pending?.future ?? Future.value(details);
  }
}

const dune = BookMetadata(
  title: 'Dune',
  author: 'Frank Herbert',
  coverUrl: 'https://x/dune.jpg',
  isbn: '9780441172719',
  genres: ['Science fiction'],
  publishedYear: '1965',
  workKey: '/works/OL1W',
);

Future<void> settle([int ms = 40]) =>
    Future<void>.delayed(Duration(milliseconds: ms));

void main() {
  late _FakeCatalogue catalogue;
  late _FakeEnrichment enrichment;
  late BookLookupController controller;

  BookLookupController make({Book? existing}) => BookLookupController(
    catalogue: catalogue,
    enrichment: enrichment,
    existing: existing,
    searchDelay: const Duration(milliseconds: 10),
  );

  setUp(() {
    catalogue = _FakeCatalogue();
    enrichment = _FakeEnrichment();
    controller = make();
  });

  tearDown(() => controller.dispose());

  group('starting point', () {
    test('a new book starts empty', () {
      expect(controller.hasSelection, isFalse);
      expect(controller.title.text, isEmpty);
      expect(controller.genres, isEmpty);
      expect(controller.suggestions, isEmpty);
    });

    test('an existing book starts selected, with its genres split', () {
      final existing = const Book(
        id: 'b',
        ownerId: 'u',
        title: 'Emma',
        author: 'Jane Austen',
        genre: 'Romance, Comedy',
        condition: 'Good',
        estimatedValue: 5,
        description: 'Matchmaking.',
        coverPhotoUrl: 'c',
        isbn: '123',
        workKey: '/works/OL2W',
      );
      final c = make(existing: existing);
      addTearDown(c.dispose);
      expect(c.hasSelection, isTrue);
      expect(c.title.text, 'Emma');
      expect(c.description.text, 'Matchmaking.');
      expect(c.author, 'Jane Austen');
      expect(c.genre, 'Romance, Comedy');
      expect(c.genres, ['Romance', 'Comedy']);
      expect(c.workKey, '/works/OL2W');
    });
  });

  group('title search', () {
    test('short titles do not search', () async {
      controller.title.text = 'Du';
      await settle();
      expect(catalogue.searches, isEmpty);
    });

    test(
      'a longer title searches after a pause and shows suggestions',
      () async {
        catalogue.searchResult = [dune];
        controller.title.text = 'Dune';
        expect(catalogue.searches, isEmpty, reason: 'waits for typing to stop');
        await settle();
        expect(catalogue.searches, ['Dune']);
        expect(controller.suggestions, [dune]);
        expect(controller.searching, isFalse);
      },
    );

    test('typing quickly searches once, for the final text', () async {
      controller.title.text = 'Dun';
      controller.title.text = 'Dune';
      controller.title.text = 'Dune M';
      await settle();
      expect(catalogue.searches, ['Dune M']);
    });

    test('deleting back to a short title clears the suggestions', () async {
      catalogue.searchResult = [dune];
      controller.title.text = 'Dune';
      await settle();
      expect(controller.suggestions, isNotEmpty);
      controller.title.text = 'Du';
      expect(controller.suggestions, isEmpty);
    });

    test('an answer for text that has since changed is ignored', () async {
      final held = Completer<List<BookMetadata>>();
      catalogue.pendingSearch = held;
      controller.title.text = 'Dune';
      await settle();
      controller.title.text = 'Emma';
      await settle(); // the search for Emma finishes first (no results)
      expect(catalogue.searches, ['Dune', 'Emma']);
      held.complete([dune]); // ...then the old answer for Dune arrives late
      await settle();
      expect(controller.suggestions, isEmpty);
    });

    test('a failed search does not block typing', () async {
      catalogue.searchFails = true;
      controller.title.text = 'Dune';
      await settle();
      expect(controller.suggestions, isEmpty);
      expect(controller.searching, isFalse);
    });

    test('suggestions can be dismissed', () async {
      catalogue.searchResult = [dune];
      controller.title.text = 'Dune';
      await settle();
      controller.clearSuggestions();
      expect(controller.suggestions, isEmpty);
    });
  });

  group('choosing a suggestion', () {
    test('fills in the book and then the enriched details', () async {
      await controller.selectSuggestion(dune);
      expect(controller.hasSelection, isTrue);
      expect(controller.title.text, 'Dune');
      expect(controller.author, 'Frank Herbert');
      expect(controller.coverPhotoUrl, 'https://x/dune.jpg');
      expect(controller.isbn, '9780441172719');
      expect(controller.workKey, '/works/OL1W');
      expect(controller.publishedYear, '1965');
      expect(controller.genres, ['Fantasy'], reason: 'the enriched genres win');
      expect(controller.description.text, 'A synopsis.');
      expect(controller.fetchingSynopsis, isFalse);
    });

    test(
      'shows standard genres at once, before the synopsis arrives',
      () async {
        enrichment.pending = Completer();
        final done = controller.selectSuggestion(dune);
        expect(controller.genres, ['Science fiction']);
        expect(controller.fetchingSynopsis, isTrue);
        expect(controller.suggestions, isEmpty);
        enrichment.pending!.complete(
          const BookDetails(genres: ['Fantasy'], synopsis: 'Done.'),
        );
        await done;
        expect(controller.genres, ['Fantasy']);
        expect(controller.fetchingSynopsis, isFalse);
      },
    );

    test('setting the title does not trigger a new search', () async {
      await controller.selectSuggestion(dune);
      await settle();
      expect(catalogue.searches, isEmpty);
    });

    test('no synopsis found leaves the description empty', () async {
      enrichment.details = const BookDetails(genres: ['Other']);
      await controller.selectSuggestion(dune);
      expect(controller.description.text, isEmpty);
      expect(controller.genre, 'Other');
    });

    test('closing the screen mid-lookup does not throw', () async {
      enrichment.pending = Completer();
      final done = controller.selectSuggestion(dune);
      controller.dispose();
      enrichment.pending!.complete(const BookDetails(genres: ['Fantasy']));
      await done;
      // tearDown disposes again, which must also be harmless.
    });
  });

  group('looking up an ISBN', () {
    test('a found book is selected', () async {
      catalogue.isbnResult = dune;
      expect(
        await controller.lookupIsbn('9780441172719'),
        IsbnLookupOutcome.selected,
      );
      expect(controller.title.text, 'Dune');
      expect(controller.lookingUp, isFalse);
    });

    test('an unknown ISBN says not found and selects nothing', () async {
      expect(
        await controller.lookupIsbn('9780441172719'),
        IsbnLookupOutcome.notFound,
      );
      expect(controller.hasSelection, isFalse);
      expect(controller.lookingUp, isFalse);
    });

    test('a catalogue outage says unreachable', () async {
      catalogue.isbnFails = true;
      expect(
        await controller.lookupIsbn('9780441172719'),
        IsbnLookupOutcome.unreachable,
      );
      expect(controller.lookingUp, isFalse);
    });

    test('is marked as looking up while it runs', () async {
      catalogue.pendingIsbn = Completer();
      final done = controller.lookupIsbn('9780441172719');
      expect(controller.lookingUp, isTrue);
      catalogue.pendingIsbn!.complete(null);
      await done;
      expect(controller.lookingUp, isFalse);
    });
  });

  group('refreshing an existing book', () {
    Book existingBook() => const Book(
      id: 'b',
      ownerId: 'u',
      title: 'Dune',
      author: 'Frank Herbert',
      genre: 'Accessible book',
      condition: 'Good',
      estimatedValue: 5,
      description: 'Old text.',
      isbn: '9780441172719',
      workKey: '/works/OL1W',
    );

    test('re-reads genres and replaces the synopsis', () async {
      final c = make(existing: existingBook());
      addTearDown(c.dispose);
      expect(await c.refreshDetails(), isTrue);
      expect(c.genres, ['Fantasy']);
      expect(c.description.text, 'A synopsis.');
      expect(enrichment.lastBook?.workKey, '/works/OL1W');
      expect(enrichment.lastBook?.genres, ['Accessible book']);
    });

    test('keeps the current description when no better one is found', () async {
      enrichment.details = const BookDetails(genres: ['Science fiction']);
      final c = make(existing: existingBook());
      addTearDown(c.dispose);
      await c.refreshDetails();
      expect(c.genre, 'Science fiction');
      expect(c.description.text, 'Old text.');
    });

    test('a second refresh while one is running does nothing', () async {
      enrichment.pending = Completer();
      final c = make(existing: existingBook());
      addTearDown(c.dispose);
      final first = c.refreshDetails();
      expect(c.refreshing, isTrue);
      expect(await c.refreshDetails(), isFalse);
      expect(enrichment.calls, 1);
      enrichment.pending!.complete(const BookDetails(genres: ['Fantasy']));
      expect(await first, isTrue);
      expect(c.refreshing, isFalse);
    });
  });

  group('listeners', () {
    test('are told about every change the screen draws', () async {
      var notified = 0;
      controller.addListener(() => notified++);
      await controller.selectSuggestion(dune);
      expect(
        notified,
        greaterThanOrEqualTo(2),
        reason: 'selection, then details',
      );
    });
  });
}
