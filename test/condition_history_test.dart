import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/books/domain/models/book.dart';
import 'package:bookswap_login/features/books/domain/repositories/book_repository.dart';
import 'package:bookswap_login/features/borrow_requests/application/use_cases/request_use_cases.dart';
import 'package:bookswap_login/features/borrow_requests/domain/loan_condition.dart';
import 'package:bookswap_login/features/borrow_requests/domain/models/borrow_request.dart';
import 'package:bookswap_login/features/borrow_requests/domain/repositories/request_repository.dart';
import 'package:bookswap_login/features/borrow_requests/presentation/providers/request_providers.dart';
import 'package:bookswap_login/features/reputation/domain/reputation_stats.dart';
import 'support/fake_request_repository.dart';
import 'support/test_app.dart';

class _MemoryBooks implements BookRepository {
  _MemoryBooks(Book book) : books = {book.id: book};
  final Map<String, Book> books;

  @override
  Future<Book?> getBook(String bookId) async => books[bookId];
  @override
  Future<Book> updateBook(Book book) async => books[book.id] = book;
  @override
  Stream<List<Book>> watchShelf(String ownerId) => const Stream.empty();
  @override
  Stream<List<Book>> watchAll() => const Stream.empty();
  @override
  Future<Book> addBook(Book book) async => book;
  @override
  Future<void> removeBook(String bookId) async {}
}

class _RecordingRequests extends FakeRequestRepository {
  String? acceptedCondition;

  @override
  Future<void> accept(
    String requestId, {
    required DateTime expectedReturnDate,
    required String lenderContact,
    required String conditionOut,
  }) async {
    acceptedCondition = conditionOut;
  }
}

const _book = Book(
  id: 'b1',
  ownerId: 'me',
  title: 'Dune',
  author: 'Frank Herbert',
  genre: 'Science fiction',
  condition: 'Good',
  estimatedValue: 100,
);

BorrowRequest loan({String? out, String? returned, bool done = true}) =>
    BorrowRequest(
      id: 'r',
      bookId: 'b1',
      bookTitle: 'Dune',
      borrowerId: 'u',
      lenderId: 'me',
      status: RequestStatus.accepted,
      requestedAt: 1,
      returnedAt: done ? 2 : null,
      conditionOut: out,
      conditionIn: returned,
    );

void main() {
  group('condition ranking', () {
    test('later in New, Like new, Good, Fair, Worn is worse', () {
      expect(conditionWorsened('Good', 'Fair'), isTrue);
      expect(conditionWorsened('New', 'Worn'), isTrue);
      expect(conditionWorsened('Good', 'Good'), isFalse);
      expect(conditionWorsened('Fair', 'Good'), isFalse);
    });

    test('unrecorded or unknown conditions are never flagged', () {
      expect(conditionWorsened(null, 'Worn'), isFalse);
      expect(conditionWorsened('Good', null), isFalse);
      expect(conditionWorsened('Good', 'Torn apart'), isFalse);
    });

    test('a request is flagged only once returned worse', () {
      expect(loan(out: 'Good', returned: 'Fair').conditionFlagged, isTrue);
      expect(loan(out: 'Good', returned: 'Good').conditionFlagged, isFalse);
      expect(loan(out: 'Good', done: false).conditionFlagged, isFalse);
    });
  });

  group('condition record (reputation)', () {
    test('counts recorded returns and how many came back worse', () {
      final record = computeConditionRecord([
        loan(out: 'Good', returned: 'Good'),
        loan(out: 'Good', returned: 'Fair'),
        loan(out: 'New', returned: 'New'),
        loan(), // an older loan with nothing recorded
        loan(out: 'Good', done: false), // still out
      ]);
      expect(record.recorded, 3);
      expect(record.flagged, 1);
    });
  });

  group('use cases', () {
    test('accepting snapshots the listing condition', () async {
      final requests = _RecordingRequests();
      await AcceptBorrowRequest(requests, _MemoryBooks(_book))(
        'r',
        bookId: 'b1',
        expectedReturnDate: DateTime(2030),
        lenderContact: '+8801700000000',
      );
      expect(requests.acceptedCondition, 'Good');
    });

    test(
      'returning records the condition and relists the book at it',
      () async {
        final requests = FakeRequestRepository();
        final books = _MemoryBooks(_book.copyWith(status: BookStatus.lent));
        await MarkLoanReturned(requests, books)(
          'r',
          bookId: 'b1',
          conditionIn: 'Fair',
        );
        expect(requests.returned, {'r': 'Fair'});
        expect(books.books['b1']?.status, BookStatus.available);
        expect(books.books['b1']?.condition, 'Fair');
      },
    );

    test('an unknown condition is rejected before anything is written', () {
      final requests = FakeRequestRepository();
      expect(
        () => MarkLoanReturned(requests, _MemoryBooks(_book))(
          'r',
          bookId: 'b1',
          conditionIn: 'Mint',
        ),
        throwsA(isA<RequestValidationFailure>()),
      );
      expect(requests.returned, isEmpty);
    });

    test('borrower notes are trimmed and bounded', () async {
      final requests = FakeRequestRepository();
      final add = AddBorrowerNote(requests);
      await add('r', '  It rained.  ');
      expect(requests.notes['r'], 'It rained.');
      expect(() => add('r', '   '), throwsA(isA<RequestValidationFailure>()));
      expect(
        () => add('r', 'x' * (maxBorrowerNoteLength + 1)),
        throwsA(isA<RequestValidationFailure>()),
      );
    });
  });

  group('screens', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    Future<FakeRequestRepository> open(
      WidgetTester tester,
      String path, {
      bool history = false,
    }) async {
      tester.view.physicalSize = const Size(390, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final fake = FakeRequestRepository();
      await signInWithFixtures(
        tester,
        overrides: [requestRepositoryProvider.overrideWithValue(fake)],
      );
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go(path);
      await tester.pumpAndSettle();
      if (history) await tapVisible(tester, find.text('History'));
      return fake;
    }

    final dialog = find.byType(AlertDialog);

    testWidgets('returning asks for the condition, defaulting to lent', (
      tester,
    ) async {
      final fake = await open(tester, '/requests');
      await tapVisible(tester, find.text('Mark as returned'));
      expect(find.text('When you lent it: Good'), findsOneWidget);
      expect(find.textContaining('This is worse than'), findsNothing);
      await tapVisible(
        tester,
        find.descendant(of: dialog, matching: find.text('Mark as returned')),
      );
      expect(fake.returned, {'in-2': 'Good'});
    });

    testWidgets('a worse condition is called out before confirming', (
      tester,
    ) async {
      final fake = await open(tester, '/requests');
      await tapVisible(tester, find.text('Mark as returned'));
      await tapVisible(
        tester,
        find.descendant(of: dialog, matching: find.text('Fair')),
      );
      expect(find.textContaining('This is worse than'), findsOneWidget);
      await tapVisible(
        tester,
        find.descendant(of: dialog, matching: find.text('Mark as returned')),
      );
      expect(fake.returned, {'in-2': 'Fair'});
    });

    testWidgets('cancelling the return records nothing', (tester) async {
      final fake = await open(tester, '/requests');
      await tapVisible(tester, find.text('Mark as returned'));
      await tapVisible(tester, find.text('Cancel'));
      expect(fake.returned, isEmpty);
    });

    testWidgets('active loans show the condition they went out in', (
      tester,
    ) async {
      await open(tester, '/requests');
      expect(find.text('Condition when lent: Good'), findsOneWidget);
    });

    testWidgets('History flags a book that came back worse', (tester) async {
      await open(tester, '/requests', history: true);
      expect(
        find.text('Condition: Like new → Good · came back worse'),
        findsOneWidget,
      );
      expect(find.text('Condition: Good → Fair · came back worse'), findsOne);
    });

    testWidgets('the borrower can add a note, and it must not be empty', (
      tester,
    ) async {
      final fake = await open(tester, '/requests', history: true);
      await tapVisible(tester, find.byKey(const Key('add-note-out-3')));
      await tapVisible(tester, find.byKey(const Key('saveNote')));
      expect(find.text('Write a short note first.'), findsOneWidget);
      expect(fake.notes, isEmpty);

      await tester.enterText(
        find.byKey(const Key('borrowerNoteField')),
        'Pages bent in my bag.',
      );
      await tapVisible(tester, find.byKey(const Key('saveNote')));
      expect(fake.notes, {'out-3': 'Pages bent in my bag.'});
    });

    testWidgets('the lender reads the note but cannot write one', (
      tester,
    ) async {
      await open(tester, '/requests', history: true);
      expect(
        find.text("Borrower's note: It got wet on the commute."),
        findsOneWidget,
      );
      expect(find.byKey(const Key('add-note-in-3')), findsNothing);
    });

    testWidgets('reputation shows how borrowed books came back', (
      tester,
    ) async {
      await open(tester, '/profile');
      expect(
        find.text('Books returned as good as lent: 0 of 1'),
        findsOneWidget,
      );
    });

    testWidgets('a book lists its past loans and conditions', (tester) async {
      await open(tester, '/shelf');
      await tapVisible(tester, find.text('The Left Hand of Darkness'));
      expect(find.text('Condition history'), findsOneWidget);
      expect(find.text('Good → Fair'), findsOneWidget);
    });
  });
}
