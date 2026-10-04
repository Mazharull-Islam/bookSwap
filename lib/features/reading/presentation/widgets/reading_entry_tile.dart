import 'package:flutter/material.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../../../shared/widgets/book_cover_image.dart';
import '../../domain/entities/reading_entry.dart';
import 'reading_status.dart';

class ReadingEntryTile extends StatelessWidget {
  const ReadingEntryTile({super.key, required this.entry, required this.onTap});

  final ReadingEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: BookCoverImage(url: entry.coverUrl, width: 44, height: 60),
      title: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (entry.author.isNotEmpty)
            Text(entry.author, maxLines: 1, overflow: TextOverflow.ellipsis),
          if (entry.status == ReadingStatus.read && entry.rating != null) ...[
            const SizedBox(height: 4),
            StarRating(rating: entry.rating, size: 14),
          ],
        ],
      ),
      trailing: Chip(
        label: Text(
          readingStatusLabel(entry.status),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: readingStatusColor(entry.status),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    ),
  );
}
