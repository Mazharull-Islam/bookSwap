import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../borrow_requests/domain/models/borrow_request.dart';
import '../../../borrow_requests/presentation/providers/request_providers.dart';
import '../../../discovery/presentation/providers/discovery_providers.dart';
import '../../application/use_cases/wanted_book_use_cases.dart';
import '../../data/repositories/firestore_wanted_book_repository.dart';
import '../../domain/models/wanted_book.dart';
import '../../domain/mutual_match.dart';
import '../../domain/repositories/wanted_book_repository.dart';

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
/// Matches already acted on are filtered out: once I've sent a (non-declined)
/// request for their book, showing the match card again is just clutter —
/// the actual state now lives on the Requests tab.
final mutualMatchesProvider = Provider<List<MutualMatch>>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  final books = ref.watch(allBooksProvider).valueOrNull ?? const [];
  final wanted = ref.watch(allWantedBooksProvider).valueOrNull ?? const [];
  final outgoing = ref.watch(outgoingRequestsProvider).valueOrNull ?? const [];
  final requestedBookIds = outgoing
      .where((r) => r.status != RequestStatus.declined)
      .map((r) => r.bookId)
      .toSet();
  return findMutualMatches(myId: myId, allBooks: books, allWanted: wanted)
      .where((m) => !requestedBookIds.contains(m.theirBook.id))
      .toList();
});
