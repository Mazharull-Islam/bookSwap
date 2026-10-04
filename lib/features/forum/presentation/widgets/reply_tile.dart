import 'package:flutter/material.dart';
import '../../domain/models/forum_reply.dart';
import 'forum_post_tile.dart' show formatForumDate;
import 'like_button.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/member_avatar.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({
    super.key,
    required this.reply,
    required this.likedByMe,
    required this.onToggleLike,
    required this.onReport,
    this.onRemove,
    this.canReport = true,
  });

  final ForumReply reply;
  final bool likedByMe;
  final VoidCallback onToggleLike;
  final VoidCallback onReport;

  /// Set when the viewer may delete this reply (its author, or a moderator).
  final VoidCallback? onRemove;

  /// False for your own reply.
  final bool canReport;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: context.colors.surfaceSoft,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MemberAvatar(
              userId: reply.authorId,
              name: reply.authorName,
              radius: 12,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${reply.authorName} · ${formatForumDate(reply.createdAtMs)}',
                style: TextStyle(fontSize: 12, color: context.colors.textMuted),
              ),
            ),
            if (reply.isHidden)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  'Under review',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.colors.danger,
                  ),
                ),
              ),
            if (canReport)
              IconButton(
                tooltip: 'Report this reply',
                icon: const Icon(Icons.flag_outlined, size: 18),
                onPressed: onReport,
              ),
            if (onRemove != null)
              IconButton(
                tooltip: 'Delete this reply',
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: onRemove,
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
