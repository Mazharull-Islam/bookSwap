import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Override, ProviderContainer;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/books/presentation/providers/book_providers.dart';
import 'package:bookswap_login/features/books/presentation/widgets/book_grid_tile.dart';
import 'package:bookswap_login/features/books/presentation/widgets/book_list_tile.dart';
import 'package:bookswap_login/features/discovery/presentation/providers/discovery_providers.dart';
import 'package:bookswap_login/features/discovery/presentation/widgets/book_group_grid_tile.dart';
import 'package:bookswap_login/features/discovery/presentation/widgets/book_group_tile.dart';
import 'package:bookswap_login/features/forum/presentation/providers/forum_providers.dart';
import 'package:bookswap_login/features/reading/domain/entities/reading_entry.dart';
import 'package:bookswap_login/features/reading/presentation/providers/reading_providers.dart';
import 'package:bookswap_login/features/reading/presentation/widgets/reading_entry_grid_tile.dart';
import 'package:bookswap_login/features/reading/presentation/widgets/reading_entry_tile.dart';
import 'package:bookswap_login/features/wanted_books/presentation/providers/wanted_book_providers.dart';
import 'package:bookswap_login/features/wanted_books/presentation/widgets/wanted_book_grid_tile.dart';
import 'package:bookswap_login/features/wanted_books/presentation/widgets/wanted_book_tile.dart';
import 'package:bookswap_login/shared/widgets/star_rating.dart';
import 'package:bookswap_login/shared/widgets/view_mode.dart';
import 'support/test_app.dart';

const entries = [
  ReadingEntry(
    id: 'r1',
    userId: 'demo-reader',
    title: 'Dune',
    author: 'Frank Herbert',
    genre: 'Science fiction',
    status: ReadingStatus.read,
    rating: 4,
    updatedAtMs: 1,
  ),
  ReadingEntry(
    id: 'r2',
    userId: 'demo-reader',
    title: 'Emma',
    author: 'Jane Austen',
    status: ReadingStatus.read,
    updatedAtMs: 2,
  ),
];

void main() {
  late Directory hiveDir;

  setUpAll(() async {
    hiveDir = await initTestHive();
  });

  tearDownAll(() => closeTestHive(hiveDir));

  Future<void> open(
    WidgetTester tester, {
    String route = '/shelf',
    List<Override> more = const [],
  }) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await signInWithFixtures(
      tester,
      overrides: [
        myReadingProvider.overrideWith((ref) => Stream.value(entries)),
        ...more,
      ],
    );
    if (route != '/shelf') {
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go(route);
      await tester.pumpAndSettle();
    }
  }

  Future<void> go(WidgetTester tester, String path) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go(path);
    await tester.pumpAndSettle();
  }

  group('books are shown as a grid by default', () {
    test('every view-mode setting starts as a grid', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(shelfViewModeProvider), ViewMode.grid);
      expect(container.read(discoveryViewModeProvider), ViewMode.grid);
      expect(container.read(wishlistViewModeProvider), ViewMode.grid);
      expect(container.read(readingViewModeProvider), ViewMode.grid);
    });

    testWidgets('My Shelf', (tester) async {
      await open(tester);
      expect(find.byType(BookGridTile), findsWidgets);
      expect(find.byType(BookListTile), findsNothing);
      expect(find.byTooltip('Switch to list view'), findsOneWidget);
    });

    testWidgets('Discover', (tester) async {
      await open(tester, route: '/discover');
      expect(find.byType(BookGroupGridTile), findsWidgets);
      expect(find.byType(BookGroupTile), findsNothing);
    });

    testWidgets('Wishlist', (tester) async {
      await open(tester, route: '/wishlist');
      expect(find.byType(WantedBookGridTile), findsOneWidget);
      expect(find.byType(WantedBookTile), findsNothing);
    });

    testWidgets('My Reading', (tester) async {
      await open(tester, route: '/reading');
      await tester.tap(find.widgetWithText(Tab, 'Read'));
      await tester.pumpAndSettle();
      expect(find.byType(ReadingEntryGridTile), findsNWidgets(2));
      expect(find.byType(ReadingEntryTile), findsNothing);
    });
  });

  group('switching between grid and list', () {
    testWidgets('My Shelf toggles both ways', (tester) async {
      await open(tester);
      await tester.tap(find.byTooltip('Switch to list view'));
      await tester.pumpAndSettle();
      expect(find.byType(BookListTile), findsWidgets);
      expect(find.byType(BookGridTile), findsNothing);
      await tester.tap(find.byTooltip('Switch to grid view'));
      await tester.pumpAndSettle();
      expect(find.byType(BookGridTile), findsWidgets);
    });

    testWidgets('Wishlist shows the same book either way, removable in both', (
      tester,
    ) async {
      await open(tester, route: '/wishlist');
      expect(find.text('Project Hail Mary'), findsOneWidget);
      expect(find.byTooltip('Remove Project Hail Mary'), findsOneWidget);

      await tester.tap(find.byTooltip('Switch to list view'));
      await tester.pumpAndSettle();
      expect(find.byType(WantedBookTile), findsOneWidget);
      expect(find.text('Project Hail Mary'), findsOneWidget);
      expect(find.byTooltip('Remove'), findsOneWidget);
    });

    testWidgets('My Reading list view, and opening an entry from either', (
      tester,
    ) async {
      await open(tester, route: '/reading');
      await tester.tap(find.widgetWithText(Tab, 'Read'));
      await tester.pumpAndSettle();

      // Grid: tapping a cover opens the entry.
      await tester.tap(find.text('Dune'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Switch to list view'));
      await tester.pumpAndSettle();
      expect(find.byType(ReadingEntryTile), findsNWidgets(2));
      await tester.tap(find.text('Dune'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('a grid tile shows the stars of a rated book only', (
      tester,
    ) async {
      await open(tester, route: '/reading');
      await tester.tap(find.widgetWithText(Tab, 'Read'));
      await tester.pumpAndSettle();
      Finder tile(String title) => find.ancestor(
        of: find.text(title),
        matching: find.byType(ReadingEntryGridTile),
      );
      expect(
        find.descendant(of: tile('Dune'), matching: find.byType(StarRating)),
        findsOneWidget,
        reason: 'Dune is rated 4',
      );
      expect(
        find.descendant(of: tile('Emma'), matching: find.byType(StarRating)),
        findsNothing,
        reason: 'Emma has no rating',
      );
    });

    testWidgets('each screen remembers its own choice', (tester) async {
      await open(tester);
      await tester.tap(find.byTooltip('Switch to list view'));
      await tester.pumpAndSettle();

      await go(tester, '/discover');
      expect(
        find.byType(BookGroupGridTile),
        findsWidgets,
        reason: 'Discover is separate',
      );
      await go(tester, '/wishlist');
      expect(
        find.byType(WantedBookGridTile),
        findsOneWidget,
        reason: 'Wishlist is separate',
      );
      await go(tester, '/shelf');
      expect(
        find.byType(BookListTile),
        findsWidgets,
        reason: 'Shelf kept its list view',
      );
    });
  });

  group('the Back button on every More screen', () {
    Future<void> expectBackToMore(WidgetTester tester, String route) async {
      await go(tester, route);
      expect(find.byTooltip('Back'), findsOneWidget, reason: route);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Appearance'), findsOneWidget, reason: '$route -> More');
    }

    for (final route in [
      '/reading',
      '/forum',
      '/book-of-month',
      '/leaderboard',
      '/profile',
    ]) {
      testWidgets(route, (tester) async {
        await open(tester);
        await expectBackToMore(tester, route);
      });
    }

    testWidgets('/moderation (for moderators)', (tester) async {
      await open(
        tester,
        more: [isModeratorProvider.overrideWith((ref) => Stream.value(true))],
      );
      await expectBackToMore(tester, '/moderation');
    });

    testWidgets('the main tabs do not get one', (tester) async {
      await open(tester);
      for (final route in ['/shelf', '/discover', '/wishlist', '/requests']) {
        await go(tester, route);
        expect(find.byTooltip('Back'), findsNothing, reason: route);
      }
    });
  });
}
