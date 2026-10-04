import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import '../../../../shared/widgets/book_cover_image.dart';
import '../../../../shared/widgets/book_status.dart';
import '../../../../shared/widgets/status_chip.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({
    super.key,
    required this.book,
    required this.onTap,
    required this.onDelete,
  });
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: BookCoverImage(url: book.coverPhotoUrl, width: 48, height: 64),
      title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${book.author} · ${book.genre}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatusChip(
            label: bookStatusLabel(book.status),
            color: bookStatusColor(book.status),
          ),
          IconButton(
            tooltip: 'Remove ${book.title}',
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    ),
  );
}
