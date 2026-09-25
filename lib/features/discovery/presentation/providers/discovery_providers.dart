import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../books/domain/models/book.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../../domain/book_group.dart';

final allBooksProvider = StreamProvider<List<Book>>(
  (ref) => ref.watch(bookRepositoryProvider).watchAll(),
);

final discoverySearchQueryProvider = StateProvider<String>((ref) => '');

/// Null until a search is entered — distinguishes "nothing typed yet" from
/// "typed something, zero matches" for the empty-state UI.
final discoveryResultsProvider = Provider<List<BookGroup>?>((ref) {
  final query = ref.watch(discoverySearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return null;

  final books = ref.watch(allBooksProvider).valueOrNull ?? const <Book>[];
  final myId = ref.watch(currentUserProvider).id;
  final matches = books.where(
    (book) => book.ownerId != myId && book.title.toLowerCase().contains(query),
  );
  return groupBooksByWork(matches);
});

/// Independent of shelfViewModeProvider — toggling grid/list here shouldn't
/// affect My Shelf's view mode or vice versa.
final discoveryViewModeProvider = StateProvider<ShelfViewMode>(
  (ref) => ShelfViewMode.list,
);
