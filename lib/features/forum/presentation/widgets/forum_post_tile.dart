import 'package:flutter/material.dart';
import '../../domain/models/forum_post.dart';
import '../../../../app/app_colors.dart';

String formatForumDate(int ms) => DateTime.fromMillisecondsSinceEpoch(
  ms,
).toLocal().toString().split(' ').first;

class ForumPostTile extends StatelessWidget {
  const ForumPostTile({super.key, required this.post, required this.onTap});

  final ForumPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      title: Text(
        post.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(
            post.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.textMuted),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${post.authorName} · ${formatForumDate(post.createdAtMs)}',
                style: TextStyle(fontSize: 12, color: context.colors.textFaint),
              ),
              if (post.genre != null) ...[
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    post.genre!,
                    style: const TextStyle(fontSize: 12),
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
              const Spacer(),
              Icon(
                Icons.favorite_border,
                size: 14,
                color: context.colors.textFaint,
              ),
              const SizedBox(width: 2),
              Text(
                '${post.likedBy.length}',
                style: TextStyle(fontSize: 12, color: context.colors.textFaint),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chat_bubble_outline,
                size: 14,
                color: context.colors.textFaint,
              ),
              const SizedBox(width: 2),
              Text(
                '${post.replyCount}',
                style: TextStyle(fontSize: 12, color: context.colors.textFaint),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
