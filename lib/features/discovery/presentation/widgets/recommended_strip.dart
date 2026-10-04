import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../../../shared/widgets/book_cover_image.dart';
import '../../domain/recommendations.dart';
import '../providers/discovery_providers.dart';
import '../providers/recommendation_providers.dart';
import 'book_group_detail_dialog.dart';

/// A sideways strip of books picked for this member, shown above Discover's
/// results. It steps aside when they search or filter (they've said what they
/// want) and when there's nothing worth suggesting.
class RecommendedStrip extends ConsumerWidget {
  const RecommendedStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searching = ref.watch(discoverySearchQueryProvider).trim().isNotEmpty;
    final filtering = ref.watch(discoveryFilterProvider).activeCount > 0;
    final picks = ref.watch(recommendationsProvider);
    if (searching || filtering || picks.isEmpty) return const SizedBox.shrink();

    // Text grows with the member's font size, so the cards must too.
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading('Recommended for you'),
          const SizedBox(height: 8),
          SizedBox(
            height: 232 * scale,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: picks.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) =>
                  _RecommendationCard(pick: picks[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends ConsumerWidget {
  const _RecommendationCard({required this.pick});
  final Recommendation pick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = pick.group.representative;
    return SizedBox(
      width: 150,
      child: Semantics(
        container: true,
        label: '${book.title} by ${book.author}. ${pick.reason}',
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () => showBookGroupDetailDialog(context, pick.group),
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
                        iconSize: 28,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton.filledTonal(
                          tooltip: 'Not interested in ${book.title}',
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => ref
                              .read(dismissedRecommendationsProvider.notifier)
                              .dismiss(pick.group.key),
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
                      const SizedBox(height: 2),
                      Text(
                        pick.reason,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
