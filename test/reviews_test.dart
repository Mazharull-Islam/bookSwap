import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/reviews/application/use_cases/review_use_cases.dart';
import 'package:bookswap_login/features/reviews/domain/models/book_review.dart';
import 'package:bookswap_login/features/reviews/domain/rating_summary.dart';
import 'package:bookswap_login/features/reviews/domain/repositories/review_repository.dart';
import 'package:bookswap_login/features/reviews/presentation/providers/review_providers.dart';
import 'support/test_app.dart';

BookReview review(
  String id, {
  String key = 'dune|frank herbert',
  int rating = 4,
  int created = 0,
}) => BookReview(
  id: id,
  requestId: id,
  reviewerId: 'u-$id',
  reviewerName: 'Reviewer $id',
  bookId: 'b',
  bookTitle: 'Dune',
  matchKey: key,
  rating: rating,
  createdAtMs: created,
  updatedAtMs: created,
);

void main() {
  group('rating summaries', () {
    test('average and count per book', () {
      final summaries = summarizeRatings([
        review('a', rating: 5),
        review('b', rating: 4),
        review('c', rating: 3, key: 'other'),
      ]);
      expect(summaries['dune|frank herbert']?.count, 2);
      expect(summaries['dune|frank herbert']?.average, 4.5);
      expect(summaries['dune|frank herbert']?.averageLabel, '4.5');
      expect(summaries['other']?.averageLabel, '3.0');
      expect(summaries['none'], isNull);
    });

    test('spoken text pluralises', () {
      expect(
        summarizeRatings([
          review('a', rating: 5),
        ])['dune|frank herbert']!.spoken,
        'Rated 5.0 out of 5 from 1 review',
      );
    });

    test('reviewsForBook filters and sorts newest first', () {
      final result = reviewsForBook([
        review('old', created: 1),
        review('new', created: 9),
        review('x', key: 'other', created: 5),
      ], 'dune|frank herbert');
      expect(result.map((r) => r.id), ['new', 'old']);
    });

    test('reviewMatchKey matches discovery grouping', () {
      expect(
        reviewMatchKey(workKey: '/works/OL1W', title: 'Dune', author: 'F'),
        '/works/OL1W',
      );
      expect(
        reviewMatchKey(workKey: null, title: ' Dune ', author: 'Frank Herbert'),
        'dune|frank herbert',
      );
    });
  });

  group('SubmitReview', () {
    Future<BookReview> submit(
      InMemoryReviewRepository repo, {
      BookReview? existing,
      int rating = 4,
      String text = 'Good',
    }) => SubmitReview(repo)(
      existing: existing,
      requestId: 'r1',
      reviewerId: 'me',
      reviewerName: 'Me',
      bookId: 'b',
      bookTitle: 'Dune',
      matchKey: 'dune|frank herbert',
      rating: rating,
      text: text,
      now: DateTime.fromMillisecondsSinceEpoch(5000),
    );

    test('saves a trimmed review keyed by the loan', () async {
      final repo = InMemoryReviewRepository();
      final saved = await submit(repo, text: '  Loved it  ');
      expect(saved.id, 'r1');
      expect(saved.text, 'Loved it');
      expect(saved.createdAtMs, 5000);
      expect(repo.saved, [saved]);
    });

    test('rejects ratings outside 1-5', () async {
      final repo = InMemoryReviewRepository();
      expect(
        () => submit(repo, rating: 0),
        throwsA(isA<ReviewValidationFailure>()),
      );
      expect(
        () => submit(repo, rating: 6),
        throwsA(isA<ReviewValidationFailure>()),
      );
      expect(repo.saved, isEmpty);
    });

    test('rejects over-long text', () async {
      final repo = InMemoryReviewRepository();
      expect(
        () => submit(repo, text: 'x' * (maxReviewLength + 1)),
        throwsA(isA<ReviewValidationFailure>()),
      );
    });

    test('editing keeps the original creation time and key', () async {
      final repo = InMemoryReviewRepository();
      final first = await submit(repo);
      final edited = await SubmitReview(repo)(
        existing: first,
        requestId: 'r1',
        reviewerId: 'me',
        reviewerName: 'Me',
        bookId: 'b',
        bookTitle: 'Dune',
        matchKey: 'something-else',
        rating: 2,
        text: 'Changed my mind',
        now: DateTime.fromMillisecondsSinceEpoch(9000),
      );
      expect(edited.createdAtMs, 5000);
      expect(edited.updatedAtMs, 9000);
      expect(edited.matchKey, 'dune|frank herbert');
      expect(edited.rating, 2);
    });
  });

  group('screens', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    Future<InMemoryReviewRepository> openHistory(
      WidgetTester tester, {
      List<BookReview> seed = const [],
    }) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = InMemoryReviewRepository(seed);
      await signInWithFixtures(
        tester,
        overrides: [reviewRepositoryProvider.overrideWithValue(repo)],
      );
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/requests');
      await tester.pumpAndSettle();
      await tapVisible(tester, find.text('History'));
      return repo;
    }

    testWidgets('only borrowed, returned loans can be rated', (tester) async {
      await openHistory(tester);
      expect(find.byKey(const Key('rate-out-3')), findsOneWidget);
      expect(find.text('Rate this book'), findsOneWidget);
    });

    testWidgets('rating a book saves a review keyed to the loan', (
      tester,
    ) async {
      final repo = await openHistory(tester);
      await tapVisible(tester, find.byKey(const Key('rate-out-3')));
      await tapVisible(tester, find.byTooltip('4 stars'));
      await tester.enterText(find.byKey(const Key('reviewText')), 'A classic.');
      await tapVisible(tester, find.byKey(const Key('saveReview')));
      expect(repo.saved, hasLength(1));
      final saved = repo.saved.single;
      expect(saved.id, 'out-3');
      expect(saved.rating, 4);
      expect(saved.text, 'A classic.');
      expect(saved.matchKey, 'dune|frank herbert');
      expect(saved.reviewerId, 'demo-reader');
      // Back on the card: your stars and an edit button replace the prompt.
      expect(find.byKey(const Key('rate-out-3')), findsNothing);
      expect(find.byKey(const Key('edit-review-out-3')), findsOneWidget);
    });

    testWidgets('submitting without a rating explains what to do', (
      tester,
    ) async {
      final repo = await openHistory(tester);
      await tapVisible(tester, find.byKey(const Key('rate-out-3')));
      await tapVisible(tester, find.byKey(const Key('saveReview')));
      expect(find.text('Choose a rating from 1 to 5 stars.'), findsOneWidget);
      expect(repo.saved, isEmpty);
    });

    testWidgets('an existing review can be edited and deleted', (tester) async {
      final mine = BookReview(
        id: 'out-3',
        requestId: 'out-3',
        reviewerId: 'demo-reader',
        reviewerName: 'Reader',
        bookId: 'o-1',
        bookTitle: 'Dune',
        matchKey: 'dune|frank herbert',
        rating: 2,
        text: 'Meh',
        createdAtMs: 1000,
        updatedAtMs: 1000,
      );
      final repo = await openHistory(tester, seed: [mine]);
      expect(find.byKey(const Key('rate-out-3')), findsNothing);

      await tapVisible(tester, find.byKey(const Key('edit-review-out-3')));
      await tapVisible(tester, find.byTooltip('5 stars'));
      await tapVisible(tester, find.byKey(const Key('saveReview')));
      expect(repo.saved.single.rating, 5);
      expect(repo.saved.single.createdAtMs, 1000);

      await tapVisible(tester, find.byKey(const Key('edit-review-out-3')));
      await tapVisible(tester, find.byKey(const Key('deleteReview')));
      expect(repo.deleted, ['out-3']);
      expect(find.byKey(const Key('rate-out-3')), findsOneWidget);
    });

    testWidgets('Discover shows each book\'s rating and its reviews', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await signInWithFixtures(tester);
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/discover');
      await tester.pumpAndSettle();
      expect(find.text('4.0 (2)'), findsOneWidget);

      await tapVisible(tester, find.text('2 members'));
      expect(find.text('Reviews'), findsOneWidget);
      expect(find.text('4.0 · 2 reviews'), findsOneWidget);
      expect(find.text('Rafi'), findsWidgets);
      expect(find.text('Brilliant world-building.'), findsOneWidget);
      expect(find.text('Slow start.'), findsOneWidget);
    });
  });
}
