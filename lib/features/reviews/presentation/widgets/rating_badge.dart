import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../domain/rating_summary.dart';

/// "★ 4.5 (3)" — nothing at all when a book has no reviews yet.
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.summary});
  final RatingSummary? summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    if (s == null) return const SizedBox.shrink();
    return Semantics(
      label: s.spoken,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: context.colors.gold),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              '${s.averageLabel} (${s.count})',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
