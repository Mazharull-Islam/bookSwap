import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/services/book_sync_service.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/filter_widgets.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/models/book.dart';
import '../../domain/shelf_filter.dart';
import '../providers/book_providers.dart';
import '../widgets/book_detail_dialog.dart';
import '../widgets/book_grid_tile.dart';
import '../widgets/book_list_tile.dart';
import '../widgets/shelf_filter_sheet.dart';

class MyShelfPage extends ConsumerStatefulWidget {
  const MyShelfPage({super.key});

  @override
  ConsumerState<MyShelfPage> createState() => _MyShelfPageState();
}

class _MyShelfPageState extends ConsumerState<MyShelfPage> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _delete(WidgetRef ref, BuildContext context, Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove this book?'),
        content: Text('"${book.title}" will be removed from your shelf.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Remove',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (confirmed == true) {
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
    final isGrid = viewMode == ShelfViewMode.grid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shelf'),
        actions: [
          IconButton(
            tooltip: isGrid ? 'Switch to list view' : 'Switch to grid view',
            icon: Icon(
              isGrid ? Icons.view_list_outlined : Icons.grid_view_outlined,
            ),
            onPressed: () => ref.read(shelfViewModeProvider.notifier).state =
                isGrid ? ShelfViewMode.list : ShelfViewMode.grid,
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
                  child: AppTextField(
                    controller: _query,
                    label: 'Search your shelf',
                    hint: 'Try a title or author...',
                    prefixIcon: Icons.search,
                    suffixIcon: _query.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _query.clear();
                              setState(() {});
                            },
                          ),
                    onChanged: (_) => setState(() {}),
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
              child: shelf.when(
                loading: () =>
                    const _ScrollableCenter(child: CircularProgressIndicator()),
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
                  final books = _filtered(allBooks, _query.text, filter);
                  if (books.isEmpty) {
                    return _ScrollableCenter(
                      child: allBooks.isEmpty
                          ? const _EmptyShelf()
                          : const _NoSearchResults(),
                    );
                  }
                  return isGrid
                      ? GridView.builder(
                          padding: const EdgeInsets.all(12),
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 180,
                                childAspectRatio: 0.62,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
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

class _EmptyShelf extends StatelessWidget {
  const _EmptyShelf();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_outlined, size: 64, color: context.colors.brand),
          const SizedBox(height: 16),
          Text(
            'Your shelf is empty',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Add a book you\'re willing to lend to get started.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 56, color: context.colors.brand),
          const SizedBox(height: 16),
          Text(
            'No books on your shelf match your search or filters.',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textMuted),
          ),
        ],
      ),
    ),
  );
}
