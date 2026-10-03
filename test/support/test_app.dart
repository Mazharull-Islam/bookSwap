import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bookswap_login/app/app.dart';
import 'package:bookswap_login/app/providers/book_sync_controller.dart';
import 'package:bookswap_login/core/database/hive_service.dart';
import 'package:bookswap_login/core/services/book_sync_service.dart';
import 'package:bookswap_login/core/services/public_profile_service.dart';
import 'package:bookswap_login/features/authentication/presentation/providers/auth_providers.dart';
import 'package:bookswap_login/features/blocking/domain/models/blocked_user.dart';
import 'package:bookswap_login/features/blocking/presentation/providers/block_providers.dart';
import 'package:bookswap_login/features/book_of_month/domain/models/book_of_month_nomination.dart';
import 'package:bookswap_login/features/book_of_month/domain/models/book_of_month_period.dart';
import 'package:bookswap_login/features/book_of_month/domain/models/book_of_month_vote.dart';
import 'package:bookswap_login/features/book_of_month/presentation/providers/book_of_month_providers.dart';
import 'package:bookswap_login/features/books/domain/models/book.dart';
import 'package:bookswap_login/features/books/presentation/providers/book_providers.dart';
import 'package:bookswap_login/features/borrow_requests/domain/models/borrow_request.dart';
import 'package:bookswap_login/features/borrow_requests/presentation/providers/request_providers.dart';
import 'package:bookswap_login/features/discovery/presentation/providers/discovery_providers.dart';
import 'package:bookswap_login/features/forum/domain/models/forum_post.dart';
import 'package:bookswap_login/features/forum/domain/models/forum_reply.dart';
import 'package:bookswap_login/features/forum/presentation/providers/forum_providers.dart';
import 'package:bookswap_login/features/leaderboard/domain/models/reading_activity.dart';
import 'package:bookswap_login/features/leaderboard/presentation/providers/leaderboard_providers.dart';
import 'package:bookswap_login/features/wanted_books/domain/models/wanted_book.dart';
import 'package:bookswap_login/features/wanted_books/presentation/providers/wanted_book_providers.dart';
import 'demo_auth_repository.dart';

class _NoopBookSyncService implements BookSyncService {
  @override
  Future<void> sync(String uid) async {}
}

const _fixtureNow = 1767225600000;

final fixtureShelf = [
  const Book(
    id: 'mine-1',
    ownerId: 'demo-reader',
    title: 'The Left Hand of Darkness',
    author: 'Ursula K. Le Guin',
    genre: 'Science fiction',
    condition: 'Good',
    estimatedValue: 350,
    updatedAtMs: _fixtureNow,
  ),
  const Book(
    id: 'mine-2',
    ownerId: 'demo-reader',
    title: 'Pride and Prejudice',
    author: 'Jane Austen',
    genre: 'Romance',
    condition: 'Fair',
    estimatedValue: 200,
    status: BookStatus.lent,
    updatedAtMs: _fixtureNow,
  ),
];

final fixtureOthersBooks = [
  const Book(
    id: 'o-1',
    ownerId: 'owner-2',
    title: 'Dune',
    author: 'Frank Herbert',
    genre: 'Science fiction',
    condition: 'Like new',
    estimatedValue: 500,
    updatedAtMs: _fixtureNow,
  ),
  const Book(
    id: 'o-2',
    ownerId: 'owner-3',
    title: 'Dune',
    author: 'Frank Herbert',
    genre: 'Science fiction',
    condition: 'Fair',
    estimatedValue: 300,
    status: BookStatus.lent,
    updatedAtMs: _fixtureNow,
  ),
];

final fixtureIncoming = [
  const BorrowRequest(
    id: 'in-1',
    bookId: 'mine-1',
    bookTitle: 'The Left Hand of Darkness',
    borrowerId: 'owner-2',
    lenderId: 'demo-reader',
    requestedAt: _fixtureNow,
  ),
  BorrowRequest(
    id: 'in-2',
    bookId: 'mine-2',
    bookTitle: 'Pride and Prejudice',
    borrowerId: 'owner-3',
    lenderId: 'demo-reader',
    status: RequestStatus.accepted,
    requestedAt: _fixtureNow,
    expectedReturnDateMs: DateTime.now()
        .add(const Duration(days: 7))
        .millisecondsSinceEpoch,
    borrowerContact: '+8801700000000',
    proposedReturnDateMs: DateTime.now()
        .add(const Duration(days: 14))
        .millisecondsSinceEpoch,
  ),
];

final fixtureOutgoing = [
  BorrowRequest(
    id: 'out-1',
    bookId: 'o-1',
    bookTitle: 'Dune',
    borrowerId: 'demo-reader',
    lenderId: 'owner-2',
    status: RequestStatus.accepted,
    requestedAt: _fixtureNow,
    expectedReturnDateMs: DateTime.now()
        .subtract(const Duration(days: 2))
        .millisecondsSinceEpoch,
    lenderContact: '+8801711111111',
  ),
  const BorrowRequest(
    id: 'out-2',
    bookId: 'o-2',
    bookTitle: 'Dune',
    borrowerId: 'demo-reader',
    lenderId: 'owner-3',
    requestedAt: _fixtureNow,
  ),
];

const fixturePost = ForumPost(
  id: 'post-1',
  authorId: 'owner-2',
  authorName: 'Rafi',
  title: 'Best science fiction of the decade?',
  body: 'Looking for recommendations after finishing Dune.',
  genre: 'Science fiction',
  createdAtMs: _fixtureNow,
  likedBy: ['owner-3'],
  replyCount: 1,
);

const fixtureReply = ForumReply(
  id: 'reply-1',
  postId: 'post-1',
  authorId: 'owner-3',
  authorName: 'Nadia',
  body: 'Try Project Hail Mary.',
  createdAtMs: _fixtureNow,
);

/// Overrides for every provider backed by real Firestore (no Firebase app
/// exists under flutter_test), filled with small fixtures so populated
/// screens can be exercised.
List<Override> firestoreFixtureOverrides() => [
  displayNameProvider.overrideWith((ref, id) async => 'Rafi'),
  allPublicProfilesProvider.overrideWith(
    (ref) => Stream.value(const <String, PublicProfile>{}),
  ),
  incomingRequestsProvider.overrideWith((ref) => Stream.value(fixtureIncoming)),
  outgoingRequestsProvider.overrideWith((ref) => Stream.value(fixtureOutgoing)),
  allWantedBooksProvider.overrideWith(
    (ref) => Stream.value(const <WantedBook>[]),
  ),
  myWantedBooksProvider.overrideWith(
    (ref) => Stream.value(const [
      WantedBook(
        id: 'w-1',
        userId: 'demo-reader',
        title: 'Project Hail Mary',
        author: 'Andy Weir',
        matchKey: 'project hail mary|andy weir',
        addedAtMs: _fixtureNow,
      ),
    ]),
  ),
  myBlockedUsersProvider.overrideWith(
    (ref) => Stream.value(const [
      BlockedUser(
        id: 'demo-reader_owner-9',
        blockerId: 'demo-reader',
        blockedId: 'owner-9',
        blockedName: 'Sam',
        createdAtMs: _fixtureNow,
      ),
    ]),
  ),
  forumFeedProvider.overrideWithValue(const [fixturePost]),
  forumPostProvider.overrideWith((ref, id) => Stream.value(fixturePost)),
  forumRepliesProvider.overrideWith((ref, id) => const [fixtureReply]),
  nominationsProvider.overrideWith(
    (ref, periodId) => Stream.value([
      BookOfMonthNomination(
        id: 'n-1',
        periodId: periodId,
        matchKey: 'dune|frank herbert',
        title: 'Dune',
        author: 'Frank Herbert',
        nominatedBy: 'owner-2',
        nominatedByName: 'Rafi',
        nominatedAtMs: _fixtureNow,
      ),
    ]),
  ),
  votesProvider.overrideWith(
    (ref, periodId) => Stream.value(const <BookOfMonthVote>[]),
  ),
  periodInfoProvider.overrideWith(
    (ref, periodId) => Stream.value(null as BookOfMonthPeriod?),
  ),
  knownPeriodsProvider.overrideWith(
    (ref) => Stream.value(const <BookOfMonthPeriod>[]),
  ),
  readingActivityProvider.overrideWith(
    (ref, periodId) => Stream.value([
      ReadingActivity(
        id: 'a-1',
        userId: 'owner-2',
        userName: 'Rafi',
        author: 'Frank Herbert',
        periodId: periodId,
        markedReadAtMs: _fixtureNow,
      ),
    ]),
  ),
];

/// Populated local (Hive-backed) lists for tests that need real-looking
/// screens; plain testApp() leaves the shelf empty.
List<Override> localFixtureOverrides() => [
  myShelfProvider.overrideWith((ref) => Stream.value(fixtureShelf)),
  allBooksProvider.overrideWith(
    (ref) => Stream.value([...fixtureShelf, ...fixtureOthersBooks]),
  ),
];

Widget testApp([
  DemoAuthRepository? repository,
  List<Override> extraOverrides = const [],
]) => ProviderScope(
  overrides: [
    authRepositoryProvider.overrideWithValue(
      repository ?? DemoAuthRepository(),
    ),
    bookSyncServiceProvider.overrideWithValue(_NoopBookSyncService()),
    // No Firebase app exists under flutter_test, so every Firestore-backed
    // provider the signed-in shell touches gets a safe stream.
    ...firestoreFixtureOverrides(),
    // Skip the periodic 2-minute sync timer entirely.
    bookSyncControllerProvider.overrideWith((ref) {}),
    ...extraOverrides,
  ],
  child: const BookSwapApp(),
);

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> signInDemo(
  WidgetTester tester, {
  List<Override> overrides = const [],
  DemoAuthRepository? repository,
}) async {
  await tester.pumpWidget(testApp(repository, overrides));
  await tester.pumpAndSettle();
  await tapVisible(tester, find.byKey(const Key('getStarted')));
  await tester.enterText(find.byKey(const Key('email')), 'reader@bookswap.app');
  await tester.enterText(find.byKey(const Key('password')), 'BookSwap123!');
  await tapVisible(tester, find.byKey(const Key('signIn')));
}

Future<void> signInWithFixtures(
  WidgetTester tester, {
  List<Override> overrides = const [],
}) => signInDemo(tester, overrides: [...localFixtureOverrides(), ...overrides]);

/// Opens the Hive boxes the signed-in screens read, in a throwaway folder.
Future<Directory> initTestHive() async {
  final dir = await Directory.systemTemp.createTemp('bookswap_hive_test_');
  Hive.init(dir.path);
  await Hive.openBox<Map>(HiveService.booksBoxName);
  await Hive.openBox<Map>(HiveService.readingBoxName);
  await Hive.openBox<Map>(HiveService.readingGoalsBoxName);
  await Hive.openBox<List>(HiveService.seenBadgesBoxName);
  return dir;
}

/// Known issue (investigation parked): once a test has reached /shelf,
/// Hive.close() never returns under flutter_test, which used to stall the
/// suite for 12 minutes. The app never calls Hive.close(), so this is a
/// test-harness-only problem; cleanup is best-effort so the run finishes.
Future<void> closeTestHive(Directory dir) async {
  try {
    await Hive.close().timeout(const Duration(seconds: 5));
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  } on TimeoutException {
    // Leave the temp dir; the OS clears it.
  } on FileSystemException {
    // Box files still locked after the close timed out.
  }
}

/// flutter_test draws every font as the same wide placeholder unless the real
/// ones are loaded, which makes overflow checks wildly pessimistic.
Future<void> loadTestFonts() async {
  final inter = FontLoader('Inter')
    ..addFont(rootBundle.load('assets/fonts/Inter-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Inter-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Inter-Bold.ttf'));
  final lora = FontLoader('Lora')
    ..addFont(rootBundle.load('assets/fonts/Lora-Bold.ttf'));
  await Future.wait([inter.load(), lora.load()]);
}
