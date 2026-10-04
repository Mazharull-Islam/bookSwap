import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/reading/domain/models/reading_entry.dart';
import 'package:bookswap_login/features/reading/presentation/providers/reading_providers.dart';
import 'support/tap_targets.dart';
import 'package:bookswap_login/features/forum/domain/models/forum_report.dart';
import 'package:bookswap_login/features/forum/presentation/providers/forum_providers.dart';
import 'support/test_app.dart';

// Text contrast is checked exactly, per colour pair, in theme_contrast_test.
// Flutter's pixel-sampling textContrastGuideline isn't used here: on outlined
// controls (segmented buttons, filter chips) it compares the border colour
// with the fill and reports false failures such as 1.39:1.

/// Screens reachable from the signed-in shell, with a Firestore-free fixture
/// behind each one.
const _routes = {
  'My Shelf': '/shelf',
  'Add a book': '/shelf/add',
  'Discover': '/discover',
  'Wishlist': '/wishlist',
  'Requests': '/requests',
  'More': '/more',
  'My Reading': '/reading',
  'Forum': '/forum',
  'Book of the Month': '/book-of-month',
  'Leaderboard': '/leaderboard',
  'Profile': '/profile',
  'Edit profile': '/profile/edit',
};

void main() {
  late Directory hiveDir;

  setUpAll(() async {
    hiveDir = await initTestHive();
    await loadTestFonts();
  });

  tearDownAll(() => closeTestHive(hiveDir));

  Future<void> openRoute(WidgetTester tester, String path) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go(path);
    await tester.pumpAndSettle();
  }

  void phone(WidgetTester tester, {double textScale = 1, double height = 844}) {
    tester.view.physicalSize = Size(390, height);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
  }

  for (final entry in _routes.entries) {
    testWidgets('${entry.key}: tap targets and labels', (tester) async {
      final handle = tester.ensureSemantics();
      // Tall viewport: a control clipped by the screen edge reports a clipped
      // size, which isn't a real tap-target problem.
      phone(tester, height: 2000);
      await signInWithFixtures(tester);
      await openRoute(tester, entry.value);
      expect(smallTapTargets(tester), isEmpty);
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      expect(tester.takeException(), isNull);
      handle.dispose();
    });

    testWidgets('${entry.key}: no overflow at 2x text size', (tester) async {
      phone(tester, textScale: 2);
      await signInWithFixtures(tester);
      await openRoute(tester, entry.value);
      expect(tester.takeException(), isNull);
    });
  }

  Future<void> checkGuidelines(WidgetTester tester) async {
    expect(smallTapTargets(tester), isEmpty);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    expect(tester.takeException(), isNull);
  }

  group('sheets and dialogs', () {
    testWidgets('shelf filter sheet', (tester) async {
      final handle = tester.ensureSemantics();
      // Tall viewport: a clipped chip would report a clipped size.
      phone(tester, height: 2000);
      await signInWithFixtures(tester);
      await tapVisible(tester, find.byTooltip('Filters'));
      expect(find.text('Clear all'), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('discover filter sheet', (tester) async {
      final handle = tester.ensureSemantics();
      // Tall viewport: a clipped chip would report a clipped size.
      phone(tester, height: 2000);
      await signInWithFixtures(tester);
      await openRoute(tester, '/discover');
      await tapVisible(tester, find.byTooltip('Filters'));
      expect(find.text('Clear all'), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('book detail dialog', (tester) async {
      final handle = tester.ensureSemantics();
      phone(tester);
      await signInWithFixtures(tester);
      await tapVisible(tester, find.text('The Left Hand of Darkness'));
      expect(find.byTooltip('Close'), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('discover listing dialog', (tester) async {
      final handle = tester.ensureSemantics();
      phone(tester);
      await signInWithFixtures(tester);
      await openRoute(tester, '/discover');
      await tapVisible(tester, find.text('2 members'));
      expect(find.byTooltip('Close'), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('return dialog records a condition', (tester) async {
      final handle = tester.ensureSemantics();
      phone(tester, height: 2000);
      await signInWithFixtures(tester);
      await openRoute(tester, '/requests');
      await tapVisible(tester, find.text('Mark as returned'));
      expect(find.text('When you lent it: Good'), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('borrower note dialog', (tester) async {
      final handle = tester.ensureSemantics();
      phone(tester, height: 2000);
      await signInWithFixtures(tester);
      await openRoute(tester, '/requests');
      await tapVisible(tester, find.text('History'));
      await tapVisible(tester, find.byKey(const Key('add-note-out-3')));
      expect(find.byKey(const Key('borrowerNoteField')), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('review dialog', (tester) async {
      final handle = tester.ensureSemantics();
      phone(tester, height: 2000);
      await signInWithFixtures(tester);
      await openRoute(tester, '/requests');
      await tapVisible(tester, find.text('History'));
      await tapVisible(tester, find.byKey(const Key('rate-out-3')));
      expect(find.byTooltip('3 stars'), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('report dialog', (tester) async {
      final handle = tester.ensureSemantics();
      phone(tester, height: 2000);
      await signInWithFixtures(tester);
      await openRoute(tester, '/forum');
      await tapVisible(tester, find.text(fixturePost.title));
      await tapVisible(tester, find.byTooltip('Report'));
      expect(find.text('Report this post'), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('moderation queue', (tester) async {
      final handle = tester.ensureSemantics();
      phone(tester, height: 2000);
      await signInWithFixtures(
        tester,
        overrides: [
          isModeratorProvider.overrideWith((ref) => Stream.value(true)),
          reportedTargetsProvider.overrideWith(
            (ref) => Stream.value([
              ReportedTarget([
                ForumReport(
                  id: 'r1',
                  postId: fixturePost.id,
                  reporterId: 'a',
                  reason: 'spam',
                  createdAtMs: 0,
                ),
              ]),
            ]),
          ),
          reportedContentProvider.overrideWith(
            (ref, t) async => (post: fixturePost, reply: null),
          ),
        ],
      );
      await openRoute(tester, '/moderation');
      expect(find.text('Dismiss reports'), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });

    testWidgets('reading entry dialog with interactive stars', (tester) async {
      final handle = tester.ensureSemantics();
      phone(tester);
      await signInWithFixtures(
        tester,
        overrides: [
          myReadingProvider.overrideWith(
            (ref) => Stream.value([
              const ReadingEntry(
                id: 'r1',
                userId: 'demo-reader',
                title: 'Dune',
                author: 'Frank Herbert',
                genre: 'Science fiction',
                status: ReadingStatus.read,
                rating: 4,
                updatedAtMs: 1,
              ),
            ]),
          ),
        ],
      );
      await openRoute(tester, '/reading');
      await tapVisible(tester, find.text('Read').first);
      await tapVisible(tester, find.text('Dune'));
      expect(find.byTooltip('3 stars'), findsOneWidget);
      await checkGuidelines(tester);
      handle.dispose();
    });
  });
}
