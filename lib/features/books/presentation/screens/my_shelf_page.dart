import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../core/services/book_sync_service.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/filter_widgets.dart';
import '../../domain/entities/book.dart';
import '../../domain/shelf_filter.dart';
import '../providers/book_providers.dart';
import '../widgets/book_detail_dialog.dart';
import '../widgets/book_grid_tile.dart';
import '../widgets/book_list_tile.dart';
import '../widgets/shelf_filter_sheet.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/feedback.dart';
import '../../../../shared/widgets/view_mode.dart';
import '../../../../shared/widgets/cover_grid.dart';

class MyShelfPage extends ConsumerStatefulWidget {
  const MyShelfPage({super.key});

  @override
  ConsumerState<MyShelfPage> createState() => _MyShelfPageState();
}

class _MyShelfPageState extends ConsumerState<MyShelfPage> {
  final _query = TextEditingController();

  /// The search text, as a notifier of its own: it only changes when the text
  /// does (not on cursor moves), and lets just the field and the list rebuild
  /// per keystroke instead of the whole page.
  final _text = ValueNotifier<String>('');

  @override
  void dispose() {
    _query.dispose();
    _text.dispose();
    super.dispose();
  }

  Future<void> _delete(WidgetRef ref, BuildContext context, Book book) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remove this book?',
      message: '"${book.title}" will be removed from your shelf.',
      confirmLabel: 'Remove',
    );
    if (confirmed) {
      await ref.read(removeBookFromShelfProvider)(book.id);
    }
  }

  void _openDetail(BuildContext context, Book book) {
    showBookDetailDialog(
      context,
      book: book,
      onEdit: () => context.push('/shelf/add', extra: book),
    );
  }

  Future<void> _refresh(WidgetRef ref) =>
      ref.read(bookSyncServiceProvider).sync(ref.read(currentUserProvider).id);

  List<Book> _filtered(List<Book> books, String query, ShelfFilter filter) {
    final q = query.trim().toLowerCase();
    final searched = q.isEmpty
        ? books
        : books
              .where(
                (b) =>
                    b.title.toLowerCase().contains(q) ||
                    b.author.toLowerCase().contains(q),
              )
              .toList();
    return applyShelfFilter(searched, filter);
  }

  @override
  Widget build(BuildContext context) {
    final shelf = ref.watch(myShelfProvider);
    final filter = ref.watch(shelfFilterProvider);
    final viewMode = ref.watch(shelfViewModeProvider);
    final isGrid = viewMode == ViewMode.grid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shelf'),
        actions: [
          ViewModeButton(
            mode: viewMode,
            onChanged: (mode) =>
                ref.read(shelfViewModeProvider.notifier).state = mode,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<String>(
                    valueListenable: _text,
                    builder: (context, text, _) => AppTextField(
                      controller: _query,
                      label: 'Search your shelf',
                      hint: 'Try a title or author...',
                      prefixIcon: Icons.search,
                      suffixIcon: text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _query.clear();
                                _text.value = '';
                              },
                            ),
                      onChanged: (value) => _text.value = value,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilterButton(
                  count: filter.activeCount,
                  onPressed: () => showFilterSheet(
                    context,
                    builder: (_) => const ShelfFilterSheet(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refresh(ref),
              child: ValueListenableBuilder<String>(
                valueListenable: _text,
                builder: (context, text, _) => shelf.when(
                  loading: () => const _ScrollableCenter(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => _ScrollableCenter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Could not load your shelf. Please try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                  data: (allBooks) {
                    final books = _filtered(allBooks, text, filter);
                    if (books.isEmpty) {
                      return _ScrollableCenter(
                        child: allBooks.isEmpty
                            ? const EmptyState(
                                icon: Icons.menu_book_outlined,
                                title: 'Your shelf is empty',
                                message:
                                    "Add a book you're willing to lend to get started.",
                              )
                            : const EmptyState(
                                icon: Icons.search_off,
                                message:
                                    'No books on your shelf match your search or filters.',
                              ),
                      );
                    }
                    return isGrid
                        ? GridView.builder(
                            padding: const EdgeInsets.all(12),
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate: coverGridDelegate,
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              return BookGridTile(
                                book: book,
                                onTap: () => _openDetail(context, book),
                                onDelete: () => _delete(ref, context, book),
                              );
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              return BookListTile(
                                book: book,
                                onTap: () => _openDetail(context, book),
                                onDelete: () => _delete(ref, context, book),
                              );
                            },
                          );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/shelf/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add a book'),
      ),
    );
  }
}

/// Wraps non-list states (loading/error/empty) in a scrollable so
/// [RefreshIndicator] can still be pulled even when there's nothing to
/// naturally scroll.
class _ScrollableCenter extends StatelessWidget {
  const _ScrollableCenter({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: constraints.maxHeight,
          child: Center(child: child),
        ),
      ],
    ),
  );
}
