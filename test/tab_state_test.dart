import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'support/test_app.dart';

void main() {
  late Directory hiveDir;

  setUpAll(() async {
    hiveDir = await initTestHive();
  });

  tearDownAll(() => closeTestHive(hiveDir));

  Future<void> open(WidgetTester tester, {double width = 390}) async {
    tester.view.physicalSize = Size(width, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await signInWithFixtures(tester);
  }

  Future<void> tab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(width(tester) >= 720 ? NavigationRail : NavigationBar),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> go(WidgetTester tester, String path) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go(path);
    await tester.pumpAndSettle();
  }

  String searchText(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField).first).controller!.text;

  group('tabs keep their state while you look at another', () {
    testWidgets('a Discover search is still there when you come back', (
      tester,
    ) async {
      await open(tester);
      await tab(tester, 'Discover');
      await tester.enterText(find.byType(TextField).first, 'dune');
      await tester.pumpAndSettle();
      expect(searchText(tester), 'dune');

      await tab(tester, 'Wishlist');
      await tab(tester, 'Discover');
      expect(searchText(tester), 'dune');
      expect(find.byTooltip('Clear search'), findsOneWidget);
    });

    testWidgets('the My Shelf search survives too', (tester) async {
      await open(tester);
      await tester.enterText(find.byType(TextField).first, 'emma');
      await tester.pumpAndSettle();
      await tab(tester, 'Requests');
      await tab(tester, 'My Shelf');
      expect(searchText(tester), 'emma');
    });

    testWidgets('a sub-tab is remembered (Requests)', (tester) async {
      await open(tester);
      await tab(tester, 'Requests');
      await tester.tap(find.widgetWithText(Tab, 'Outgoing'));
      await tester.pumpAndSettle();
      await tab(tester, 'Discover');
      await tab(tester, 'Requests');
      final controller = DefaultTabController.of(
        tester.element(find.byType(TabBar).first),
      );
      expect(controller.index, 1);
    });

    testWidgets('More returns to the screen you left it on', (tester) async {
      await open(tester);
      await tab(tester, 'More');
      await go(tester, '/leaderboard');
      await tab(tester, 'Discover');
      await tab(tester, 'More');
      expect(find.byTooltip('Back'), findsOneWidget);
      expect(find.text('Appearance'), findsNothing);
    });

    testWidgets('tapping the tab you are on goes back to its first screen', (
      tester,
    ) async {
      await open(tester);
      await tab(tester, 'More');
      await go(tester, '/leaderboard');
      await tab(tester, 'More');
      expect(find.text('Appearance'), findsOneWidget);
    });

    testWidgets('the highlighted tab follows the screen on a phone', (
      tester,
    ) async {
      await open(tester);
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        0,
      );
      await go(tester, '/profile');
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        4,
        reason: 'Profile lives under More',
      );
      await tab(tester, 'Wishlist');
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        2,
      );
    });

    testWidgets('and on a wide screen with the side rail', (tester) async {
      await open(tester, width: 1000);
      await tab(tester, 'Discover');
      await tester.enterText(find.byType(TextField).first, 'dune');
      await tester.pumpAndSettle();
      await tab(tester, 'Wishlist');
      expect(
        tester
            .widget<NavigationRail>(find.byType(NavigationRail))
            .selectedIndex,
        2,
      );
      await tab(tester, 'Discover');
      expect(searchText(tester), 'dune');
    });
  });
}

double width(WidgetTester tester) => tester.view.physicalSize.width;
