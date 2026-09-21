import 'book.dart';

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

class AddBookToShelf {
  const AddBookToShelf(this.repository);
  final BookRepository repository;

  Future<Book> call(Book book) {
    final error = book.validate();
    if (error != null) throw BookValidationFailure(error);
    return repository.addBook(book);
  }
}

class UpdateShelfBook {
  const UpdateShelfBook(this.repository);
  final BookRepository repository;

  Future<Book> call(Book book) {
    final error = book.validate();
    if (error != null) throw BookValidationFailure(error);
    return repository.updateBook(book);
  }
}

class RemoveBookFromShelf {
  const RemoveBookFromShelf(this.repository);
  final BookRepository repository;

  Future<void> call(String bookId) => repository.removeBook(bookId);
}
