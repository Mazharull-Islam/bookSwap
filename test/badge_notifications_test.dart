import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/features/borrow_requests/domain/entities/borrow_request.dart';
import 'package:bookswap_login/features/borrow_requests/presentation/providers/request_providers.dart';
import 'package:bookswap_login/features/reading/domain/entities/reading_entry.dart';
import 'package:bookswap_login/features/reading/presentation/providers/reading_providers.dart';
import 'package:bookswap_login/features/reputation/domain/badge_notifications.dart';
import 'package:bookswap_login/features/reputation/domain/entities/achievement_badge.dart';
import 'package:bookswap_login/features/reputation/presentation/providers/reputation_providers.dart';
import 'support/test_app.dart';

const _completedLoan = BorrowRequest(
  id: 'done',
  bookId: 'b',
  bookTitle: 'Dune',
  borrowerId: 'demo-reader',
  lenderId: 'owner-2',
  status: RequestStatus.accepted,
  requestedAt: 1,
  returnedAt: 2,
);

void main() {
  group('planBadgeNotifications', () {
    test('a new device records existing badges without announcing them', () {
      final plan = planBadgeNotifications(
        hasBaseline: false,
        seen: const {},
        earned: [AchievementBadge.firstLoan],
      );
      expect(plan.announce, isEmpty);
      expect(plan.store, {'firstLoan'});
    });

    test('announces only badges not seen before', () {
      final plan = planBadgeNotifications(
        hasBaseline: true,
        seen: const {'firstLoan'},
        earned: [AchievementBadge.firstLoan, AchievementBadge.bookworm],
      );
      expect(plan.announce, [AchievementBadge.bookworm]);
      expect(plan.store, {'firstLoan', 'bookworm'});
    });

    test('a smaller list never shrinks the seen set', () {
      final plan = planBadgeNotifications(
        hasBaseline: true,
        seen: const {'firstLoan', 'bookworm'},
        earned: const [],
      );
      expect(plan.announce, isEmpty);
      expect(plan.store, {'firstLoan', 'bookworm'});
    });

    test('a badge that vanishes and returns is not announced again', () {
      var seen = <String>{'firstLoan'};
      for (final earned in [
        <AchievementBadge>[],
        [AchievementBadge.firstLoan],
      ]) {
        final plan = planBadgeNotifications(
          hasBaseline: true,
          seen: seen,
          earned: earned,
        );
        expect(plan.announce, isEmpty);
        seen = plan.store;
      }
    });
  });

  group('badgeStateProvider readiness', () {
    test('is not ready until every source has loaded', () async {
      final incoming = StreamController<List<BorrowRequest>>();
      final outgoing = StreamController<List<BorrowRequest>>();
      final reading = StreamController<List<ReadingEntry>>();
      addTearDown(() {
        incoming.close();
        outgoing.close();
        reading.close();
      });
      final container = ProviderContainer(
        overrides: [
          incomingRequestsProvider.overrideWith((ref) => incoming.stream),
          outgoingRequestsProvider.overrideWith((ref) => outgoing.stream),
          myReadingProvider.overrideWith((ref) => reading.stream),
        ],
      );
      addTearDown(container.dispose);
      container.listen(badgeStateProvider, (_, _) {});

      expect(container.read(badgeStateProvider).ready, isFalse);

      outgoing.add([_completedLoan]);
      await container.pump();
      // A badge-earning loan has loaded, but two sources are still pending.
      expect(container.read(badgeStateProvider).ready, isFalse);

      incoming.add(const []);
      reading.add(const []);
      await container.pump();
      final state = container.read(badgeStateProvider);
      expect(state.ready, isTrue);
      expect(state.badges, [AchievementBadge.firstLoan]);
    });
  });

  group('toast on screen', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    // The default fixtures include a returned loan the member borrowed, so
    // First Loan is earned.

    /// Runs the app for ten seconds in 100ms steps and returns how many
    /// separate times a badge toast appeared (a toast lives about 3.4s, so
    /// checking only at the end would miss it).
    Future<int> toastAppearances(WidgetTester tester) async {
      var appearances = 0;
      var visible = false;
      for (var i = 0; i < 100; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        final now = find.textContaining('Badge earned').evaluate().isNotEmpty;
        if (now && !visible) appearances++;
        visible = now;
      }
      return appearances;
    }

    Future<int> signInAndWatch(
      WidgetTester tester,
      InMemorySeenBadges seen, {
      List<Override> overrides = const [],
    }) async {
      await signInWithFixtures(
        tester,
        overrides: [
          seenBadgesRepositoryProvider.overrideWithValue(seen),
          ...overrides,
        ],
      );
      return toastAppearances(tester);
    }

    testWidgets('no toast for a badge already earned on a fresh device', (
      tester,
    ) async {
      final seen = InMemorySeenBadges();
      expect(await signInAndWatch(tester, seen), 0);
      expect(seen.data['demo-reader'], {'firstLoan'});
    });

    testWidgets('no toast when data arrives in stages on a fresh device', (
      tester,
    ) async {
      // Reading loads at once (and is empty); the loan loads late. The old
      // watcher recorded an empty baseline from the first event and then
      // announced First Loan as new.
      final seen = InMemorySeenBadges();
      final appearances = await signInAndWatch(
        tester,
        seen,
        overrides: [
          myReadingProvider.overrideWith((ref) => Stream.value(const [])),
          outgoingRequestsProvider.overrideWith((ref) async* {
            await Future<void>.delayed(const Duration(milliseconds: 500));
            yield [_completedLoan];
          }),
        ],
      );
      expect(appearances, 0);
      expect(seen.data['demo-reader'], {'firstLoan'});
    });

    testWidgets('no toast on later logins once the badge has been seen', (
      tester,
    ) async {
      final seen = InMemorySeenBadges({
        'demo-reader': {'firstLoan'},
      });
      expect(await signInAndWatch(tester, seen), 0);
      expect(seen.data['demo-reader'], {'firstLoan'});
    });

    testWidgets('a genuinely new badge is announced exactly once', (
      tester,
    ) async {
      final seen = InMemorySeenBadges({'demo-reader': <String>{}});
      expect(await signInAndWatch(tester, seen), 1);
      expect(seen.data['demo-reader'], {'firstLoan'});
    });
  });
}
