import 'dart:async';

import '../../domain/models/book.dart';
import '../../domain/repositories/book_repository.dart';

/// Prototype only: in-memory book store used until Hive + Firestore-backed
/// repositories land. Keeps the books feature buildable and testable on its
/// own — swap this for the real repository in book_providers.dart later.
class FakeBookRepository implements BookRepository {
  final _books = <String, Book>{};
  final _changes = StreamController<void>.broadcast();
  var _nextId = 0;

  List<Book> _shelfFor(String ownerId) =>
      _books.values.where((book) => book.ownerId == ownerId).toList();

  @override
  Stream<List<Book>> watchShelf(String ownerId) async* {
    yield _shelfFor(ownerId);
    yield* _changes.stream.map((_) => _shelfFor(ownerId));
  }

  @override
  Future<Book?> getBook(String bookId) async => _books[bookId];

  @override
  Future<Book> addBook(Book book) async {
    final id = book.id.isNotEmpty ? book.id : 'book-${_nextId++}';
    final saved = book._withId(id);
    _books[id] = saved;
    _changes.add(null);
    return saved;
  }

  @override
  Future<Book> updateBook(Book book) async {
    if (!_books.containsKey(book.id)) {
      throw const BookValidationFailure('Book not found.');
    }
    _books[book.id] = book;
    _changes.add(null);
    return book;
  }

  @override
  Future<void> removeBook(String bookId) async {
    _books.remove(bookId);
    _changes.add(null);
  }
}

extension on Book {
  Book _withId(String id) => Book(
    id: id,
    ownerId: ownerId,
    title: title,
    author: author,
    genre: genre,
    condition: condition,
    estimatedValue: estimatedValue,
    description: description,
    coverPhotoUrl: coverPhotoUrl,
    isbn: isbn,
    status: status,
  );
}
