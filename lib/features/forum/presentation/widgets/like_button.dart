import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

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
  Widget build(BuildContext context) => Semantics(
    button: true,
    toggled: liked,
    label: '$count ${count == 1 ? 'like' : 'likes'}',
    hint: liked ? 'Double tap to remove your like' : 'Double tap to like',
    onTap: onToggle,
    excludeSemantics: true,
    child: TextButton.icon(
      onPressed: onToggle,
      style: TextButton.styleFrom(
        foregroundColor: liked
            ? context.colors.brand
            : context.colors.textMuted,
        minimumSize: const Size(48, 48),
      ),
      icon: Icon(liked ? Icons.favorite : Icons.favorite_border, size: 18),
      label: Text('$count'),
    ),
  );
}
