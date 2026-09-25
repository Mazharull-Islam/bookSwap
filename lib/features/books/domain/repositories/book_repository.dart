import '../models/book.dart';

class BookValidationFailure implements Exception {
  const BookValidationFailure(this.message);
  final String message;
}

abstract interface class BookRepository {
  Stream<List<Book>> watchShelf(String ownerId);
  /// Every book known locally, regardless of owner — used for search/
  /// discovery. Local-first: reflects whatever the last sync pulled down,
  /// not a live network query.
  Stream<List<Book>> watchAll();
  Future<Book?> getBook(String bookId);
  Future<Book> addBook(Book book);
  Future<Book> updateBook(Book book);
  Future<void> removeBook(String bookId);
}
