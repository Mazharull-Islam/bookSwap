import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/main.dart';

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Welcome leads to login, authentication and sign-out', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: BookSwapApp()));
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
      await tester.pumpWidget(const ProviderScope(child: BookSwapApp()));
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
      expect(find.text('Welcome, Sam.'), findsOneWidget);
      await tapVisible(tester, find.text('Sign out'));
      await enter('email', 'sam@example.com');
      await enter('password', 'Reading123');
      await tapVisible(tester, find.byKey(const Key('signIn')));
      expect(find.text('Welcome, Sam.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Welcome and login fit a small mobile screen', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: BookSwapApp()));
    await tapVisible(tester, find.byKey(const Key('getStarted')));
    await tester.ensureVisible(find.byKey(const Key('signIn')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
