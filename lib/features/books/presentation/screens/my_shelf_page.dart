import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/theme.dart';
import '../../../../core/services/book_sync_service.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/models/book.dart';
import '../providers/book_providers.dart';
import '../widgets/book_detail_dialog.dart';
import '../widgets/book_grid_tile.dart';
import '../widgets/book_list_tile.dart';

class MyShelfPage extends ConsumerWidget {
  const MyShelfPage({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelf = ref.watch(myShelfProvider);
    final viewMode = ref.watch(shelfViewModeProvider);
    final isGrid = viewMode == ShelfViewMode.grid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shelf'),
        actions: [
          IconButton(
            tooltip: isGrid ? 'Switch to list view' : 'Switch to grid view',
            icon: Icon(isGrid ? Icons.view_list_outlined : Icons.grid_view_outlined),
            onPressed: () => ref.read(shelfViewModeProvider.notifier).state =
                isGrid ? ShelfViewMode.list : ShelfViewMode.grid,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: shelf.when(
          loading: () => const _ScrollableCenter(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => _ScrollableCenter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load your shelf. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
          data: (books) => books.isEmpty
              ? const _ScrollableCenter(child: _EmptyShelf())
              : isGrid
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
                ),
        ),
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
          const Icon(Icons.menu_book_outlined, size: 64, color: forest),
          const SizedBox(height: 16),
          Text(
            'Your shelf is empty',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 22,
            ),
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
