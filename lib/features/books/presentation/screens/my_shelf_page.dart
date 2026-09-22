import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../domain/models/book.dart';
import '../providers/book_providers.dart';
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
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(removeBookFromShelfProvider)(book.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelf = ref.watch(myShelfProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Shelf')),
      body: shelf.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
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
            ? _EmptyShelf()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return BookListTile(
                    book: book,
                    onTap: () => context.push('/shelf/add', extra: book),
                    onDelete: () => _delete(ref, context, book),
                  );
                },
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

class _EmptyShelf extends StatelessWidget {
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
