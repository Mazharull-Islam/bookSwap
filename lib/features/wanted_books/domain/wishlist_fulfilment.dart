import '../../books/domain/entities/book.dart';
import '../../borrow_requests/domain/entities/borrow_request.dart';
import '../../discovery/domain/book_group.dart';
import 'entities/wanted_book.dart';

/// The wishlist entries I no longer need because I borrowed that book and gave
/// it back.
///
/// An entry only counts if it was added before the loan was returned, so
/// adding the book again afterwards (to borrow it a second time) is kept.
/// Books are matched the same way Discovery and matches do; if the listing has
/// since been deleted, the request's title is all that is left to go on.
List<WantedBook> fulfilledWishlistEntries({
  required String myId,
  required List<BorrowRequest> outgoing,
  required List<WantedBook> mine,
  required List<Book> books,
}) {
  final booksById = {for (final b in books) b.id: b};
  final fulfilled = <WantedBook>{};
  for (final request in outgoing) {
    if (request.borrowerId != myId || !request.isCompleted) continue;
    final returnedAt = request.returnedAt!;
    final book = booksById[request.bookId];
    final key = book == null ? null : bookGroupKey(book);
    final title = request.bookTitle.trim().toLowerCase();
    for (final entry in mine) {
      if (entry.userId != myId || entry.addedAtMs > returnedAt) continue;
      final same = key != null
          ? entry.matchKey == key
          : entry.title.trim().toLowerCase() == title;
      if (same) fulfilled.add(entry);
    }
  }
  return fulfilled.toList();
}
