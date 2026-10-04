import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/core/services/google_books_service.dart' as gb;
import 'package:bookswap_login/core/services/open_library_service.dart' as ol;
import 'package:bookswap_login/features/books/presentation/screens/scan_isbn_page.dart';
import 'support/fake_google_books.dart';
import 'support/test_app.dart';

class _FakeOpenLibrary extends ol.OpenLibraryService {
  _FakeOpenLibrary(this.found) : super(Dio());
  final ol.BookMetadata found;

  @override
  Future<ol.BookMetadata?> lookupByIsbn(String isbn) async => found;
  @override
  Future<String?> fetchSynopsis(ol.BookMetadata suggestion) async => null;
  @override
  Future<List<ol.BookMetadata>> searchByTitle(
    String query, {
    int limit = 8,
  }) async => const [];
}

const _noisyDune = ol.BookMetadata(
  title: 'Dune',
  author: 'Frank Herbert',
  isbn: '9780441172719',
  genres: ['Accessible book', 'Protected DAISY', 'Fiction', 'Science fiction'],
);

const _googleDune = gb.BookMetadata(
  title: 'Dune',
  author: 'Frank Herbert',
  genres: ['Fiction / Science Fiction / General'],
  synopsis:
      '<p>Set on the desert planet Arrakis, Dune is the story of Paul '
      'Atreides, heir to a noble family tasked with ruling a harsh world.</p>',
);

void main() {
  late Directory hiveDir;

  setUpAll(() async {
    hiveDir = await initTestHive();
  });

  tearDownAll(() => closeTestHive(hiveDir));

  Future<void> signIn(
    WidgetTester tester, {
    FakeGoogleBooks? google,
    Future<String?> Function(BuildContext)? scan,
  }) async {
    tester.view.physicalSize = const Size(390, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await signInWithFixtures(
      tester,
      overrides: [
        ol.openLibraryServiceProvider.overrideWithValue(
          _FakeOpenLibrary(_noisyDune),
        ),
        gb.googleBooksServiceProvider.overrideWithValue(
          google ?? FakeGoogleBooks(match: _googleDune),
        ),
        if (scan != null) isbnScannerProvider.overrideWithValue(scan),
      ],
    );
  }

  testWidgets('adding a book shows standard genres and the Google synopsis', (
    tester,
  ) async {
    await signIn(tester, scan: (_) async => '9780441172719');
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/shelf/add');
    await tester.pumpAndSettle();
    await tapVisible(tester, find.byKey(const Key('scanIsbn')));

    expect(find.text('Science fiction'), findsWidgets);
    expect(find.text('Accessible book'), findsNothing);
    expect(find.text('Protected DAISY'), findsNothing);
    expect(find.text('Fiction'), findsNothing);
    expect(
      find.textContaining('Set on the desert planet Arrakis'),
      findsOneWidget,
    );
    expect(find.textContaining('<p>'), findsNothing);
  });

  testWidgets('when Google has nothing, genres still come out clean', (
    tester,
  ) async {
    await signIn(
      tester,
      google: FakeGoogleBooks(),
      scan: (_) async => '9780441172719',
    );
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/shelf/add');
    await tester.pumpAndSettle();
    await tapVisible(tester, find.byKey(const Key('scanIsbn')));
    expect(find.text('Science fiction'), findsWidgets);
    expect(find.text('Accessible book'), findsNothing);
  });

  testWidgets('Edit on a shelf book opens the edit form with that book', (
    tester,
  ) async {
    await signIn(tester);
    await tapVisible(tester, find.text(fixtureShelf.first.title));
    await tapVisible(tester, find.text('Edit'));
    expect(tester.takeException(), isNull);
    expect(find.text('Edit book'), findsOneWidget);
    expect(find.text(fixtureShelf.first.title), findsWidgets);
  });

  testWidgets('an existing book can refresh its genres and synopsis', (
    tester,
  ) async {
    await signIn(tester);
    final stale = fixtureShelf.first.copyWith(
      title: 'Dune',
      author: 'Frank Herbert',
      genre: 'Accessible book, Protected DAISY',
      description: '',
    );
    GoRouter.of(
      tester.element(find.byType(Scaffold).first),
    ).go('/shelf/add', extra: stale);
    await tester.pumpAndSettle();
    expect(find.text('Edit book'), findsOneWidget);
    expect(find.text('Accessible book'), findsOneWidget);

    await tapVisible(tester, find.byKey(const Key('refreshDetails')));
    expect(find.text('Updated genres and synopsis.'), findsOneWidget);
    expect(find.text('Accessible book'), findsNothing);
    expect(find.text('Science fiction'), findsWidgets);
    expect(
      find.textContaining('Set on the desert planet Arrakis'),
      findsOneWidget,
    );
  });

  testWidgets('new books do not offer the refresh button', (tester) async {
    await signIn(tester);
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/shelf/add');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('refreshDetails')), findsNothing);
  });
}
