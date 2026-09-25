import '../../books/domain/models/book.dart';

/// Groups editions of the same underlying work together. Keyed by
/// [Book.workKey] when available (the canonical cross-edition identity —
/// see the duplicate-shelf-entry work this reuses), falling back to a
/// normalized title+author match for books added before workKey existed.
String bookGroupKey(Book book) {
  final workKey = book.workKey;
  if (workKey != null && workKey.isNotEmpty) return workKey;
  return '${book.title.trim().toLowerCase()}|${book.author.trim().toLowerCase()}';
}

/// One searchable result: every listing (one per owner/edition) of what a
/// user would consider "the same book," regardless of which edition each
/// owner actually has.
class BookGroup {
  const BookGroup({required this.key, required this.listings});

  final String key;
  final List<Book> listings;

  Book get representative => listings.first;
  int get ownerCount => listings.map((b) => b.ownerId).toSet().length;
}

List<BookGroup> groupBooksByWork(Iterable<Book> books) {
  final byKey = <String, List<Book>>{};
  for (final book in books) {
    byKey.putIfAbsent(bookGroupKey(book), () => []).add(book);
  }
  final groups = byKey.entries
      .map((entry) => BookGroup(key: entry.key, listings: entry.value))
      .toList();
  groups.sort(
    (a, b) => a.representative.title.toLowerCase().compareTo(
      b.representative.title.toLowerCase(),
    ),
  );
  return groups;
}
