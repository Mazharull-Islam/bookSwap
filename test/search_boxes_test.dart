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

  Future<void> go(WidgetTester tester, String path) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go(path);
    await tester.pumpAndSettle();
  }

  String fieldText(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField).first).controller!.text;

  group('My Shelf search', () {
    Future<void> open(WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await signInWithFixtures(tester);
    }

    testWidgets('filters as you type and can be cleared', (tester) async {
      await open(tester);
      expect(find.text('Pride and Prejudice'), findsOneWidget);
      expect(find.text('The Left Hand of Darkness'), findsOneWidget);
      expect(find.byTooltip('Clear search'), findsNothing);

      await tester.enterText(find.byType(TextField).first, 'pride');
      await tester.pumpAndSettle();
      expect(find.text('Pride and Prejudice'), findsOneWidget);
      expect(find.text('The Left Hand of Darkness'), findsNothing);
      expect(find.byTooltip('Clear search'), findsOneWidget);

      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      expect(fieldText(tester), isEmpty);
      expect(find.text('The Left Hand of Darkness'), findsOneWidget);
      expect(find.byTooltip('Clear search'), findsNothing);
    });

    testWidgets('matches authors too, and says when nothing matches', (
      tester,
    ) async {
      await open(tester);
      await tester.enterText(find.byType(TextField).first, 'austen');
      await tester.pumpAndSettle();
      expect(find.text('Pride and Prejudice'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'zzzz');
      await tester.pumpAndSettle();
      expect(find.text('Pride and Prejudice'), findsNothing);
      expect(find.text('The Left Hand of Darkness'), findsNothing);
    });
  });

  group('Discover search', () {
    Future<void> open(WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await signInWithFixtures(tester);
      await go(tester, '/discover');
    }

    testWidgets('the clear button follows the text', (tester) async {
      await open(tester);
      expect(find.byTooltip('Clear search'), findsNothing);
      await tester.enterText(find.byType(TextField).first, 'dune');
      await tester.pumpAndSettle();
      expect(find.byTooltip('Clear search'), findsOneWidget);
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      expect(fieldText(tester), isEmpty);
      expect(find.byTooltip('Clear search'), findsNothing);
    });

    testWidgets('a search survives leaving and coming back', (tester) async {
      await open(tester);
      await tester.enterText(find.byType(TextField).first, 'dune');
      await tester.pumpAndSettle();
      await go(tester, '/shelf');
      await go(tester, '/discover');
      // The results are still narrowed, so the box must say why.
      expect(fieldText(tester), 'dune');
      expect(find.byTooltip('Clear search'), findsOneWidget);
    });

    testWidgets('the empty message depends on whether a search is active', (
      tester,
    ) async {
      await open(tester);
      await tester.enterText(find.byType(TextField).first, 'zzzz');
      await tester.pumpAndSettle();
      expect(
        find.text('No listings match your search and filters.'),
        findsOneWidget,
      );
    });
  });
}
