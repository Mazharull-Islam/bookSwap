import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/core/utils/date_format.dart';
import 'package:bookswap_login/core/utils/friendly_error.dart';
import 'package:bookswap_login/features/borrow_requests/presentation/providers/request_providers.dart';
import 'support/demo_auth_repository.dart';
import 'support/fake_request_repository.dart';
import 'support/test_app.dart';

void main() {
  group('date helpers', () {
    test('formatDate', () {
      expect(formatDate(DateTime(2026, 10, 3)), 'Oct 3, 2026');
      expect(formatDate(DateTime(2027, 1, 21)), 'Jan 21, 2027');
    });
    test('dueText counts calendar days and spells out overdue', () {
      final now = DateTime(2026, 10, 3, 15);
      expect(dueText(DateTime(2026, 10, 3, 1), now: now), 'due today');
      expect(dueText(DateTime(2026, 10, 4), now: now), 'due tomorrow');
      expect(dueText(DateTime(2026, 10, 10), now: now), 'due in 7 days');
      expect(dueText(DateTime(2026, 10, 2), now: now), '1 day overdue');
      expect(dueText(DateTime(2026, 9, 28), now: now), '5 days overdue');
    });
  });

  group('friendlyError', () {
    test('maps Firestore codes to plain sentences', () {
      expect(
        friendlyError(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
          ),
        ),
        "You don't have permission to do that.",
      );
      expect(
        friendlyError(
          FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
        ),
        contains('Check your connection'),
      );
    });
    test('never leaks exception text', () {
      final message = friendlyError(Exception('boom: secret detail'));
      expect(message, isNot(contains('secret')));
      expect(message, isNot(contains('Exception')));
    });
  });

  group('screens', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    void phone(WidgetTester tester) {
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    Future<void> open(WidgetTester tester, String path) async {
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go(path);
      await tester.pumpAndSettle();
    }

    testWidgets('Profile shows who you are, not an onboarding banner', (
      tester,
    ) async {
      phone(tester);
      await signInDemo(tester);
      await open(tester, '/profile');
      expect(find.text('Reader Demo'), findsOneWidget);
      expect(find.text(DemoAuthRepository.email), findsOneWidget);
      expect(find.text('01712345678'), findsOneWidget);
      expect(find.textContaining('Welcome,'), findsNothing);
      expect(find.text('Sign out'), findsOneWidget);
    });

    testWidgets('Edit profile validates, saves and shows the new details', (
      tester,
    ) async {
      phone(tester);
      final repository = DemoAuthRepository();
      await signInDemo(tester, repository: repository);
      await open(tester, '/profile');
      await tapVisible(tester, find.byKey(const Key('editProfile')));
      expect(find.text('Edit profile'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('editMobile')), '123');
      await tapVisible(tester, find.byKey(const Key('saveProfile')));
      expect(find.textContaining('Use 10'), findsOneWidget);
      expect(repository.lastProfileUpdate, isNull);

      await tester.enterText(
        find.byKey(const Key('editMobile')),
        '+8801799999999',
      );
      await tester.enterText(find.byKey(const Key('editFirstName')), 'Rafi');
      await tester.pumpAndSettle();
      await tapVisible(tester, find.byKey(const Key('saveProfile')));
      expect(repository.lastProfileUpdate?.mobile, '+8801799999999');
      expect(find.text('Rafi Demo'), findsOneWidget);
      expect(find.text('+8801799999999'), findsOneWidget);
      expect(find.text('Profile updated.'), findsOneWidget);
    });

    testWidgets('Requests: dates read naturally, buttons say what they do', (
      tester,
    ) async {
      phone(tester);
      await signInDemo(tester);
      await open(tester, '/requests');
      expect(find.text('Decline request'), findsOneWidget);
      expect(find.text('Accept request'), findsOneWidget);
      expect(find.text('Approve extension'), findsOneWidget);
      expect(find.text('Decline extension'), findsOneWidget);
      expect(find.textContaining('due in'), findsWidgets);
      final iso = RegExp(r'\d{4}-\d{2}-\d{2}');
      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data ?? '');
      expect(texts.where(iso.hasMatch), isEmpty);
    });

    testWidgets('Requests: Decline asks first and can be cancelled', (
      tester,
    ) async {
      phone(tester);
      final fake = FakeRequestRepository();
      await signInDemo(
        tester,
        overrides: [requestRepositoryProvider.overrideWithValue(fake)],
      );
      await open(tester, '/requests');
      final dialog = find.byType(AlertDialog);

      await tapVisible(tester, find.text('Decline request'));
      expect(find.text('Decline this request?'), findsOneWidget);
      await tapVisible(tester, find.text('Cancel'));
      expect(fake.declined, isEmpty);

      await tapVisible(tester, find.text('Decline request'));
      await tapVisible(
        tester,
        find.descendant(of: dialog, matching: find.text('Decline request')),
      );
      expect(fake.declined, ['in-1']);
    });

    testWidgets('Requests: Mark as returned and Decline extension confirm', (
      tester,
    ) async {
      phone(tester);
      final fake = FakeRequestRepository();
      await signInDemo(
        tester,
        overrides: [requestRepositoryProvider.overrideWithValue(fake)],
      );
      await open(tester, '/requests');

      await tapVisible(tester, find.text('Mark as returned'));
      expect(find.text('Mark as returned?'), findsOneWidget);
      await tapVisible(tester, find.text('Cancel'));
      expect(fake.returned, isEmpty);

      await tapVisible(tester, find.text('Decline extension'));
      expect(find.text('Decline this extension?'), findsOneWidget);
      await tapVisible(tester, find.text('Cancel'));
      expect(fake.extensionsResolved, isEmpty);
    });

    testWidgets('Requests: failures show a friendly message', (tester) async {
      phone(tester);
      final fake = FakeRequestRepository()
        ..failWith = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
        );
      await signInDemo(
        tester,
        overrides: [requestRepositoryProvider.overrideWithValue(fake)],
      );
      await open(tester, '/requests');
      await tapVisible(tester, find.text('Decline request'));
      await tapVisible(
        tester,
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Decline request'),
        ),
      );
      expect(
        find.text("You don't have permission to do that."),
        findsOneWidget,
      );
      expect(find.textContaining('FirebaseException'), findsNothing);
    });
  });
}
