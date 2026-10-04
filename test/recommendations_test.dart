import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Override;
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/books/domain/entities/book.dart';
import 'package:bookswap_login/features/discovery/domain/discovery_filter.dart';
import 'package:bookswap_login/features/discovery/domain/recommendations.dart';
import 'package:bookswap_login/features/discovery/presentation/providers/discovery_providers.dart';
import 'package:bookswap_login/features/reading/domain/entities/reading_entry.dart';
import 'package:bookswap_login/features/reading/presentation/providers/reading_providers.dart';
import 'package:bookswap_login/features/reviews/domain/rating_summary.dart';
import 'package:bookswap_login/features/wanted_books/presentation/providers/wanted_book_providers.dart';
import 'support/test_app.dart';

Book book(
  String title, {
  String owner = 'other',
  String genre = 'Fantasy',
  String author = 'Someone',
  BookStatus status = BookStatus.available,
  String? id,
}) => Book(
  id: id ?? '$owner-$title',
  ownerId: owner,
  title: title,
  author: author,
  genre: genre,
  condition: 'Good',
  estimatedValue: 100,
  status: status,
);

ReadingEntry read(
  String title, {
  String genre = 'Fantasy',
  ReadingStatus status = ReadingStatus.read,
  int? rating,
  String author = 'Reader',
}) => ReadingEntry(
  id: 'r-$title',
  userId: 'me',
  title: title,
  author: author,
  genre: genre,
  status: status,
  rating: rating,
  updatedAtMs: 0,
);

String keyOf(String title, [String author = 'Someone']) =>
    '${title.toLowerCase()}|${author.toLowerCase()}';

List<Recommendation> recommend(
  List<Book> books, {
  List<ReadingEntry> reading = const [],
  Set<String> wanted = const {},
  List<String> preferences = const [],
  Set<String> owned = const {},
  Set<String> blocked = const {},
  Set<String> dismissed = const {},
  Map<String, RatingSummary> ratings = const {},
  double? Function(Book)? distance,
  double? maxDistanceKm,
  int limit = 8,
  int perGenre = 3,
}) => recommendBooks(
  books: books,
  myId: 'me',
  blockedOwnerIds: blocked,
  ownedKeys: owned,
  reading: reading,
  wantedKeys: wanted,
  preferences: preferences,
  ratings: ratings,
  distanceKm: distance ?? (_) => null,
  maxDistanceKm: maxDistanceKm,
  dismissedKeys: dismissed,
  limit: limit,
  perGenre: perGenre,
);

List<String> titles(List<Recommendation> r) => [
  for (final x in r) x.group.representative.title,
];

void main() {
  group('genre tags', () {
    test('split on commas and add standard genres by keyword', () {
      final tags = genreTags('Fantasy fiction, Dragons');
      expect(tags, containsAll(['fantasy fiction', 'dragons', 'fantasy']));
    });

    test('a dystopian novel counts as science fiction', () {
      expect(genreTags('Dystopian fiction'), contains('science fiction'));
    });
  });

  group('who is a candidate', () {
    final reader = [read('Old', genre: 'Fantasy')];

    test('only other members\' available books', () {
      final result = recommend([
        book('Mine', owner: 'me'),
        book('Lent', status: BookStatus.lent),
        book('Requested', status: BookStatus.requested),
        book('Ok'),
      ], reading: reader);
      expect(titles(result), ['Ok']);
    });

    test('books you already own or have in your reading list are skipped', () {
      final result = recommend(
        [book('Owned'), book('Reading', author: 'Reader'), book('Fresh')],
        reading: [...reader, read('Reading')],
        owned: {keyOf('Owned')},
      );
      expect(titles(result), ['Fresh']);
    });

    test('blocked members\' books and dismissed books are skipped', () {
      final result = recommend(
        [book('Blocked', owner: 'bad'), book('Nope'), book('Fine')],
        reading: reader,
        blocked: {'bad'},
        dismissed: {keyOf('Nope')},
      );
      expect(titles(result), ['Fine']);
    });

    test('with nothing to go on there are no recommendations', () {
      expect(recommend([book('A'), book('B', genre: 'History')]), isEmpty);
    });

    test('nearby and well rated alone are not enough without an interest', () {
      final result = recommend(
        [book('Popular', genre: 'Cooking')],
        ratings: {keyOf('Popular'): const RatingSummary(average: 5, count: 9)},
        distance: (_) => 1,
        reading: reader,
      );
      expect(result, isEmpty);
    });

    test('duplicate editions are one recommendation', () {
      final result = recommend(
        [
          book('Dune', owner: 'a', genre: 'Science fiction'),
          book('Dune', owner: 'b', genre: 'Science fiction'),
        ],
        wanted: {keyOf('Dune')},
      );
      expect(result, hasLength(1));
      expect(result.single.group.ownerCount, 2);
    });
  });

  group('ranking', () {
    test('the wishlist beats reading history', () {
      final result = recommend(
        [book('Liked Genre'), book('Wished', genre: 'History')],
        reading: [read('a'), read('b'), read('c')],
        wanted: {keyOf('Wished')},
      );
      expect(titles(result), ['Wished', 'Liked Genre']);
      expect(result.first.signal, RecommendationSignal.wishlist);
      expect(result.first.reason, 'On your wishlist');
    });

    test('reading history beats registration preferences', () {
      final result = recommend(
        [
          book('Preferred', genre: 'Romance'),
          book('Read Often', genre: 'Fantasy'),
        ],
        reading: [read('a'), read('b')],
        preferences: ['Romance'],
      );
      expect(titles(result), ['Read Often', 'Preferred']);
    });

    test('loving a genre ranks it above merely finishing it', () {
      final result = recommend(
        [book('Loved', genre: 'Mystery'), book('Finished', genre: 'Fantasy')],
        reading: [
          read('x', genre: 'Mystery', rating: 5),
          read('y', genre: 'Fantasy'),
        ],
      );
      expect(titles(result), ['Loved', 'Finished']);
    });

    test('a genre you rated poorly counts against a book', () {
      final history = [
        read('x', genre: 'Horror', rating: 1),
        read('y', genre: 'Fantasy'),
        read('z', genre: 'Fantasy'),
      ];
      final result = recommend([
        book('Disliked', genre: 'Horror'),
        book('Both', genre: 'Fantasy, Horror'),
      ], reading: history);
      // Horror alone is not wanted at all; mixed with a liked genre it ranks,
      // but lower than the same book without the horror would.
      expect(titles(result), ['Both']);
      final plain = recommend([
        book('Plain', genre: 'Fantasy'),
      ], reading: history);
      expect(result.single.score, lessThan(plain.single.score));
    });

    test('community ratings break ties but need at least two reviews', () {
      final books = [book('Alpha'), book('Beta')];
      final one = recommend(
        books,
        reading: [read('a')],
        ratings: {keyOf('Beta'): const RatingSummary(average: 5, count: 1)},
      );
      expect(titles(one), ['Alpha', 'Beta'], reason: 'one review is ignored');

      final two = recommend(
        books,
        reading: [read('a')],
        ratings: {keyOf('Beta'): const RatingSummary(average: 5, count: 2)},
      );
      expect(titles(two), ['Beta', 'Alpha']);
    });

    test('nearer beats farther, and beyond your limit counts against', () {
      double? km(Book b) => b.title == 'Near' ? 2 : 80;
      final result = recommend(
        [book('Far'), book('Near')],
        reading: [read('a'), read('b')],
        distance: km,
        maxDistanceKm: 30,
      );
      expect(titles(result), ['Near', 'Far']);
    });

    test('an unknown distance is neutral', () {
      final a = recommend([book('X')], reading: [read('a')]);
      final b = recommend(
        [book('X')],
        reading: [read('a')],
        distance: (_) => null,
        maxDistanceKm: 5,
      );
      expect(a.single.score, b.single.score);
    });

    test('one genre cannot fill the strip', () {
      final result = recommend(
        [for (var i = 0; i < 6; i++) book('Fantasy $i')] +
            [book('Mystery 1', genre: 'Mystery')],
        reading: [
          read('a'),
          read('b', genre: 'Mystery'),
        ],
        perGenre: 3,
      );
      expect(
        result.where((r) => r.group.representative.genre == 'Fantasy'),
        hasLength(3),
      );
      expect(titles(result), contains('Mystery 1'));
    });

    test('the strip is capped', () {
      final result = recommend(
        [
          for (var i = 0; i < 12; i++)
            book('Book $i', genre: 'Genre$i, Fantasy'),
        ],
        reading: [read('a')],
        limit: 5,
        perGenre: 99,
      );
      expect(result, hasLength(5));
    });

    test('the same inputs always give the same order', () {
      final books = [
        for (final t in ['d', 'a', 'c', 'b']) book(t),
      ];
      final first = titles(
        recommend(books, reading: [read('a')], perGenre: 99),
      );
      final second = titles(
        recommend(books.reversed.toList(), reading: [read('a')], perGenre: 99),
      );
      expect(first, second);
      expect(first, ['a', 'b', 'c', 'd']);
    });
  });

  group('cold start and reasons', () {
    test('registration preferences alone are enough', () {
      final result = recommend(
        [book('Epic', genre: 'Fantasy'), book('Dry', genre: 'History')],
        preferences: ['Fantasy'],
      );
      expect(titles(result), ['Epic']);
      expect(result.single.signal, RecommendationSignal.preference);
      expect(result.single.reason, 'One of your favourite genres');
    });

    test('a reading-history reason names the genre', () {
      final result = recommend(
        [book('Epic', genre: 'Fantasy')],
        reading: [read('a'), read('b'), read('c')],
      );
      expect(result.single.signal, RecommendationSignal.taste);
      expect(result.single.reason, 'Matches your Fantasy reading');
    });

    test('a community-rating reason quotes the numbers', () {
      final result = recommend(
        [book('Epic', genre: 'Fantasy')],
        preferences: ['Fantasy'],
        ratings: {keyOf('Epic'): const RatingSummary(average: 5, count: 3)},
      );
      expect(result.single.signal, RecommendationSignal.rating);
      expect(result.single.reason, 'Highly rated · 5.0 from 3 reviews');
    });

    test('a single book you only plan to read is not enough', () {
      final result = recommend(
        [book('Epic')],
        reading: [read('a', status: ReadingStatus.planToRead)],
      );
      expect(result, isEmpty);
      expect(
        recommend([book('Epic')], reading: [read('a')]),
        hasLength(1),
        reason: 'one finished book is',
      );
    });

    test('plan-to-read counts less than finished', () {
      final planned = tasteProfile([
        read('a', status: ReadingStatus.planToRead),
      ]);
      final done = tasteProfile([read('a')]);
      expect(planned['fantasy']!, lessThan(done['fantasy']!));
    });

    test('generic genres say nothing about taste', () {
      final taste = tasteProfile([read('a', genre: 'Fiction, Other')]);
      expect(taste.keys, isNot(contains('fiction')));
      expect(taste.keys, isNot(contains('other')));
    });
  });

  group('Discover strip', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    final hailMary = book(
      'Project Hail Mary',
      owner: 'owner-2',
      genre: 'Science fiction',
      author: 'Andy Weir',
    );

    Future<void> openDiscover(
      WidgetTester tester, {
      List<Book>? books,
      bool wanted = true,
      List<ReadingEntry> reading = const [],
      List<Override> more = const [],
    }) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await signInWithFixtures(
        tester,
        overrides: [
          allBooksProvider.overrideWith(
            (ref) => Stream.value(books ?? [hailMary]),
          ),
          myReadingProvider.overrideWith((ref) => Stream.value(reading)),
          if (!wanted)
            myWantedBooksProvider.overrideWith((ref) => Stream.value(const [])),
          ...more,
        ],
      );
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/discover');
      await tester.pumpAndSettle();
    }

    testWidgets('shows picks with the reason', (tester) async {
      await openDiscover(tester);
      expect(find.text('Recommended for you'), findsOneWidget);
      expect(find.text('On your wishlist'), findsOneWidget);
    });

    testWidgets('is absent when nothing is worth suggesting', (tester) async {
      await openDiscover(
        tester,
        books: [book('Dry', genre: 'History', owner: 'owner-2')],
        wanted: false,
      );
      expect(find.text('Recommended for you'), findsNothing);
    });

    testWidgets('steps aside while searching', (tester) async {
      await openDiscover(tester);
      await tester.enterText(find.byType(TextField).first, 'hail');
      await tester.pumpAndSettle();
      expect(find.text('Recommended for you'), findsNothing);
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();
      expect(find.text('Recommended for you'), findsOneWidget);
    });

    testWidgets('steps aside while a filter is on', (tester) async {
      await openDiscover(
        tester,
        more: [
          discoveryFilterProvider.overrideWith(
            (ref) => const DiscoveryFilter(genres: {'Fantasy'}),
          ),
        ],
      );
      expect(find.text('Recommended for you'), findsNothing);
    });

    testWidgets('tapping a card opens the book', (tester) async {
      await openDiscover(tester);
      await tester.tap(find.text('On your wishlist'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Close'), findsOneWidget);
    });

    testWidgets('"Not interested" removes the card', (tester) async {
      await openDiscover(tester);
      await tester.tap(find.byTooltip('Not interested in Project Hail Mary'));
      await tester.pumpAndSettle();
      expect(find.text('Recommended for you'), findsNothing);
      // The book is still in the normal results.
      expect(find.text('Project Hail Mary'), findsOneWidget);
    });

    testWidgets('a pick is spoken with its reason', (tester) async {
      final handle = tester.ensureSemantics();
      await openDiscover(tester);
      expect(
        find.bySemanticsLabel(
          'Project Hail Mary by Andy Weir. On your wishlist',
        ),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('fits at twice the text size', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await openDiscover(tester);
      expect(find.text('Recommended for you'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
