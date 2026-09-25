import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../domain/book_group.dart';

class BookGroupTile extends StatelessWidget {
  const BookGroupTile({super.key, required this.group, required this.onTap});
  final BookGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final book = group.representative;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: BookCoverImage(url: book.coverPhotoUrl, width: 48, height: 64),
        title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          book.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Chip(
          label: Text(
            group.ownerCount == 1
                ? '1 member'
                : '${group.ownerCount} members',
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
          backgroundColor: forest,
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
