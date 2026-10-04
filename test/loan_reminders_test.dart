import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/core/services/reminder_gateway.dart';
import 'package:bookswap_login/features/borrow_requests/domain/loan_reminders.dart';
import 'package:bookswap_login/features/borrow_requests/domain/entities/borrow_request.dart';
import 'package:bookswap_login/features/borrow_requests/presentation/providers/reminder_providers.dart';
import 'package:bookswap_login/features/borrow_requests/presentation/providers/request_providers.dart';
import 'support/fake_reminder_gateway.dart';
import 'support/test_app.dart';

const me = 'demo-reader';

BorrowRequest loan(
  String id, {
  String title = 'Dune',
  String borrower = me,
  String lender = 'owner-2',
  RequestStatus status = RequestStatus.accepted,
  DateTime? due,
  bool returned = false,
}) => BorrowRequest(
  id: id,
  bookId: 'b-$id',
  bookTitle: title,
  borrowerId: borrower,
  lenderId: lender,
  status: status,
  requestedAt: 0,
  expectedReturnDateMs: due?.millisecondsSinceEpoch,
  returnedAt: returned ? 1 : null,
);

final due = DateTime(2026, 10, 15);
final earlier = DateTime(2026, 10, 10, 12);

List<PlannedReminder> plan(
  List<BorrowRequest> requests, {
  DateTime? now,
  String who = me,
}) => planReminders(myId: who, requests: requests, now: now ?? earlier);

void main() {
  group('planning', () {
    test('a borrower gets three reminders around the due date', () {
      final reminders = plan([loan('a', due: due)]);
      expect(reminders.map((r) => r.kind), [
        ReminderKind.dayBefore,
        ReminderKind.dueDay,
        ReminderKind.overdue,
      ]);
      expect(reminders.map((r) => r.at), [
        DateTime(2026, 10, 14, reminderHour),
        DateTime(2026, 10, 15, reminderHour),
        DateTime(2026, 10, 16, reminderHour),
      ]);
      expect(reminders[0].body, "'Dune' is due back tomorrow.");
      expect(reminders[1].body, "'Dune' is due back today.");
      expect(reminders[2].body, contains('Arrange the return'));
    });

    test('a lender gets the same schedule with lender wording', () {
      final reminders = plan([
        loan('a', borrower: 'owner-2', lender: me, due: due),
      ]);
      expect(reminders, hasLength(3));
      expect(reminders[0].body, contains('from the borrower tomorrow'));
      expect(reminders[2].body, contains("hasn't come back"));
    });

    test('only active loans of mine are planned', () {
      expect(
        plan([loan('p', status: RequestStatus.pending, due: due)]),
        isEmpty,
      );
      expect(
        plan([loan('d', status: RequestStatus.declined, due: due)]),
        isEmpty,
      );
      expect(plan([loan('r', due: due, returned: true)]), isEmpty);
      expect(plan([loan('n')]), isEmpty, reason: 'no return date');
      expect(
        plan([loan('x', borrower: 'a', lender: 'b', due: due)]),
        isEmpty,
        reason: 'someone else\'s loan',
      );
    });

    test('reminders already in the past are dropped', () {
      // On the due date after 9:00: only the overdue nudge is left.
      expect(
        plan([
          loan('a', due: due),
        ], now: DateTime(2026, 10, 15, 10)).map((r) => r.kind),
        [ReminderKind.overdue],
      );
      // Before 9:00 on the due date, the due-day reminder is still to come.
      expect(
        plan([
          loan('a', due: due),
        ], now: DateTime(2026, 10, 15, 8)).map((r) => r.kind),
        [ReminderKind.dueDay, ReminderKind.overdue],
      );
    });

    test('a long-overdue loan produces nothing instead of a burst', () {
      expect(plan([loan('a', due: due)], now: DateTime(2026, 11, 1)), isEmpty);
    });

    test('ids are stable, distinct per loan and kind, and fit 32 bits', () {
      final a = plan([loan('a', due: due)]);
      final again = plan([loan('a', due: due)]);
      expect(a.map((r) => r.id), again.map((r) => r.id));
      final b = plan([loan('b', due: due)]);
      final ids = {...a.map((r) => r.id), ...b.map((r) => r.id)};
      expect(ids, hasLength(6));
      for (final id in ids) {
        expect(id, inInclusiveRange(0, 0x7FFFFFFF));
      }
    });

    test('moving the due date keeps the id but changes the payload', () {
      final before = plan([loan('a', due: due)]).first;
      final after = plan([
        loan('a', due: due.add(const Duration(days: 3))),
      ]).first;
      expect(after.id, before.id);
      expect(after.payload, isNot(before.payload));
    });

    test('everything comes back soonest first across loans', () {
      final all = plan([
        loan('late', due: DateTime(2026, 10, 20)),
        loan('soon', title: 'Emma', due: DateTime(2026, 10, 12)),
      ]);
      final times = all.map((r) => r.at).toList();
      expect([...times]..sort(), times);
      expect(all.first.body, contains('Emma'));
    });
  });

  group('scheduler', () {
    late FakeReminderGateway gateway;
    late ReminderScheduler scheduler;

    setUp(() {
      gateway = FakeReminderGateway();
      scheduler = ReminderScheduler(gateway);
    });

    test('schedules what is wanted', () async {
      await scheduler.apply(plan([loan('a', due: due)]));
      expect(gateway.waiting, hasLength(3));
    });

    test('applying the same plan again does nothing', () async {
      final wanted = plan([loan('a', due: due)]);
      await scheduler.apply(wanted);
      gateway.log.clear();
      await scheduler.apply(wanted);
      expect(gateway.log, isEmpty);
    });

    test('a changed due date reschedules only that loan', () async {
      await scheduler.apply(
        plan([loan('a', due: due), loan('b', due: DateTime(2026, 10, 20))]),
      );
      gateway.log.clear();
      await scheduler.apply(
        plan([
          loan('a', due: DateTime(2026, 10, 18)),
          loan('b', due: DateTime(2026, 10, 20)),
        ]),
      );
      expect(gateway.log, hasLength(3));
      expect(
        gateway.log.every((l) => l.startsWith('schedule') && l.endsWith(' a')),
        isTrue,
      );
      expect(
        gateway.waiting.where((r) => r.requestId == 'a').first.at,
        DateTime(2026, 10, 17, reminderHour),
      );
    });

    test('a returned loan loses its reminders', () async {
      await scheduler.apply(plan([loan('a', due: due), loan('b', due: due)]));
      await scheduler.apply(
        plan([loan('a', due: due, returned: true), loan('b', due: due)]),
      );
      expect(gateway.waiting.map((r) => r.requestId).toSet(), {'b'});
    });

    test('leftovers from another account are cancelled', () async {
      await scheduler.apply(plan([loan('theirs', due: due)], who: me));
      await scheduler.apply(plan([loan('mine', due: due)]));
      await scheduler.apply(const []);
      expect(gateway.waiting, isEmpty);
    });

    test('nothing is scheduled without permission, and it asks once', () async {
      gateway.allowed = false;
      await scheduler.apply(plan([loan('a', due: due)]));
      await scheduler.apply(plan([loan('b', due: due)]));
      expect(gateway.waiting, isEmpty);
      expect(gateway.permissionRequests, 1);
    });

    test('it does not ask for permission when nothing is wanted', () async {
      await scheduler.apply(const []);
      expect(gateway.permissionRequests, 0);
    });

    test('unsupported platforms are left alone', () async {
      final web = FakeReminderGateway(supported: false);
      final s = ReminderScheduler(web);
      await s.apply(plan([loan('a', due: due)]));
      await s.clear();
      expect(web.log, isEmpty);
      expect(web.permissionRequests, 0);
    });

    test('clear removes everything', () async {
      await scheduler.apply(plan([loan('a', due: due)]));
      await scheduler.clear();
      expect(gateway.waiting, isEmpty);
    });

    test('a failing gateway never breaks later work', () async {
      final flaky = _FlakyGateway();
      final s = ReminderScheduler(flaky);
      await s.apply(plan([loan('a', due: due)]));
      flaky.broken = false;
      await s.apply(plan([loan('a', due: due)]));
      expect(flaky.scheduled, hasLength(3));
    });
  });

  group('screens', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    final now = DateTime(2026, 10, 10, 12);
    final loans = [
      loan('out', due: due),
      loan('in', title: 'Emma', borrower: 'owner-3', lender: me, due: due),
      loan('done', due: due, returned: true),
    ];

    Future<FakeReminderGateway> open(
      WidgetTester tester, {
      FakeReminderGateway? gateway,
      String route = '/shelf',
    }) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final fake = gateway ?? FakeReminderGateway();
      await signInWithFixtures(
        tester,
        overrides: [
          reminderGatewayProvider.overrideWithValue(fake),
          reminderClockProvider.overrideWithValue(() => now),
          incomingRequestsProvider.overrideWith(
            (ref) =>
                Stream.value(loans.where((l) => l.lenderId == me).toList()),
          ),
          outgoingRequestsProvider.overrideWith(
            (ref) =>
                Stream.value(loans.where((l) => l.borrowerId == me).toList()),
          ),
        ],
      );
      if (route != '/shelf') {
        GoRouter.of(tester.element(find.byType(Scaffold).first)).go(route);
        await tester.pumpAndSettle();
      }
      return fake;
    }

    testWidgets('signing in schedules reminders for active loans only', (
      tester,
    ) async {
      final gateway = await open(tester);
      expect(gateway.waiting.map((r) => r.requestId).toSet(), {'out', 'in'});
      expect(gateway.waiting, hasLength(6));
    });

    testWidgets('turning the switch off cancels them all', (tester) async {
      final gateway = await open(tester, route: '/more');
      expect(gateway.waiting, isNotEmpty);
      await tapVisible(tester, find.byKey(const Key('loanRemindersSwitch')));
      expect(gateway.waiting, isEmpty);
    });

    testWidgets('turning it back on schedules them again', (tester) async {
      final gateway = await open(tester, route: '/more');
      await tapVisible(tester, find.byKey(const Key('loanRemindersSwitch')));
      await tapVisible(tester, find.byKey(const Key('loanRemindersSwitch')));
      expect(gateway.waiting, hasLength(6));
    });

    testWidgets('a blocked permission keeps it off and says why', (
      tester,
    ) async {
      final gateway = await open(tester, route: '/more');
      await tapVisible(tester, find.byKey(const Key('loanRemindersSwitch')));
      gateway.allowed = false;
      await tapVisible(tester, find.byKey(const Key('loanRemindersSwitch')));
      expect(find.textContaining('Notifications are blocked'), findsOneWidget);
      expect(gateway.waiting, isEmpty);
      expect(
        tester
            .widget<SwitchListTile>(
              find.byKey(const Key('loanRemindersSwitch')),
            )
            .value,
        isFalse,
      );
    });

    testWidgets('where reminders cannot work, the switch explains', (
      tester,
    ) async {
      final web = await open(
        tester,
        gateway: FakeReminderGateway(supported: false),
        route: '/more',
      );
      final tile = tester.widget<SwitchListTile>(
        find.byKey(const Key('loanRemindersSwitch')),
      );
      expect(tile.onChanged, isNull);
      expect(tile.value, isFalse);
      expect(
        find.text('Reminders need the BookSwap phone app.'),
        findsOneWidget,
      );
      expect(web.log, isEmpty);
    });

    testWidgets('signing out clears the reminders', (tester) async {
      final gateway = await open(tester, route: '/more');
      expect(gateway.waiting, isNotEmpty);
      await tapVisible(tester, find.text('Sign out'));
      expect(gateway.waiting, isEmpty);
    });
  });
}

class _FlakyGateway extends FakeReminderGateway {
  bool broken = true;

  @override
  Future<List<ScheduledReminder>> pending() async {
    if (broken) throw StateError('plugin hiccup');
    return super.pending();
  }
}
