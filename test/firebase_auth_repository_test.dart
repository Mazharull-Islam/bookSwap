import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/features/auth/data/firebase_auth_repository.dart';
import 'package:bookswap_login/features/auth/domain/auth_repository.dart';
import 'registration_test.dart' show details;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap_login/features/auth/application/auth_controller.dart';

// MockUser intentionally exposes mutable display-name fields for Firebase tests.
// ignore: must_be_immutable
class EmailFailureUser extends MockUser {
  EmailFailureUser()
    : super(uid: 'pending', email: 'sam@example.com', isEmailVerified: false);
  @override
  Future<void> sendEmailVerification([
    ActionCodeSettings? actionCodeSettings,
  ]) async {
    throw FirebaseAuthException(code: 'too-many-requests');
  }
}

class DelayedLoginAuth extends MockFirebaseAuth {
  final response = Completer<UserCredential>();
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) => response.future;
}

class DelayedSessionAuth extends MockFirebaseAuth {
  @override
  Stream<User?> authStateChanges() => Stream<User?>.multi((_) {});
}

class DeniedFirestore extends FakeFirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    throw FirebaseException(
      plugin: 'cloud_firestore',
      code: 'permission-denied',
    );
  }
}

void main() {
  test(
    'Stalled session restoration reports a timeout instead of loading forever',
    () async {
      final repo = FirebaseAuthRepository(
        auth: DelayedSessionAuth(),
        store: FakeFirebaseFirestore(),
        requestTimeout: const Duration(milliseconds: 10),
      );
      await expectLater(
        repo.restoreSession(),
        throwsA(
          isA<AuthFailure>().having(
            (e) => e.message,
            'message',
            contains('took too long'),
          ),
        ),
      );
    },
  );

  test(
    'Stalled login unlocks controller and late success cannot activate membership',
    () async {
      final auth = DelayedLoginAuth();
      final store = FakeFirebaseFirestore();
      final repo = FirebaseAuthRepository(
        auth: auth,
        store: store,
        requestTimeout: const Duration(milliseconds: 10),
      );
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      await container
          .read(authControllerProvider.notifier)
          .signIn('sam@example.com', 'Reading123');
      expect(container.read(authControllerProvider).isLoading, isFalse);
      expect(container.read(authControllerProvider).hasError, isTrue);
      final otherAuth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'sam', email: 'sam@example.com'),
      );
      auth.response.complete(
        await otherAuth.signInWithEmailAndPassword(
          email: 'sam@example.com',
          password: 'Reading123',
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(container.read(authControllerProvider).valueOrNull, isNull);
      expect(container.read(authControllerProvider).hasError, isTrue);
      expect((await store.collection('profiles').get()).docs, isEmpty);
    },
  );

  test('Denied profile access explains the database setup problem', () async {
    final store = DeniedFirestore();
    final repo = FirebaseAuthRepository(
      auth: MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'sam', email: 'sam@example.com'),
      ),
      store: store,
    );
    await expectLater(
      repo.refreshSession(),
      throwsA(
        isA<AuthFailure>().having(
          (e) => e.message,
          'message',
          contains('database setup'),
        ),
      ),
    );
  });

  test(
    'Password registration persists profile without password and stays pending',
    () async {
      final store = FakeFirebaseFirestore();
      final auth = MockFirebaseAuth(verifyEmailAutomatically: false);
      final repo = FirebaseAuthRepository(auth: auth, store: store);
      expect(await repo.restoreSession(), isNull);
      final user = await repo.register(details());
      expect(user.isMember, isFalse);
      expect(user.emailVerified, isFalse);
      expect(user.profile!.firstName, 'Sam');
      final saved = (await store.collection('profiles').doc(user.id).get())
          .data()!;
      expect(saved.containsKey('password'), isFalse);
      expect(saved['acceptedTermsAt'], isA<Timestamp>());
      expect((await repo.refreshSession()).isMember, isFalse);
      await repo.signOut();
      expect(auth.currentUser, isNull);
    },
  );

  test('A verified identity alone does not grant membership', () async {
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'google', email: 'sam@example.com'),
    );
    final repo = FirebaseAuthRepository(
      auth: auth,
      store: FakeFirebaseFirestore(),
    );
    final user = (await repo.restoreSession())!;
    expect(user.emailVerified, isTrue);
    expect(user.profile, isNull);
    expect(user.isMember, isFalse);
    expect((await repo.register(details())).isMember, isTrue);
  });

  test(
    'Verification delivery failure preserves registration for resend',
    () async {
      final auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: EmailFailureUser(),
      );
      final repo = FirebaseAuthRepository(
        auth: auth,
        store: FakeFirebaseFirestore(),
      );
      final user = await repo.register(details());
      expect(user.isMember, isFalse);
      expect(user.profile, isNotNull);
      expect(user.notice, contains('could not be sent'));
      await expectLater(repo.resendVerification(), throwsA(isA<AuthFailure>()));
    },
  );

  test(
    'Partial-registration retries cannot overwrite an existing profile',
    () async {
      final auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'sam', email: 'sam@example.com'),
      );
      final repo = FirebaseAuthRepository(
        auth: auth,
        store: FakeFirebaseFirestore(),
      );
      await repo.register(details());
      final again = await repo.register(details(preferences: ['History']));
      expect(again.profile!.preferences, ['Fiction']);
      await expectLater(
        repo.register(details(email: 'someone@example.com')),
        throwsA(isA<AuthFailure>()),
      );
    },
  );

  test('Refreshing verification unlocks the same registered account', () async {
    final auth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(
        uid: 'sam',
        email: 'sam@example.com',
        isEmailVerified: false,
      ),
    );
    final store = FakeFirebaseFirestore();
    final repo = FirebaseAuthRepository(auth: auth, store: store);
    expect((await repo.register(details())).isMember, isFalse);
    auth.mockUser = MockUser(
      uid: 'sam',
      email: 'sam@example.com',
      isEmailVerified: true,
    );
    await auth.signInWithEmailAndPassword(
      email: 'sam@example.com',
      password: 'Reading123',
    );
    final verified = await repo.refreshSession();
    expect(verified.id, 'sam');
    expect(verified.isMember, isTrue);
  });
}
