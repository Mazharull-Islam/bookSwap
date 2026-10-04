import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/authentication/domain/entities/auth_user.dart';
import 'support/demo_auth_repository.dart';
import 'support/test_app.dart';

Future<void> goToProfile(WidgetTester tester) async {
  await tapVisible(tester, find.text('More'));
  await tapVisible(tester, find.text('Profile'));
}

Future<void> signInDemo(WidgetTester tester) async {
  await tester.pumpWidget(testApp());
  await tester.pumpAndSettle();
  await tapVisible(tester, find.byKey(const Key('getStarted')));
  await tester.enterText(find.byKey(const Key('email')), 'reader@bookswap.app');
  await tester.enterText(find.byKey(const Key('password')), 'BookSwap123!');
  await tapVisible(tester, find.byKey(const Key('signIn')));
}

class PendingGoogleRepository extends DemoAuthRepository {
  final result = Completer<AuthUser?>();
  @override
  Future<AuthUser?> signInWithGoogle() => result.future;
}

void main() {
  late Directory hiveDir;

  setUpAll(() async {
    hiveDir = await initTestHive();
  });

  tearDownAll(() => closeTestHive(hiveDir));

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
      GoRouter.of(
        tester.element(find.text('Join the neighbourhood.')),
      ).go('/login');
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
    expect(find.text('Your shelf is empty'), findsOneWidget);
    await goToProfile(tester);
    expect(find.text('Reader Demo'), findsOneWidget);
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
    'Mobile registration keeps the form after a validation error and completes',
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
        tester
            .widget<TextFormField>(find.byKey(const Key('firstName')))
            .controller!
            .text,
        'Sam',
      );
      await enter('confirmPassword', 'Reading123');
      await tapVisible(tester, find.byKey(const Key('createAccount')));
      expect(find.text('Verify your email'), findsOneWidget);
      expect(find.text('Sam Reader'), findsNothing);
      await tapVisible(tester, find.text('I have verified my email'));
      expect(
        find.textContaining('Your email is not verified yet.'),
        findsOneWidget,
      );
      repository.verifyEmail('sam@example.com');
      await tapVisible(tester, find.text('I have verified my email'));
      expect(find.text('Your shelf is empty'), findsOneWidget);
      await goToProfile(tester);
      expect(find.text('Sam Reader'), findsOneWidget);
      await tapVisible(tester, find.text('Sign out'));
      await enter('email', 'sam@example.com');
      await enter('password', 'Reading123');
      await tapVisible(tester, find.byKey(const Key('signIn')));
      expect(find.text('Your shelf is empty'), findsOneWidget);
      await goToProfile(tester);
      expect(find.text('Sam Reader'), findsOneWidget);
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
      expect(find.text('Sam Reader'), findsNothing);
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
      await tapVisible(tester, find.byKey(const Key('createAccount')));
      expect(find.text('Your shelf is empty'), findsOneWidget);
      await goToProfile(tester);
      expect(find.text('Sam Reader'), findsOneWidget);
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

  testWidgets('Phones get a bottom bar; More keeps its tab for sub-screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await signInDemo(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );

    await tapVisible(tester, find.text('Discover'));
    expect(find.text('Search for a book'), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );

    await tapVisible(tester, find.text('More'));
    await tapVisible(tester, find.text('My Reading'));
    expect(find.text('To read'), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      4,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Wide screens get a side rail instead of a bottom bar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await signInDemo(tester);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await tapVisible(tester, find.text('Discover'));
    expect(find.text('Search for a book'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Appearance choice on More switches the app to dark mode', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await signInDemo(tester);
    Brightness current() =>
        Theme.of(tester.element(find.byType(Scaffold).first)).brightness;
    expect(current(), Brightness.light);
    await tapVisible(tester, find.text('More'));
    await tapVisible(tester, find.text('Dark'));
    expect(current(), Brightness.dark);
    await tapVisible(tester, find.text('Light'));
    expect(current(), Brightness.light);
    expect(tester.takeException(), isNull);
  });
}
