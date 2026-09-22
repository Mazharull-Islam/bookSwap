import '../../domain/models/book.dart';
import '../../domain/repositories/book_repository.dart';

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
