import '../models/book.dart';

class BookValidationFailure implements Exception {
  const BookValidationFailure(this.message);
  final String message;
}

abstract interface class BookRepository {
  Stream<List<Book>> watchShelf(String ownerId);
  Future<Book?> getBook(String bookId);
  Future<Book> addBook(Book book);
  Future<Book> updateBook(Book book);
  Future<void> removeBook(String bookId);
}
