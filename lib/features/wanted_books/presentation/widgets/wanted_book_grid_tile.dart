import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/book_cover_image.dart';
import '../../domain/entities/wanted_book.dart';

/// A wishlist book as a cover tile, for the grid layout.
class WantedBookGridTile extends StatelessWidget {
  const WantedBookGridTile({
    super.key,
    required this.wanted,
    required this.onRemove,
  });

  final WantedBook wanted;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: BookCoverImage(
            url: wanted.coverUrl,
            borderRadius: 0,
            iconSize: 32,
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
                      wanted.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (wanted.author.isNotEmpty)
                      Text(
                        wanted.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove ${wanted.title}',
                iconSize: 20,
                icon: const Icon(Icons.delete_outline),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
