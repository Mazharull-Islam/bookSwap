import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/blocking/presentation/providers/block_providers.dart';
import 'package:bookswap_login/features/books/domain/entities/book.dart';
import 'package:bookswap_login/features/books/presentation/providers/book_providers.dart';
import 'package:bookswap_login/features/borrow_requests/domain/entities/borrow_request.dart';
import 'package:bookswap_login/features/borrow_requests/presentation/providers/request_providers.dart';
import 'support/fake_block_repository.dart';
import 'support/fake_book_repository.dart';
import 'support/fake_request_repository.dart';
import 'support/test_app.dart';

/// What the Requests screen does when a member acts on a request: accept,
/// block, share a contact, ask for more time, plus the empty and error states.
void main() {
  late Directory hiveDir;

  setUpAll(() async {
    hiveDir = await initTestHive();
  });

  tearDownAll(() => closeTestHive(hiveDir));

  late FakeRequestRepository requests;
  late FakeBookRepository books;
  late FakeBlockRepository blocks;

  Future<void> open(
    WidgetTester tester, {
    List<Override> more = const [],
    List<Book>? shelf,
  }) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    requests = FakeRequestRepository();
    books = FakeBookRepository(shelf ?? fixtureShelf);
    blocks = FakeBlockRepository();
    await signInWithFixtures(
      tester,
      overrides: [
        requestRepositoryProvider.overrideWithValue(requests),
        bookRepositoryProvider.overrideWithValue(books),
        blockRepositoryProvider.overrideWithValue(blocks),
        ...more,
      ],
    );
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/requests');
    await tester.pumpAndSettle();
  }

  Future<void> openTab(WidgetTester tester, String name) async {
    await tester.tap(find.widgetWithText(Tab, name));
    await tester.pumpAndSettle();
  }

  Future<void> pickDate(WidgetTester tester, {required bool confirm}) async {
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text(confirm ? 'OK' : 'Cancel'));
    await tester.pumpAndSettle();
  }

  group('Incoming', () {
    testWidgets('accepting asks for a return date, then records the loan', (
      tester,
    ) async {
      await open(tester);
      await tapVisible(tester, find.text('Accept request'));
      await pickDate(tester, confirm: true);
      // The lender's number is shared and the book's condition is snapshotted.
      expect(requests.accepted, {'in-1': '01712345678|Good'});
      expect(books.books['mine-1']!.status, BookStatus.lent);
    });

    testWidgets('cancelling the date picker accepts nothing', (tester) async {
      await open(tester);
      await tapVisible(tester, find.text('Accept request'));
      await pickDate(tester, confirm: false);
      expect(requests.accepted, isEmpty);
      expect(books.books['mine-1']!.status, BookStatus.available);
    });

    testWidgets('a book that is no longer available explains why', (
      tester,
    ) async {
      final lent = fixtureShelf.first.copyWith(status: BookStatus.lent);
      await open(tester, shelf: [lent, ...fixtureShelf.skip(1)]);
      await tapVisible(tester, find.text('Accept request'));
      await pickDate(tester, confirm: true);
      expect(find.text('This book is no longer available.'), findsOneWidget);
      expect(requests.accepted, isEmpty);
    });

    testWidgets('blocking asks first, then blocks and declines the request', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.byTooltip('Block this member').first);
      await tester.pumpAndSettle();
      expect(find.text('Block Rafi?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(blocks.blocked, isEmpty);

      await tester.tap(find.byTooltip('Block this member').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Block'));
      await tester.pumpAndSettle();
      expect(blocks.blocked, ['demo-reader>owner-2:Rafi']);
      expect(requests.declined, ['in-1']);
      expect(find.text('Blocked Rafi.'), findsOneWidget);
    });

    testWidgets('shows the borrower contact and the return line on a loan', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Borrower contact: +8801700000000'), findsOneWidget);
      expect(find.textContaining('due in'), findsOneWidget);
    });

    testWidgets('says so when no one has requested anything', (tester) async {
      await open(
        tester,
        more: [
          incomingRequestsProvider.overrideWith(
            (ref) => Stream.value(const <BorrowRequest>[]),
          ),
        ],
      );
      expect(find.text('No one has requested your books yet.'), findsOneWidget);
    });

    testWidgets('says so when the requests cannot be loaded', (tester) async {
      await open(
        tester,
        more: [
          incomingRequestsProvider.overrideWith(
            (ref) => Stream<List<BorrowRequest>>.error('boom'),
          ),
        ],
      );
      expect(
        find.text('Could not load requests. Please try again.'),
        findsOneWidget,
      );
    });
  });

  group('Outgoing', () {
    Future<void> openOutgoing(
      WidgetTester tester, {
      List<Override> more = const [],
    }) async {
      await open(tester, more: more);
      await openTab(tester, 'Outgoing');
    }

    testWidgets('a pending request says it is waiting on the owner', (
      tester,
    ) async {
      await openOutgoing(tester);
      expect(find.text('Waiting for the owner to respond.'), findsOneWidget);
    });

    testWidgets('an accepted loan shows the owner contact and overdue state', (
      tester,
    ) async {
      await openOutgoing(tester);
      expect(find.text('Owner contact: +8801711111111'), findsOneWidget);
      expect(find.textContaining('2 days overdue'), findsOneWidget);
    });

    testWidgets('sharing my contact sends my number', (tester) async {
      await openOutgoing(tester);
      await tapVisible(tester, find.text('Share my contact'));
      expect(requests.contactShared, {'out-1': '01712345678'});
    });

    testWidgets('requesting an extension proposes the chosen date', (
      tester,
    ) async {
      await openOutgoing(tester);
      await tapVisible(tester, find.text('Request extension'));
      await pickDate(tester, confirm: true);
      expect(requests.extensionsRequested.keys, ['out-1']);
      // The proposal is after the current return date.
      final due = DateTime.fromMillisecondsSinceEpoch(
        fixtureOutgoing.first.expectedReturnDateMs!,
      );
      expect(requests.extensionsRequested['out-1']!.isAfter(due), isTrue);
    });

    testWidgets('cancelling the date picker requests nothing', (tester) async {
      await openOutgoing(tester);
      await tapVisible(tester, find.text('Request extension'));
      await pickDate(tester, confirm: false);
      expect(requests.extensionsRequested, isEmpty);
    });

    testWidgets('a pending extension replaces the request button', (
      tester,
    ) async {
      final proposed = DateTime.now().add(const Duration(days: 9));
      await openOutgoing(
        tester,
        more: [
          outgoingRequestsProvider.overrideWith(
            (ref) => Stream.value([
              fixtureOutgoing.first.copyWith(
                proposedReturnDateMs: proposed.millisecondsSinceEpoch,
              ),
            ]),
          ),
        ],
      );
      expect(find.textContaining('awaiting approval'), findsOneWidget);
      expect(find.text('Request extension'), findsNothing);
    });

    testWidgets('says so when nothing has been requested', (tester) async {
      await openOutgoing(
        tester,
        more: [
          outgoingRequestsProvider.overrideWith(
            (ref) => Stream.value(const <BorrowRequest>[]),
          ),
        ],
      );
      expect(find.text("You haven't requested any books yet."), findsOneWidget);
    });
  });

  group('History', () {
    testWidgets('lists returned loans from both sides', (tester) async {
      await open(tester);
      await openTab(tester, 'History');
      expect(find.textContaining('Lent to Rafi · Returned'), findsOneWidget);
      expect(
        find.textContaining('Borrowed from Rafi · Returned'),
        findsOneWidget,
      );
      expect(
        find.textContaining(RegExp(r'Returned .+ · \d{1,2}:\d{2} (AM|PM)')),
        findsNWidgets(2),
        reason: 'the time of day is shown, not just the date',
      );
    });

    testWidgets('only a borrowed loan can be rated', (tester) async {
      await open(tester);
      await openTab(tester, 'History');
      expect(find.byKey(const Key('rate-out-3')), findsOneWidget);
      expect(find.byKey(const Key('rate-in-3')), findsNothing);
    });

    testWidgets('says so when there are no past loans', (tester) async {
      await open(
        tester,
        more: [
          incomingRequestsProvider.overrideWith(
            (ref) => Stream.value(const <BorrowRequest>[]),
          ),
          outgoingRequestsProvider.overrideWith(
            (ref) => Stream.value(const <BorrowRequest>[]),
          ),
        ],
      );
      await openTab(tester, 'History');
      expect(
        find.text(
          'Past loans will show up here once a loan is marked returned.',
        ),
        findsOneWidget,
      );
    });
  });
}
