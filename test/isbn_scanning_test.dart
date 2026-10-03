import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/core/services/open_library_service.dart';
import 'package:bookswap_login/core/utils/isbn.dart';
import 'package:bookswap_login/features/books/presentation/screens/scan_isbn_page.dart';
import 'support/test_app.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.respond);
  final ResponseBody Function(RequestOptions options) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => respond(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, [int status = 200]) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

OpenLibraryService _service(ResponseBody Function(RequestOptions) respond) =>
    OpenLibraryService(Dio()..httpClientAdapter = _FakeAdapter(respond));

const _duneIsbn = '9780441172719';
final _duneBooksApi = {
  'ISBN:$_duneIsbn': {
    'title': 'Dune',
    'authors': [
      {'name': 'Frank Herbert'},
    ],
    'cover': {'medium': 'https://example.com/dune.jpg'},
    'subjects': [
      {'name': 'Science fiction'},
    ],
    'publish_date': 'September 1, 2005',
  },
};

class _FakeOpenLibrary extends OpenLibraryService {
  _FakeOpenLibrary({this.result, this.fails = false}) : super(Dio());
  final BookMetadata? result;
  final bool fails;
  String? lastIsbn;

  @override
  Future<BookMetadata?> lookupByIsbn(String isbn) async {
    lastIsbn = isbn;
    if (fails) throw const BookLookupFailure('offline');
    return result;
  }

  @override
  Future<String?> fetchSynopsis(BookMetadata suggestion) async =>
      'A desert planet.';

  @override
  Future<List<BookMetadata>> searchByTitle(
    String query, {
    int limit = 8,
  }) async => const [];
}

const _dune = BookMetadata(
  title: 'Dune',
  author: 'Frank Herbert',
  isbn: _duneIsbn,
  genres: ['Science fiction'],
  publishedYear: '2005',
  workKey: '/works/OL893414W',
);

void main() {
  group('toIsbn13', () {
    test('accepts valid ISBN-13 with hyphens and spaces', () {
      expect(toIsbn13('978-0-441-17271-9'), _duneIsbn);
      expect(toIsbn13(' 978 0441 172719 '), _duneIsbn);
    });
    test('converts ISBN-10 (including a trailing X)', () {
      expect(toIsbn13('0441172717'), _duneIsbn);
      expect(toIsbn13('080442957X'), '9780804429573');
    });
    test('rejects bad checksums, short input and non-book barcodes', () {
      expect(toIsbn13('9780441172710'), isNull);
      expect(toIsbn13('0441172710'), isNull);
      expect(toIsbn13('12345'), isNull);
      expect(toIsbn13(''), isNull);
      expect(toIsbn13(null), isNull);
      // A valid EAN-13 for a product, not a book (no 978/979 prefix).
      expect(toIsbn13('4006381333931'), isNull);
    });
  });

  group('OpenLibraryService.lookupByIsbn', () {
    test('returns the book with its ISBN, year and work key', () async {
      final service = _service((o) {
        if (o.uri.path == '/api/books') return _json(_duneBooksApi);
        return _json({
          'works': [
            {'key': '/works/OL893414W'},
          ],
        });
      });
      final book = await service.lookupByIsbn(_duneIsbn);
      expect(book?.title, 'Dune');
      expect(book?.author, 'Frank Herbert');
      expect(book?.isbn, _duneIsbn);
      expect(book?.publishedYear, '2005');
      expect(book?.workKey, '/works/OL893414W');
    });

    test('unknown ISBN returns null', () async {
      final service = _service((_) => _json(<String, dynamic>{}));
      expect(await service.lookupByIsbn(_duneIsbn), isNull);
    });

    test('still returns the book when the work lookup 404s', () async {
      final service = _service((o) {
        if (o.uri.path == '/api/books') return _json(_duneBooksApi);
        return _json(<String, dynamic>{}, 404);
      });
      final book = await service.lookupByIsbn(_duneIsbn);
      expect(book?.title, 'Dune');
      expect(book?.workKey, isNull);
    });

    test('network failure throws BookLookupFailure', () async {
      final service = _service(
        (o) => throw DioException.connectionError(
          requestOptions: o,
          reason: 'offline',
        ),
      );
      expect(
        () => service.lookupByIsbn(_duneIsbn),
        throwsA(isA<BookLookupFailure>()),
      );
    });
  });

  group('Add a book', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    Future<void> openAddBook(
      WidgetTester tester, {
      required _FakeOpenLibrary library,
      Future<String?> Function(BuildContext)? scan,
    }) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await signInDemo(
        tester,
        overrides: [
          openLibraryServiceProvider.overrideWithValue(library),
          if (scan != null) isbnScannerProvider.overrideWithValue(scan),
        ],
      );
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/shelf/add');
      await tester.pumpAndSettle();
    }

    Future<void> typeIsbn(WidgetTester tester, String text) async {
      await tapVisible(tester, find.byKey(const Key('typeIsbn')));
      await tester.enterText(find.byKey(const Key('isbnField')), text);
      await tapVisible(tester, find.text('Find book'));
    }

    testWidgets('scanning fills in the book', (tester) async {
      final library = _FakeOpenLibrary(result: _dune);
      await openAddBook(tester, library: library, scan: (_) async => _duneIsbn);
      await tapVisible(tester, find.byKey(const Key('scanIsbn')));
      expect(library.lastIsbn, _duneIsbn);
      expect(find.text('Frank Herbert'), findsOneWidget);
      expect(find.text('A desert planet.'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Add to shelf'),
            )
            .onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('a cancelled scan does nothing', (tester) async {
      final library = _FakeOpenLibrary(result: _dune);
      await openAddBook(tester, library: library, scan: (_) async => null);
      await tapVisible(tester, find.byKey(const Key('scanIsbn')));
      expect(library.lastIsbn, isNull);
      expect(find.text('Frank Herbert'), findsNothing);
    });

    testWidgets('typed ISBNs are cleaned up and ISBN-10 is converted', (
      tester,
    ) async {
      final library = _FakeOpenLibrary(result: _dune);
      await openAddBook(tester, library: library);
      await typeIsbn(tester, '978-0-441-17271-9');
      expect(library.lastIsbn, _duneIsbn);

      final second = _FakeOpenLibrary(result: _dune);
      await openAddBook(tester, library: second);
      await typeIsbn(tester, '0441172717');
      expect(second.lastIsbn, _duneIsbn);
    });

    testWidgets('an invalid ISBN is rejected before any lookup', (
      tester,
    ) async {
      final library = _FakeOpenLibrary(result: _dune);
      await openAddBook(tester, library: library);
      await typeIsbn(tester, '123');
      expect(
        find.text('Enter a valid ISBN (10 or 13 digits).'),
        findsOneWidget,
      );
      expect(library.lastIsbn, isNull);
    });

    testWidgets('an unknown ISBN says so and points to title search', (
      tester,
    ) async {
      final library = _FakeOpenLibrary();
      await openAddBook(tester, library: library);
      await typeIsbn(tester, _duneIsbn);
      expect(
        find.text(
          "We couldn't find that ISBN. Try searching by title instead.",
        ),
        findsOneWidget,
      );
      expect(find.text('Frank Herbert'), findsNothing);
    });

    testWidgets('a lookup failure shows a friendly message', (tester) async {
      final library = _FakeOpenLibrary(fails: true);
      await openAddBook(tester, library: library);
      await typeIsbn(tester, _duneIsbn);
      expect(
        find.textContaining("Couldn't reach the book database"),
        findsOneWidget,
      );
      expect(find.textContaining('BookLookupFailure'), findsNothing);
    });
  });
}
