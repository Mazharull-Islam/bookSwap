import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../providers/review_providers.dart';

const _maxShown = 5;

/// A book's average rating and its most recent written reviews.
class ReviewsSection extends ConsumerWidget {
  const ReviewsSection({super.key, required this.matchKey});
  final String matchKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsForBookProvider(matchKey));
    final summary = ref.watch(ratingSummariesProvider)[matchKey];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading('Reviews'),
        const SizedBox(height: 8),
        if (summary == null)
          Text(
            'No reviews yet. Members can rate a book after borrowing it.',
            style: Theme.of(context).textTheme.bodySmall,
          )
        else ...[
          Semantics(
            label: summary.spoken,
            excludeSemantics: true,
            child: Row(
              children: [
                StarRating(rating: summary.average.round()),
                const SizedBox(width: 8),
                Text(
                  '${summary.averageLabel} · ${summary.count} '
                  '${summary.count == 1 ? 'review' : 'reviews'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          for (final review in reviews.take(_maxShown))
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.surfaceSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Semantics(
                container: true,
                label:
                    '${review.reviewerName} rated ${review.rating} out of 5'
                    '${review.text.isEmpty ? '' : ': ${review.text}'}',
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.reviewerName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          formatDateMs(review.createdAtMs),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    StarRating(rating: review.rating, size: 14),
                    if (review.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(review.text),
                    ],
                  ],
                ),
              ),
            ),
          if (reviews.length > _maxShown)
            Text(
              '${reviews.length - _maxShown} more '
              '${reviews.length - _maxShown == 1 ? 'review' : 'reviews'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ],
    );
  }
}
