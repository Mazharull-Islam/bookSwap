import 'package:flutter/material.dart';
import '../../domain/models/forum_reply.dart';
import 'forum_post_tile.dart' show formatForumDate;
import 'like_button.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({
    super.key,
    required this.reply,
    required this.likedByMe,
    required this.onToggleLike,
    required this.onReport,
  });

  final ForumReply reply;
  final bool likedByMe;
  final VoidCallback onToggleLike;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFE9EEDF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${reply.authorName} · ${formatForumDate(reply.createdAtMs)}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF617065)),
              ),
            ),
            IconButton(
              tooltip: 'Report',
              icon: const Icon(Icons.flag_outlined, size: 18),
              visualDensity: VisualDensity.compact,
              onPressed: onReport,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(reply.body),
        LikeButton(
          liked: likedByMe,
          count: reply.likedBy.length,
          onToggle: onToggleLike,
        ),
      ],
    ),
  );
}
