import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../../reviews/presentation/providers/review_providers.dart';
import '../../../reviews/presentation/widgets/rating_badge.dart';
import '../../domain/book_group.dart';

class BookGroupTile extends ConsumerWidget {
  const BookGroupTile({super.key, required this.group, required this.onTap});
  final BookGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = group.representative;
    final summary = ref.watch(ratingSummariesProvider)[group.key];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: BookCoverImage(url: book.coverPhotoUrl, width: 48, height: 64),
        title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis),
            RatingBadge(summary: summary),
          ],
        ),
        trailing: Chip(
          label: Text(
            group.ownerCount == 1 ? '1 member' : '${group.ownerCount} members',
            style: TextStyle(fontSize: 12, color: context.colors.onBrand),
          ),
          backgroundColor: context.colors.brand,
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
