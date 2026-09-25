import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_service.dart';
import '../../domain/models/book.dart';
import '../../domain/repositories/book_repository.dart';

/// Local-first storage for books, backed by Hive. Source of truth on-device
/// between syncs — writes here resolve immediately, no network involved.
class HiveBookRepository implements BookRepository {
  Box<Map> get _box => HiveService.booksBox;

  Book _decode(dynamic raw) =>
      Book.fromJson(Map<String, dynamic>.from(raw as Map));

  List<Book> _shelfFor(String ownerId) => _box.values
      .map(_decode)
      .where((book) => book.ownerId == ownerId)
      .toList();

  @override
  Stream<List<Book>> watchShelf(String ownerId) async* {
    yield _shelfFor(ownerId);
    yield* _box.watch().map((_) => _shelfFor(ownerId));
  }

  @override
  Stream<List<Book>> watchAll() async* {
    yield _box.values.map(_decode).toList();
    yield* _box.watch().map((_) => _box.values.map(_decode).toList());
  }

  @override
  Future<Book?> getBook(String bookId) async {
    final raw = _box.get(bookId);
    return raw == null ? null : _decode(raw);
  }

  @override
  Future<Book> addBook(Book book) async {
    final id = book.id.isNotEmpty
        ? book.id
        : 'book-${DateTime.now().microsecondsSinceEpoch}';
    final saved = book.copyWith(
      id: id,
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await _box.put(id, saved.toJson());
    return saved;
  }

  @override
  Future<Book> updateBook(Book book) async {
    if (!_box.containsKey(book.id)) {
      throw const BookValidationFailure('Book not found.');
    }
    final saved = book.copyWith(
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await _box.put(book.id, saved.toJson());
    return saved;
  }

  @override
  Future<void> removeBook(String bookId) async {
    await _box.delete(bookId);
  }
}
