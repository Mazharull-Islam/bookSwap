import 'package:flutter/material.dart';
import '../../domain/models/forum_post.dart';

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
            style: const TextStyle(color: Color(0xFF617065)),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${post.authorName} · ${formatForumDate(post.createdAtMs)}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9AA69C)),
              ),
              if (post.genre != null) ...[
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    post.genre!,
                    style: const TextStyle(fontSize: 10),
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
              const Spacer(),
              const Icon(
                Icons.favorite_border,
                size: 14,
                color: Color(0xFF9AA69C),
              ),
              const SizedBox(width: 2),
              Text(
                '${post.likedBy.length}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9AA69C)),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chat_bubble_outline,
                size: 14,
                color: Color(0xFF9AA69C),
              ),
              const SizedBox(width: 2),
              Text(
                '${post.replyCount}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9AA69C)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
