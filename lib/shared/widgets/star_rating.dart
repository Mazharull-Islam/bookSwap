import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

/// A row of 5 stars. Read-only when [onChanged] is null; otherwise each
/// star is tappable to set the rating (1-5).
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
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (i) {
      final filled = (rating ?? 0) > i;
      final icon = Icon(
        filled ? Icons.star : Icons.star_border,
        size: size,
        color: context.colors.gold,
      );
      if (onChanged == null) return icon;
      return GestureDetector(onTap: () => onChanged!(i + 1), child: icon);
    }),
  );
}
