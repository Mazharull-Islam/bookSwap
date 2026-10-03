import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/features/authentication/data/repositories/firebase_auth_repository.dart';
import 'package:bookswap_login/features/authentication/domain/models/registration.dart';
import 'package:bookswap_login/features/authentication/domain/repositories/auth_repository.dart';
import 'registration_test.dart' show details;
import 'support/demo_auth_repository.dart';
import 'support/test_app.dart';

// MockUser exposes mutable fields for tests.
// ignore: must_be_immutable
class _ReloadFailsUser extends MockUser {
  _ReloadFailsUser(this.code)
    : super(uid: 'sam', email: 'sam@example.com', isEmailVerified: true);
  final String code;

  @override
  Future<void> reload() async => throw FirebaseAuthException(code: code);
}

Map<String, dynamic> _profileDoc() => {
  ...ReaderProfile(details()).toMap(),
  'email': 'sam@example.com',
  'acceptedTermsAt': Timestamp.now(),
};

void main() {
  group('restoring a saved session at launch', () {
    Future<FakeFirebaseFirestore> storeWithProfile() async {
      final store = FakeFirebaseFirestore();
      await store.collection('profiles').doc('sam').set(_profileDoc());
      return store;
    }

    test('stays signed in when the server is unreachable but the profile '
        'is cached', () async {
      final repo = FirebaseAuthRepository(
        auth: MockFirebaseAuth(
          signedIn: true,
          mockUser: _ReloadFailsUser('network-request-failed'),
        ),
        store: await storeWithProfile(),
      );
      final user = await repo.restoreSession();
      expect(user, isNotNull);
      expect(user!.isMember, isTrue);
      expect(user.profile!.firstName, 'Sam');
    });

    test(
      'reports a restore failure when offline with nothing cached',
      () async {
        final repo = FirebaseAuthRepository(
          auth: MockFirebaseAuth(
            signedIn: true,
            mockUser: _ReloadFailsUser('network-request-failed'),
          ),
          store: FakeFirebaseFirestore(),
        );
        await expectLater(
          repo.restoreSession(),
          throwsA(
            isA<SessionRestoreFailure>().having(
              (e) => e.message,
              'message',
              contains('Check your connection'),
            ),
          ),
        );
      },
    );

    test('a disabled account is not kept signed in from cache', () async {
      final repo = FirebaseAuthRepository(
        auth: MockFirebaseAuth(
          signedIn: true,
          mockUser: _ReloadFailsUser('user-disabled'),
        ),
        store: await storeWithProfile(),
      );
      await expectLater(
        repo.restoreSession(),
        throwsA(
          isA<SessionRestoreFailure>().having(
            (e) => e.message,
            'message',
            'This account has been disabled.',
          ),
        ),
      );
    });

    test('nobody signed in simply restores to signed out', () async {
      final repo = FirebaseAuthRepository(
        auth: MockFirebaseAuth(),
        store: FakeFirebaseFirestore(),
      );
      expect(await repo.restoreSession(), isNull);
    });
  });

  group('landing page', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    testWidgets('a saved member goes straight to the app', (tester) async {
      final repo = DemoAuthRepository();
      await tester.runAsync(
        () =>
            repo.signIn(DemoAuthRepository.email, DemoAuthRepository.password),
      );
      await tester.pumpWidget(testApp(repo));
      await tester.pumpAndSettle();
      expect(find.text('Your shelf is empty'), findsOneWidget);
      expect(find.byKey(const Key('getStarted')), findsNothing);
    });

    testWidgets('a failed restore explains itself and can be retried', (
      tester,
    ) async {
      final repo = DemoAuthRepository()
        ..restoreError = const SessionRestoreFailure(
          'Check your connection and try again.',
        );
      await tester.pumpWidget(testApp(repo));
      await tester.pumpAndSettle();
      expect(
        find.textContaining("We couldn't sign you back in automatically."),
        findsOneWidget,
      );
      expect(
        find.textContaining('Check your connection and try again.'),
        findsOneWidget,
      );

      // Back online: the saved session restores on retry.
      repo.restoreError = null;
      await tester.runAsync(
        () =>
            repo.signIn(DemoAuthRepository.email, DemoAuthRepository.password),
      );
      await tapVisible(tester, find.byKey(const Key('retrySession')));
      expect(find.text('Your shelf is empty'), findsOneWidget);
    });

    testWidgets('a signed-out visitor sees no restore warning', (tester) async {
      await tester.pumpWidget(testApp());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('getStarted')), findsOneWidget);
      expect(find.textContaining("couldn't sign you back in"), findsNothing);
    });
  });
}
