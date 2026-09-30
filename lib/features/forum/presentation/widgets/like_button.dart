import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.liked,
    required this.count,
    required this.onToggle,
  });

  final bool liked;
  final int count;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: onToggle,
    style: TextButton.styleFrom(
      foregroundColor: liked ? forest : const Color(0xFF617065),
      visualDensity: VisualDensity.compact,
    ),
    icon: Icon(liked ? Icons.favorite : Icons.favorite_border, size: 18),
    label: Text('$count'),
  );
}
