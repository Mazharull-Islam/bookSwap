import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/book_cover_image.dart';
import '../../../reviews/presentation/providers/review_providers.dart';
import '../../../../shared/widgets/rating_badge.dart';
import '../../domain/book_group.dart';
import '../../../../shared/widgets/status_chip.dart';

class BookGroupGridTile extends ConsumerWidget {
  const BookGroupGridTile({
    super.key,
    required this.group,
    required this.onTap,
  });
  final BookGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = group.representative;
    final summary = ref.watch(ratingSummariesProvider)[group.key];
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
                    child: StatusChip.brand(
                      label: group.ownerCount == 1
                          ? '1 member'
                          : '${group.ownerCount} members',
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
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.textMuted,
                    ),
                  ),
                  RatingBadge(summary: summary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
