import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/book_of_month/application/use_cases/book_of_month_use_cases.dart';
import 'package:bookswap_login/features/book_of_month/domain/entities/book_of_month_nomination.dart';
import 'package:bookswap_login/features/book_of_month/domain/entities/book_of_month_period.dart';
import 'package:bookswap_login/features/book_of_month/domain/entities/book_of_month_vote.dart';
import 'package:bookswap_login/features/book_of_month/domain/repositories/book_of_month_repository.dart';
import 'package:bookswap_login/features/book_of_month/presentation/providers/book_of_month_providers.dart';
import 'package:bookswap_login/features/forum/domain/repositories/forum_repository.dart';
import 'package:bookswap_login/features/leaderboard/domain/entities/reading_activity.dart';
import 'package:bookswap_login/features/leaderboard/presentation/providers/leaderboard_providers.dart';
import 'package:bookswap_login/shared/domain/period.dart';
import 'package:bookswap_login/shared/widgets/period_selector.dart';
import 'support/test_app.dart';

class _Unused implements BookOfMonthRepository, ForumRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

/// Records which months a discussion thread was requested for.
class _RecordingThread extends EnsureDiscussionThread {
  _RecordingThread() : super(_Unused(), _Unused());
  final months = <String>[];

  @override
  Future<void> call({
    required BookOfMonthPeriod period,
    required bool hasNominations,
    required String authorId,
    required String authorName,
  }) async => months.add(period.id);
}

void main() {
  group('recentPeriodIds', () {
    test('is the current month and the two before it, newest first', () {
      expect(recentPeriodIds(now: DateTime(2026, 10, 15)), [
        '2026-10',
        '2026-09',
        '2026-08',
      ]);
    });

    test('counts back across a year end', () {
      expect(recentPeriodIds(now: DateTime(2026, 1, 10)), [
        '2026-01',
        '2025-12',
        '2025-11',
      ]);
      expect(recentPeriodIds(now: DateTime(2026, 2, 1)), [
        '2026-02',
        '2026-01',
        '2025-12',
      ]);
    });

    test('how far back is adjustable', () {
      final now = DateTime(2026, 10, 15);
      expect(recentPeriodIds(previous: 0, now: now), ['2026-10']);
      expect(recentPeriodIds(previous: 1, now: now), ['2026-10', '2026-09']);
    });

    test('shows only two previous months by default', () {
      expect(previousPeriodsShown, 2);
      expect(recentPeriodIds(), hasLength(3));
    });

    test('starts at the current period', () {
      expect(recentPeriodIds().first, currentPeriodId());
      expect(currentPeriodId(), matches(RegExp(r'^\d{4}-\d{2}$')));
    });

    test('labels read as month names, including across the year end', () {
      expect(periodLabel('2025-12'), 'December 2025');
      expect(periodLabel('2026-01'), 'January 2026');
    });
  });

  group('PeriodSelector', () {
    Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

    testWidgets('shows a chip per month, with the chosen one selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          PeriodSelector(
            periods: const ['2026-10', '2026-09', '2026-08'],
            selected: '2026-09',
            onSelected: (_) {},
          ),
        ),
      );
      expect(find.byType(ChoiceChip), findsNWidgets(3));
      bool selected(String label) => tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, label))
          .selected;
      expect(selected('September 2026'), isTrue);
      expect(selected('October 2026'), isFalse);
      expect(selected('August 2026'), isFalse);
    });

    testWidgets('tapping a month reports its id', (tester) async {
      String? picked;
      await tester.pumpWidget(
        host(
          PeriodSelector(
            periods: const ['2026-10', '2026-09'],
            selected: '2026-10',
            onSelected: (id) => picked = id,
          ),
        ),
      );
      await tester.tap(find.text('September 2026'));
      expect(picked, '2026-09');
    });
  });

  group('screens', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    final months = recentPeriodIds();
    final now = months[0];
    final last = months[1];
    final older = months[2];

    Future<void> open(
      WidgetTester tester,
      String route, {
      List<Override> more = const [],
    }) async {
      tester.view.physicalSize = const Size(390, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await signInWithFixtures(tester, overrides: more);
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go(route);
      await tester.pumpAndSettle();
    }

    Future<void> chooseMonth(WidgetTester tester, String period) async {
      await tester.tap(find.widgetWithText(ChoiceChip, periodLabel(period)));
      await tester.pumpAndSettle();
    }

    group('Leaderboard', () {
      ReadingActivity read(
        String id,
        String user,
        String name,
        String period,
      ) => ReadingActivity(
        id: id,
        userId: user,
        userName: name,
        author: 'Some Author',
        periodId: period,
        markedReadAtMs: 1,
      );

      List<Override> activity() => [
        readingActivityProvider.overrideWith(
          (ref, periodId) => Stream.value([
            if (periodId == now) read('a', 'owner-2', 'Rafi', now),
            if (periodId == last) read('b', 'owner-3', 'Nadia', last),
          ]),
        ),
      ];

      testWidgets('offers this month and the two before it', (tester) async {
        await open(tester, '/leaderboard', more: activity());
        expect(find.byType(ChoiceChip), findsNWidgets(3));
        for (final period in months) {
          expect(find.text(periodLabel(period)), findsOneWidget);
        }
        final current = tester.widget<ChoiceChip>(
          find.widgetWithText(ChoiceChip, periodLabel(now)),
        );
        expect(current.selected, isTrue);
        expect(find.text('Rafi'), findsOneWidget);
      });

      testWidgets('does not offer a fourth month', (tester) async {
        await open(tester, '/leaderboard', more: activity());
        final fourth = DateTime(DateTime.now().year, DateTime.now().month - 3);
        final id = '${fourth.year}-${fourth.month.toString().padLeft(2, '0')}';
        expect(find.text(periodLabel(id)), findsNothing);
      });

      testWidgets('choosing last month shows that month\'s readers', (
        tester,
      ) async {
        await open(tester, '/leaderboard', more: activity());
        await chooseMonth(tester, last);
        expect(find.text('Nadia'), findsOneWidget);
        expect(find.text('Rafi'), findsNothing);
        expect(
          tester
              .widget<ChoiceChip>(
                find.widgetWithText(ChoiceChip, periodLabel(last)),
              )
              .selected,
          isTrue,
        );
      });

      testWidgets('an empty earlier month says which month it was', (
        tester,
      ) async {
        await open(tester, '/leaderboard', more: activity());
        await chooseMonth(tester, older);
        expect(
          find.text('No books were marked Read in ${periodLabel(older)}.'),
          findsOneWidget,
        );
        await tester.tap(find.text('Popular Authors'));
        await tester.pumpAndSettle();
        expect(
          find.text('No authors were recorded in ${periodLabel(older)}.'),
          findsOneWidget,
        );
      });

      testWidgets('an empty current month keeps its original wording', (
        tester,
      ) async {
        await open(
          tester,
          '/leaderboard',
          more: [
            readingActivityProvider.overrideWith(
              (ref, periodId) => Stream.value(const <ReadingActivity>[]),
            ),
          ],
        );
        expect(
          find.text('No books marked Read this month yet.'),
          findsOneWidget,
        );
      });

      testWidgets('goes back to this month after leaving the screen', (
        tester,
      ) async {
        await open(tester, '/leaderboard', more: activity());
        await chooseMonth(tester, last);
        GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/more');
        await tester.pumpAndSettle();
        GoRouter.of(
          tester.element(find.byType(Scaffold).first),
        ).go('/leaderboard');
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<ChoiceChip>(
                find.widgetWithText(ChoiceChip, periodLabel(now)),
              )
              .selected,
          isTrue,
        );
        expect(find.text('Rafi'), findsOneWidget);
      });
    });

    group('Book of the Month', () {
      BookOfMonthNomination nomination(
        String period,
        String title,
        String key,
      ) => BookOfMonthNomination(
        id: '${period}_$key',
        periodId: period,
        matchKey: key,
        title: title,
        author: 'An Author',
        nominatedBy: 'owner-2',
        nominatedByName: 'Rafi',
        nominatedAtMs: 1,
      );

      late _RecordingThread thread;

      List<Override> data({String? lastThread, String? nowThread}) {
        thread = _RecordingThread();
        return [
          ensureDiscussionThreadProvider.overrideWithValue(thread),
          nominationsProvider.overrideWith(
            (ref, periodId) => Stream.value([
              if (periodId == now) nomination(now, 'Dune', 'dune'),
              if (periodId == last) nomination(last, 'Emma', 'emma'),
              // Not voted for, so a vote button here would be a leak.
              if (periodId == last)
                nomination(last, 'Persuasion', 'persuasion'),
            ]),
          ),
          votesProvider.overrideWith(
            (ref, periodId) => Stream.value([
              if (periodId == last)
                BookOfMonthVote(
                  id: '${last}_demo-reader',
                  periodId: last,
                  userId: 'demo-reader',
                  matchKey: 'emma',
                  votedAtMs: 1,
                ),
              if (periodId == last)
                BookOfMonthVote(
                  id: '${last}_owner-2',
                  periodId: last,
                  userId: 'owner-2',
                  matchKey: 'emma',
                  votedAtMs: 2,
                ),
            ]),
          ),
          periodInfoProvider.overrideWith(
            (ref, periodId) => Stream.value(
              periodId == last
                  ? BookOfMonthPeriod(id: last, discussionPostId: lastThread)
                  : periodId == now
                  ? BookOfMonthPeriod(id: now, discussionPostId: nowThread)
                  : null,
            ),
          ),
        ];
      }

      testWidgets('this month can be nominated for and voted in', (
        tester,
      ) async {
        await open(tester, '/book-of-month', more: data(nowThread: 'post'));
        expect(find.byType(ChoiceChip), findsNWidgets(3));
        expect(find.text('Nominate a book'), findsOneWidget);
        expect(find.text('Dune'), findsOneWidget);
        expect(find.text('Vote'), findsOneWidget);
      });

      testWidgets('an earlier month is read-only', (tester) async {
        await open(tester, '/book-of-month', more: data());
        await chooseMonth(tester, last);
        expect(find.text('Emma'), findsOneWidget);
        expect(find.text('Dune'), findsNothing);
        expect(find.text('Nominate a book'), findsNothing);
        expect(find.text('Vote'), findsNothing);
        expect(find.textContaining('2 votes'), findsOneWidget);
      });

      testWidgets('an earlier month still shows how I voted', (tester) async {
        await open(tester, '/book-of-month', more: data());
        await chooseMonth(tester, last);
        expect(find.text('Voted ✓'), findsOneWidget);
      });

      testWidgets('an empty earlier month says which month it was', (
        tester,
      ) async {
        await open(tester, '/book-of-month', more: data());
        await chooseMonth(tester, older);
        expect(
          find.text('No books were nominated in ${periodLabel(older)}.'),
          findsOneWidget,
        );
      });

      testWidgets('an earlier month links to its own discussion', (
        tester,
      ) async {
        await open(
          tester,
          '/book-of-month',
          more: data(lastThread: 'old-post'),
        );
        await chooseMonth(tester, last);
        expect(find.text('Open that month\'s discussion'), findsOneWidget);
        await chooseMonth(tester, now);
        expect(find.text('Open that month\'s discussion'), findsNothing);
      });

      testWidgets('a discussion thread is only started for this month', (
        tester,
      ) async {
        // Both months have nominations and no thread yet.
        await open(tester, '/book-of-month', more: data());
        expect(thread.months, [now]);
        await chooseMonth(tester, last);
        expect(thread.months, [
          now,
        ], reason: 'viewing last month starts nothing');
      });

      testWidgets('the old unlimited "Past picks" list is gone', (
        tester,
      ) async {
        await open(tester, '/book-of-month', more: data(nowThread: 'post'));
        expect(find.text('Past picks'), findsNothing);
      });

      testWidgets('goes back to this month after leaving the screen', (
        tester,
      ) async {
        await open(tester, '/book-of-month', more: data(nowThread: 'post'));
        await chooseMonth(tester, last);
        GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/more');
        await tester.pumpAndSettle();
        GoRouter.of(
          tester.element(find.byType(Scaffold).first),
        ).go('/book-of-month');
        await tester.pumpAndSettle();
        expect(find.text('Nominate a book'), findsOneWidget);
      });
    });
  });
}
