import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/book_cover_image.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../domain/entities/reading_entry.dart';
import 'reading_status.dart';

/// A reading-list book as a cover tile, for the grid layout.
class ReadingEntryGridTile extends StatelessWidget {
  const ReadingEntryGridTile({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final ReadingEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.zero,
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
                  url: entry.coverUrl,
                  borderRadius: 0,
                  iconSize: 32,
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: StatusChip(
                    label: readingStatusLabel(entry.status),
                    color: readingStatusColor(entry.status),
                    shrinkTapTarget: true,
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
                  entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (entry.author.isNotEmpty)
                  Text(
                    entry.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.textMuted,
                    ),
                  ),
                if (entry.status == ReadingStatus.read &&
                    entry.rating != null) ...[
                  const SizedBox(height: 4),
                  StarRating(rating: entry.rating, size: 14),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
