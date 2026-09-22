import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/app/app.dart';
import 'package:bookswap_login/features/authentication/domain/models/auth_user.dart';
import 'package:bookswap_login/features/authentication/presentation/providers/auth_providers.dart';
import 'support/demo_auth_repository.dart';

Widget testApp([DemoAuthRepository? repository]) => ProviderScope(
  overrides: [
    authRepositoryProvider.overrideWithValue(
      repository ?? DemoAuthRepository(),
    ),
  ],
  child: const BookSwapApp(),
);

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

class PendingGoogleRepository extends DemoAuthRepository {
  final result = Completer<AuthUser?>();
  @override
  Future<AuthUser?> signInWithGoogle() => result.future;
}

void main() {
  testWidgets(
    'Returning to login with a restored Google session resumes registration',
    (tester) async {
      final repository = DemoAuthRepository()
        ..currentUser = const AuthUser(
          id: 'pending-google',
          email: 'sam@gmail.com',
          name: 'Sam Reader',
          usesGoogle: true,
          emailVerified: true,
        );
      await tester.pumpWidget(testApp(repository));
      await tester.pumpAndSettle();
      Navigator.of(
        tester.element(find.text('Join the neighbourhood.')),
      ).pushNamed('/login');
      await tester.pumpAndSettle();
      expect(find.text('Join the neighbourhood.'), findsOneWidget);
      expect(find.text('Welcome back.'), findsNothing);
      expect(find.byKey(const Key('password')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Google waiting state explains the popup and cancellation unlocks login',
    (tester) async {
      final repository = PendingGoogleRepository();
      await tester.pumpWidget(testApp(repository));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.byKey(const Key('getStarted')));
      final googleButton = find.byKey(const Key('googleSignIn'));
      await tester.ensureVisible(googleButton);
      await tester.tap(googleButton);
      await tester.pump();
      expect(
        find.textContaining('Complete sign-in in the Google popup.'),
        findsOneWidget,
      );
      expect(
        tester.widget<FilledButton>(find.byKey(const Key('signIn'))).onPressed,
        isNull,
      );
      repository.result.complete(null);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Complete sign-in in the Google popup.'),
        findsNothing,
      );
      expect(
        tester.widget<FilledButton>(find.byKey(const Key('signIn'))).onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Welcome leads to login, authentication and sign-out', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    expect(find.text('Good books.\nGreat neighbours.'), findsOneWidget);
    expect(find.byKey(const Key('email')), findsNothing);
    await tapVisible(tester, find.byKey(const Key('getStarted')));
    await tapVisible(tester, find.byKey(const Key('signIn')));
    expect(find.text('Enter your email address.'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('email')),
      'reader@bookswap.app',
    );
    await tester.enterText(find.byKey(const Key('password')), 'wrong');
    await tapVisible(tester, find.byKey(const Key('signIn')));
    expect(
      find.text('Email or password is incorrect. Try again.'),
      findsOneWidget,
    );
    await tester.enterText(find.byKey(const Key('password')), 'BookSwap123!');
    await tapVisible(tester, find.byKey(const Key('signIn')));
    expect(find.text('Welcome, Reader.'), findsOneWidget);
    await tapVisible(tester, find.text('Sign out'));
    expect(find.text('Welcome back.'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('password')))
          .controller!
          .text,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Mobile registration preserves form across terms and requires consent',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = DemoAuthRepository();
      await tester.pumpWidget(testApp(repository));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.byKey(const Key('getStarted')));
      await tapVisible(tester, find.text('Register new user'));
      Future<void> enter(String key, String value) async {
        final finder = find.byKey(Key(key));
        await tester.ensureVisible(finder);
        await tester.enterText(finder, value);
        await tester.pumpAndSettle();
      }

      await enter('firstName', 'Sam');
      await enter('lastName', 'Reader');
      await enter('mobile', '+8801712345678');
      await enter('address', 'Gazipur');
      await tapVisible(tester, find.widgetWithText(FilterChip, 'Fiction'));
      await enter('favoriteBook', 'The Hobbit');
      await enter('email', 'sam@example.com');
      await enter('password', 'Reading123');
      await enter('confirmPassword', 'Different123');
      await tapVisible(tester, find.byKey(const Key('createAccount')));
      expect(find.text('Passwords do not match.'), findsOneWidget);
      expect(
        find.text('Accept the Terms & Conditions to continue.'),
        findsOneWidget,
      );
      await enter('confirmPassword', 'Reading123');
      await tapVisible(tester, find.text('Read Terms & Conditions →'));
      expect(find.text('Terms & Conditions'), findsOneWidget);
      await tapVisible(tester, find.text('Back to BookSwap'));
      expect(
        tester
            .widget<TextFormField>(find.byKey(const Key('firstName')))
            .controller!
            .text,
        'Sam',
      );
      expect(
        tester
            .widget<CheckboxListTile>(find.byKey(const Key('termsConsent')))
            .value,
        isFalse,
      );
      await tapVisible(tester, find.byKey(const Key('termsConsent')));
      await tapVisible(tester, find.byKey(const Key('createAccount')));
      expect(find.text('Verify your email'), findsOneWidget);
      expect(find.text('Welcome, Sam.'), findsNothing);
      await tapVisible(tester, find.text('I have verified my email'));
      expect(
        find.textContaining('Your email is not verified yet.'),
        findsOneWidget,
      );
      repository.verifyEmail('sam@example.com');
      await tapVisible(tester, find.text('I have verified my email'));
      expect(find.text('Welcome, Sam.'), findsOneWidget);
      await tapVisible(tester, find.text('Sign out'));
      await enter('email', 'sam@example.com');
      await enter('password', 'Reading123');
      await tapVisible(tester, find.byKey(const Key('signIn')));
      expect(find.text('Welcome, Sam.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Google sign-up requires the form and uses the verified Google email',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = DemoAuthRepository()
        ..nextGoogleUser = const AuthUser(
          id: 'google-sam',
          email: 'sam@gmail.com',
          name: 'Sam Reader',
          emailVerified: true,
          usesGoogle: true,
        );
      await tester.pumpWidget(testApp(repository));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.byKey(const Key('getStarted')));
      await tapVisible(tester, find.byKey(const Key('googleSignIn')));
      expect(find.text('Join the neighbourhood.'), findsOneWidget);
      expect(find.text('Welcome, Sam.'), findsNothing);
      expect(find.byKey(const Key('password')), findsNothing);
      final email = tester.widget<TextFormField>(
        find.byKey(const Key('email')),
      );
      expect(email.controller!.text, 'sam@gmail.com');
      expect(email.enabled, isFalse);
      await tapVisible(tester, find.byKey(const Key('createAccount')));
      expect(find.text('Enter your mobile number.'), findsOneWidget);
      for (final entry in {
        'mobile': '+8801712345678',
        'address': 'Gazipur',
      }.entries) {
        await tester.ensureVisible(find.byKey(Key(entry.key)));
        await tester.enterText(find.byKey(Key(entry.key)), entry.value);
      }
      await tapVisible(tester, find.widgetWithText(FilterChip, 'Fiction'));
      await tapVisible(tester, find.byKey(const Key('termsConsent')));
      await tapVisible(tester, find.byKey(const Key('createAccount')));
      expect(find.text('Welcome, Sam.'), findsOneWidget);
      expect(find.text('Verify your email'), findsNothing);
      expect(repository.verificationEmails, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Welcome and login fit a small mobile screen', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    await tapVisible(tester, find.byKey(const Key('getStarted')));
    await tester.ensureVisible(find.byKey(const Key('signIn')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
