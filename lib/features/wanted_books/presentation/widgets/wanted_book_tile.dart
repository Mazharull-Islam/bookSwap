import 'package:flutter/material.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../domain/entities/wanted_book.dart';

class WantedBookTile extends StatelessWidget {
  const WantedBookTile({
    super.key,
    required this.wanted,
    required this.onRemove,
  });

  final WantedBook wanted;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: BookCoverImage(url: wanted.coverUrl, width: 44, height: 60),
      title: Text(wanted.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: wanted.author.isEmpty
          ? null
          : Text(wanted.author, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        tooltip: 'Remove',
        icon: const Icon(Icons.delete_outline),
        onPressed: onRemove,
      ),
    ),
  );
}
