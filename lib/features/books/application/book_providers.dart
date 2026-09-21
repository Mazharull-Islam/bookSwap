import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/current_user_provider.dart';
import '../data/fake_book_repository.dart';
import '../domain/book.dart';
import '../domain/book_repository.dart';

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => FakeBookRepository(),
);

final myShelfProvider = StreamProvider<List<Book>>((ref) {
  final ownerId = ref.watch(currentUserProvider).id;
  return ref.watch(bookRepositoryProvider).watchShelf(ownerId);
});

final addBookToShelfProvider = Provider(
  (ref) => AddBookToShelf(ref.watch(bookRepositoryProvider)),
);
final updateShelfBookProvider = Provider(
  (ref) => UpdateShelfBook(ref.watch(bookRepositoryProvider)),
);
final removeBookFromShelfProvider = Provider(
  (ref) => RemoveBookFromShelf(ref.watch(bookRepositoryProvider)),
);
