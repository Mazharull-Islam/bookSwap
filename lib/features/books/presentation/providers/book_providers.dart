import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../application/use_cases/book_use_cases.dart';
import '../../data/repositories/hive_book_repository.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/shelf_filter.dart';
import '../../../../shared/widgets/view_mode.dart';

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => HiveBookRepository(),
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

final shelfViewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.grid);

final shelfFilterProvider = StateProvider<ShelfFilter>(
  (ref) => const ShelfFilter(),
);
