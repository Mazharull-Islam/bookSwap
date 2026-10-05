import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/features/books/domain/entities/book.dart';
import 'package:bookswap_login/features/borrow_requests/domain/entities/borrow_request.dart';
import 'package:bookswap_login/features/borrow_requests/presentation/providers/request_providers.dart';
import 'package:bookswap_login/features/discovery/presentation/providers/discovery_providers.dart';
import 'package:bookswap_login/features/wanted_books/domain/entities/wanted_book.dart';
import 'package:bookswap_login/features/wanted_books/domain/mutual_match.dart';
import 'package:bookswap_login/features/wanted_books/domain/wishlist_fulfilment.dart';
import 'package:bookswap_login/features/wanted_books/presentation/providers/wanted_book_providers.dart';
import 'support/fake_wanted_book_repository.dart';
import 'support/test_app.dart';

const me = 'demo-reader';
const they = 'owner-2';

const myBook = Book(
  id: 'mine-1',
  ownerId: me,
  title: 'The Left Hand of Darkness',
  author: 'Ursula K. Le Guin',
  genre: 'Science fiction',
  condition: 'Good',
  estimatedValue: 100,
  updatedAtMs: 1,
);
const theirBook = Book(
  id: 'theirs-1',
  ownerId: they,
  title: 'Project Hail Mary',
  author: 'Andy Weir',
  genre: 'Science fiction',
  condition: 'Good',
  estimatedValue: 100,
  updatedAtMs: 1,
);

WantedBook wanted(
  String id,
  String userId,
  Book book, {
  int addedAtMs = 1000,
}) => WantedBook(
  id: id,
  userId: userId,
  title: book.title,
  author: book.author,
  matchKey: '${book.title.toLowerCase()}|${book.author.toLowerCase()}',
  addedAtMs: addedAtMs,
);

BorrowRequest request(
  String id, {
  required Book book,
  String borrower = me,
  RequestStatus status = RequestStatus.pending,
  int? returnedAt,
}) => BorrowRequest(
  id: id,
  bookId: book.id,
  bookTitle: book.title,
  borrowerId: borrower,
  lenderId: book.ownerId,
  status: status,
  requestedAt: 1,
  returnedAt: returnedAt,
);

final myWishlist = wanted('w-mine', me, theirBook);
final theirWishlist = wanted('w-they', they, myBook);

void main() {
  group('a request from the other member shows on the match', () {
    List<MutualMatch> matches(List<BorrowRequest> incoming) =>
        findMutualMatches(
          myId: me,
          allBooks: const [myBook, theirBook],
          allWanted: [myWishlist, theirWishlist],
          incoming: incoming,
        );

    test('is none when nobody has asked', () {
      expect(matches(const []).single.requestFromThem, isNull);
    });

    test('is their request for my book', () {
      final ask = request('r1', book: myBook, borrower: they);
      expect(matches([ask]).single.requestFromThem, ask);
    });

    test(
      'ignores a declined or returned request, and one for another book',
      () {
        final others = [
          request(
            'r1',
            book: myBook,
            borrower: they,
            status: RequestStatus.declined,
          ),
          request(
            'r2',
            book: myBook,
            borrower: they,
            status: RequestStatus.accepted,
            returnedAt: 5,
          ),
          request('r3', book: theirBook, borrower: they),
          request('r4', book: myBook, borrower: 'someone-else'),
        ];
        expect(matches(others).single.requestFromThem, isNull);
      },
    );
  });

  group('which wishlist entries a finished loan fulfils', () {
    List<WantedBook> fulfilled(
      List<BorrowRequest> outgoing, {
      List<WantedBook>? mine,
      List<Book> books = const [theirBook],
    }) => fulfilledWishlistEntries(
      myId: me,
      outgoing: outgoing,
      mine: mine ?? [myWishlist],
      books: books,
    );

    BorrowRequest done({int returnedAt = 2000}) => request(
      'r1',
      book: theirBook,
      status: RequestStatus.accepted,
      returnedAt: returnedAt,
    );

    test('a borrowed and returned book comes off', () {
      expect(fulfilled([done()]), [myWishlist]);
    });

    test('nothing comes off while the loan is still going', () {
      expect(fulfilled([request('r1', book: theirBook)]), isEmpty);
      expect(
        fulfilled([
          request('r1', book: theirBook, status: RequestStatus.accepted),
        ]),
        isEmpty,
        reason: 'accepted and out on loan, not yet returned',
      );
    });

    test('a declined request does not count', () {
      expect(
        fulfilled([
          request(
            'r1',
            book: theirBook,
            status: RequestStatus.declined,
            returnedAt: 2000,
          ),
        ]),
        isEmpty,
      );
    });

    test('adding the book again after the return keeps the new entry', () {
      final again = wanted('w-again', me, theirBook, addedAtMs: 3000);
      expect(fulfilled([done()], mine: [myWishlist, again]), [myWishlist]);
    });

    test('other books on the wishlist stay', () {
      final other = wanted('w-other', me, myBook);
      expect(fulfilled([done()], mine: [myWishlist, other]), [myWishlist]);
    });

    test('works from the title when the listing has been deleted', () {
      expect(fulfilled([done()], books: const []), [myWishlist]);
    });

    test('someone else\'s loan, or wishlist, is never touched', () {
      expect(
        fulfilled([
          request(
            'r1',
            book: theirBook,
            borrower: 'someone-else',
            status: RequestStatus.accepted,
            returnedAt: 2000,
          ),
        ]),
        isEmpty,
      );
      expect(
        fulfilled([done()], mine: [wanted('w-x', 'someone-else', theirBook)]),
        isEmpty,
      );
    });
  });

  group('on screen', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    Future<FakeWantedBookRepository> open(
      WidgetTester tester, {
      List<BorrowRequest> incoming = const [],
      List<BorrowRequest> outgoing = const [],
      List<WantedBook>? mine,
    }) async {
      tester.view.physicalSize = const Size(390, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final wantedRepo = FakeWantedBookRepository();
      final overrides = <Override>[
        wantedBookRepositoryProvider.overrideWithValue(wantedRepo),
        allBooksProvider.overrideWith(
          (ref) => Stream.value(const [myBook, theirBook]),
        ),
        incomingRequestsProvider.overrideWith((ref) => Stream.value(incoming)),
        outgoingRequestsProvider.overrideWith((ref) => Stream.value(outgoing)),
        myWantedBooksProvider.overrideWith(
          (ref) => Stream.value(mine ?? [myWishlist]),
        ),
        allWantedBooksProvider.overrideWith(
          (ref) => Stream.value([
            ...(mine ?? [myWishlist]),
            theirWishlist,
          ]),
        ),
      ];
      await signInWithFixtures(tester, overrides: overrides);
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Wishlist'),
        ),
      );
      await tester.pumpAndSettle();
      return wantedRepo;
    }

    testWidgets('a fresh match offers to request their book', (tester) async {
      await open(tester);
      expect(find.text('Request their book'), findsOneWidget);
      expect(find.text('Review their request'), findsNothing);
    });

    testWidgets('once they have asked for mine, it points at their request', (
      tester,
    ) async {
      await open(
        tester,
        incoming: [request('in', book: myBook, borrower: they)],
      );
      expect(find.text('Request their book'), findsNothing);
      expect(
        find.text('They have asked to borrow The Left Hand of Darkness.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Review their request'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        3,
        reason: 'the Requests tab',
      );
    });

    testWidgets('my own pending request hides the match', (tester) async {
      await open(tester, outgoing: [request('out', book: theirBook)]);
      expect(find.text('Request their book'), findsNothing);
      expect(find.text('Mutual swap match'), findsNothing);
    });

    testWidgets('a returned loan no longer hides it from a second borrow', (
      tester,
    ) async {
      await open(
        tester,
        outgoing: [
          request(
            'out',
            book: theirBook,
            status: RequestStatus.accepted,
            returnedAt: 500,
          ),
        ],
      );
      expect(find.text('Request their book'), findsOneWidget);
    });

    testWidgets('a returned loan takes the book off my wishlist', (
      tester,
    ) async {
      final repo = await open(
        tester,
        outgoing: [
          request(
            'out',
            book: theirBook,
            status: RequestStatus.accepted,
            returnedAt: 2000,
          ),
        ],
      );
      expect(repo.removed, ['w-mine']);
    });

    testWidgets('a loan still out leaves the wishlist alone', (tester) async {
      final repo = await open(
        tester,
        outgoing: [
          request('out', book: theirBook, status: RequestStatus.accepted),
        ],
      );
      expect(repo.removed, isEmpty);
    });

    testWidgets('a book added again after the return stays', (tester) async {
      final repo = await open(
        tester,
        mine: [wanted('w-again', me, theirBook, addedAtMs: 3000)],
        outgoing: [
          request(
            'out',
            book: theirBook,
            status: RequestStatus.accepted,
            returnedAt: 2000,
          ),
        ],
      );
      expect(repo.removed, isEmpty);
    });
  });
}
