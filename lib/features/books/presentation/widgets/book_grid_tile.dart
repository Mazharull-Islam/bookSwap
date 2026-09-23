import 'package:flutter/material.dart';
import '../../domain/models/book.dart';
import 'book_cover_image.dart';
import 'book_list_tile.dart';

class BookGridTile extends StatelessWidget {
  const BookGridTile({
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
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                BookCoverImage(
                  url: book.coverPhotoUrl,
                  borderRadius: 0,
                  iconSize: 32,
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Chip(
                    label: Text(
                      bookStatusLabel(book.status),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor: bookStatusColor(book.status),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF617065),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Remove',
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  iconSize: 18,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
