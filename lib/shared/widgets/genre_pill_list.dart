import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

/// Small rounded genre tags, wrapped onto multiple lines as needed.
class GenrePillList extends StatelessWidget {
  const GenrePillList({
    super.key,
    required this.genres,
    this.alignment = WrapAlignment.start,
  });

  final List<String> genres;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: alignment,
    spacing: 6,
    runSpacing: 6,
    children: genres
        .map(
          (genre) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: context.colors.brand,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              genre,
              style: TextStyle(fontSize: 12, color: context.colors.onBrand),
            ),
          ),
        )
        .toList(),
  );
}
