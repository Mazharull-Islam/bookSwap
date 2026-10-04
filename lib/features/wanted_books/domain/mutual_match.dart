import '../../books/domain/models/book.dart';
import '../../discovery/domain/book_group.dart';
import 'models/wanted_book.dart';

/// A mutual swap opportunity (SRS §3.5): I own [myBook], which [otherUserId]
/// wants; [otherUserId] owns [theirBook], which I want.
class MutualMatch {
  const MutualMatch({
    required this.otherUserId,
    required this.myBook,
    required this.theirBook,
  });

  final String otherUserId;
  final Book myBook;
  final Book theirBook;
}

/// Computed independently on each user's own device from the same two
/// globally-readable streams (all books, all wanted-book entries) — so both
/// sides of a match surface it without a server-side matching step.
List<MutualMatch> findMutualMatches({
  required String myId,
  required List<Book> allBooks,
  required List<WantedBook> allWanted,
}) {
  final myBooks = allBooks
      .where((b) => b.ownerId == myId && b.status == BookStatus.available)
      .toList();
  final myWantedKeys = allWanted
      .where((w) => w.userId == myId)
      .map((w) => w.matchKey)
      .toSet();
  if (myBooks.isEmpty || myWantedKeys.isEmpty) return const [];

  final matches = <MutualMatch>[];
  final seenPairs = <String>{};
  for (final wanted in allWanted) {
    if (wanted.userId == myId) continue;
    final matchingMyBooks = myBooks.where(
      (b) => bookGroupKey(b) == wanted.matchKey,
    );
    if (matchingMyBooks.isEmpty) continue;
    final theirBooks = allBooks.where(
      (b) =>
          b.ownerId == wanted.userId &&
          b.status == BookStatus.available &&
          myWantedKeys.contains(bookGroupKey(b)),
    );
    for (final myBook in matchingMyBooks) {
      for (final theirBook in theirBooks) {
        if (seenPairs.add('${wanted.userId}|${myBook.id}|${theirBook.id}')) {
          matches.add(
            MutualMatch(
              otherUserId: wanted.userId,
              myBook: myBook,
              theirBook: theirBook,
            ),
          );
        }
      }
    }
  }
  return matches;
}
