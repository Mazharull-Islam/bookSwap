import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/authentication/data/repositories/firebase_auth_repository.dart';
import 'package:bookswap_login/features/authentication/domain/entities/registration.dart';
import 'support/test_app.dart';
import 'package:bookswap_login/features/authentication/data/models/reader_profile_dto.dart';

Map<String, dynamic> newProfile() => {
  'email': 'sam@example.com',
  'firstName': 'Sam',
  'lastName': 'Reader',
  'gender': 'Prefer not to say',
  'mobile': '+8801712345678',
  'address': 'Gazipur',
  'preferences': ['Fiction'],
  'favoriteBook': 'The Hobbit',
  'maxDistanceKm': null,
};

void main() {
  late Directory hiveDir;

  setUpAll(() async {
    hiveDir = await initTestHive();
  });

  tearDownAll(() => closeTestHive(hiveDir));

  group('no Terms & Conditions', () {
    testWidgets('the welcome page has no Terms link', (tester) async {
      await tester.pumpWidget(testApp());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('getStarted')), findsOneWidget);
      expect(find.textContaining('Terms'), findsNothing);
    });

    testWidgets('registration asks for no consent', (tester) async {
      tester.view.physicalSize = const Size(390, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(testApp());
      await tester.pumpAndSettle();
      await tapVisible(tester, find.byKey(const Key('getStarted')));
      await tapVisible(tester, find.text('Register new user'));
      expect(find.byKey(const Key('createAccount')), findsOneWidget);
      expect(find.byKey(const Key('termsConsent')), findsNothing);
      expect(find.byType(CheckboxListTile), findsNothing);
      expect(find.textContaining('Terms'), findsNothing);
    });

    testWidgets('the /terms address no longer exists', (tester) async {
      await tester.pumpWidget(testApp());
      await tester.pumpAndSettle();
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/terms');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('getStarted')), findsOneWidget);
      expect(find.textContaining('Terms'), findsNothing);
    });

    test('a registration needs no acceptance flag', () {
      final registration = Registration(
        firstName: 'Sam',
        lastName: 'Reader',
        email: 'sam@example.com',
        password: 'Reading123',
        gender: 'Prefer not to say',
        mobile: '+8801712345678',
        address: 'Gazipur',
        preferences: const ['Fiction'],
        favoriteBook: '',
      );
      expect(registration.validate(), isNull);
    });
  });

  group('profiles with and without the old fields', () {
    Future<FirebaseAuthRepository> repoWith(Map<String, dynamic> doc) async {
      final store = FakeFirebaseFirestore();
      await store.collection('profiles').doc('sam').set(doc);
      return FirebaseAuthRepository(
        auth: MockFirebaseAuth(
          signedIn: true,
          mockUser: MockUser(
            uid: 'sam',
            email: 'sam@example.com',
            isEmailVerified: true,
          ),
        ),
        store: store,
      );
    }

    test('a new profile (no terms fields) is a full member', () async {
      final user = await (await repoWith(newProfile())).restoreSession();
      expect(user!.isMember, isTrue);
      expect(user.profile!.firstName, 'Sam');
    });

    test('an old profile that still has them keeps working', () async {
      final user = await (await repoWith({
        ...newProfile(),
        'acceptedTermsVersion': '1.1',
        'acceptedTermsAt': Timestamp.now(),
      })).restoreSession();
      expect(user!.isMember, isTrue);
      expect(user.profile!.preferences, ['Fiction']);
    });

    test('and ignores them when saving a profile map', () {
      final profile = ReaderProfileDto.parse({
        ...newProfile(),
        'acceptedTermsVersion': '1.1',
        'acceptedTermsAt': 'whatever',
      });
      expect(profile.toMap().keys, isNot(contains('acceptedTermsAt')));
      expect(profile.toMap().keys, isNot(contains('acceptedTermsVersion')));
    });
  });
}
