import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../domain/book_group.dart';

class BookGroupGridTile extends StatelessWidget {
  const BookGroupGridTile({
    super.key,
    required this.group,
    required this.onTap,
  });
  final BookGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final book = group.representative;
    return Card(
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
                        group.ownerCount == 1
                            ? '1 member'
                            : '${group.ownerCount} members',
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      backgroundColor: forest,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
                    style: const TextStyle(fontSize: 12, color: Color(0xFF617065)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
