import 'package:bookswap_login/features/books/domain/entities/book.dart';
import 'package:bookswap_login/features/books/domain/repositories/book_repository.dart';

/// Books held in memory, so use cases that read and update a book can run
/// without Hive.
class FakeBookRepository implements BookRepository {
  FakeBookRepository(Iterable<Book> books) {
    for (final b in books) {
      this.books[b.id] = b;
    }
  }

  final books = <String, Book>{};

  @override
  Future<Book?> getBook(String bookId) async => books[bookId];

  @override
  Future<Book> updateBook(Book book) async => books[book.id] = book;

  @override
  Future<Book> addBook(Book book) async => books[book.id] = book;

  @override
  Future<void> removeBook(String bookId) async => books.remove(bookId);

  @override
  Stream<List<Book>> watchShelf(String ownerId) => const Stream.empty();

  @override
  Stream<List<Book>> watchAll() => const Stream.empty();
}
