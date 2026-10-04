import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

/// A row of 5 stars. Read-only when [onChanged] is null (announced as "Rated
/// 4 out of 5"); otherwise each star is its own 48dp button (1-5).
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.onChanged,
    this.size = 20,
  });

  final int? rating;
  final ValueChanged<int>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final gold = context.colors.gold;
    final current = rating ?? 0;
    if (onChanged == null) {
      return Semantics(
        label: rating == null ? 'Not rated' : 'Rated $rating out of 5',
        excludeSemantics: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 5; i++)
              Icon(
                current > i ? Icons.star : Icons.star_border,
                size: size,
                color: gold,
              ),
          ],
        ),
      );
    }
    return Semantics(
      container: true,
      label: 'Rating',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 5; i++)
            IconButton(
              tooltip: '${i + 1} ${i == 0 ? 'star' : 'stars'}',
              isSelected: current == i + 1,
              onPressed: () => onChanged!(i + 1),
              iconSize: size,
              icon: Icon(
                current > i ? Icons.star : Icons.star_border,
                color: gold,
              ),
            ),
        ],
      ),
    );
  }
}
