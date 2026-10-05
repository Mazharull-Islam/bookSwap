import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../borrow_requests/presentation/providers/request_providers.dart';
import '../../../discovery/presentation/providers/discovery_providers.dart';
import '../../application/use_cases/wanted_book_use_cases.dart';
import '../../data/repositories/firestore_wanted_book_repository.dart';
import '../../domain/entities/wanted_book.dart';
import '../../domain/mutual_match.dart';
import '../../domain/repositories/wanted_book_repository.dart';
import '../../domain/wishlist_fulfilment.dart';
import '../../../../shared/widgets/view_mode.dart';

final wantedBookRepositoryProvider = Provider<WantedBookRepository>(
  (ref) => FirestoreWantedBookRepository(FirebaseFirestore.instance),
);

final myWantedBooksProvider = StreamProvider<List<WantedBook>>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  return ref.watch(wantedBookRepositoryProvider).watchMine(myId);
});

final allWantedBooksProvider = StreamProvider<List<WantedBook>>(
  (ref) => ref.watch(wantedBookRepositoryProvider).watchAll(),
);

final addWantedBookProvider = Provider(
  (ref) => AddWantedBook(ref.watch(wantedBookRepositoryProvider)),
);
final removeWantedBookProvider = Provider(
  (ref) => RemoveWantedBook(ref.watch(wantedBookRepositoryProvider)),
);

/// Recomputed reactively whenever the local book cache or anyone's wishlist
/// changes. Reuses discovery's `allBooksProvider` (Hive-local `watchAll`),
/// so a match against another member's shelf reflects the last sync, same
/// staleness tradeoff Discovery already accepts.
///
/// Matches already acted on are filtered out: once I've sent a request for
/// their book that is still going (not declined, not already returned),
/// showing the match card again is just clutter — the actual state now lives
/// on the Requests tab. A match where *they* asked for *my* book stays, marked
/// with their request, so the card can point me at it instead.
final mutualMatchesProvider = Provider<List<MutualMatch>>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  final books = ref.watch(allBooksProvider).valueOrNull ?? const [];
  final wanted = ref.watch(allWantedBooksProvider).valueOrNull ?? const [];
  final outgoing = ref.watch(outgoingRequestsProvider).valueOrNull ?? const [];
  final incoming = ref.watch(incomingRequestsProvider).valueOrNull ?? const [];
  final requestedBookIds = outgoing
      .where((r) => r.isOpen)
      .map((r) => r.bookId)
      .toSet();
  return findMutualMatches(
    myId: myId,
    allBooks: books,
    allWanted: wanted,
    incoming: incoming,
  ).where((m) => !requestedBookIds.contains(m.theirBook.id)).toList();
});

/// Takes a book off my wishlist once I've borrowed it and given it back. It
/// has to run on the borrower's device: the lender is the one who marks the
/// return, and only the owner of a wishlist entry may delete it. Watched from
/// the signed-in shell.
final fulfilledWishlistCleanupProvider = Provider<void>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  final outgoing = ref.watch(outgoingRequestsProvider);
  final mine = ref.watch(myWantedBooksProvider);
  // Wait for both lists: judging from half of them could miss or mis-pick.
  if (!outgoing.hasValue || !mine.hasValue) return;
  final books = ref.watch(allBooksProvider).valueOrNull ?? const [];
  final done = fulfilledWishlistEntries(
    myId: myId,
    outgoing: outgoing.requireValue,
    mine: mine.requireValue,
    books: books,
  );
  for (final entry in done) {
    // Deleting an entry that is already gone is harmless, and a failure (no
    // connection) is retried the next time the lists change.
    ref.read(removeWantedBookProvider)(entry.id).catchError((_) {});
  }
});

/// Grid or list for the wishlist; grid by default.
final wishlistViewModeProvider = StateProvider<ViewMode>(
  (ref) => ViewMode.grid,
);
