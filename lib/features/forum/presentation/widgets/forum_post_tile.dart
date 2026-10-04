import 'package:flutter/material.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/models/forum_post.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/member_avatar.dart';

String formatForumDate(int ms) => formatDateMs(ms);

class ForumPostTile extends StatelessWidget {
  const ForumPostTile({super.key, required this.post, required this.onTap});

  final ForumPost post;
  final VoidCallback onTap;

  String get _spokenLabel {
    final likes = post.likedBy.length;
    final replies = post.replyCount;
    return '${post.title}. ${post.body}. By ${post.authorName}, '
        '${formatForumDate(post.createdAtMs)}'
        '${post.genre != null ? ', ${post.genre}' : ''}. '
        '${post.isHidden ? 'Under review. ' : ''}'
        '$likes ${likes == 1 ? 'like' : 'likes'}, '
        '$replies ${replies == 1 ? 'reply' : 'replies'}';
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: _spokenLabel,
    onTap: onTap,
    excludeSemantics: true,
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
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
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MemberAvatar(
                      userId: post.authorId,
                      name: post.authorName,
                      radius: 10,
                    ),
                    const SizedBox(width: 6),
                    // Flexible so a long name wraps at large text sizes
                    // instead of overflowing the row.
                    Flexible(
                      child: Text(
                        '${post.authorName} · ${formatForumDate(post.createdAtMs)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.textFaint,
                        ),
                      ),
                    ),
                  ],
                ),
                if (post.isHidden)
                  Text(
                    'Under review',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.colors.danger,
                    ),
                  ),
                if (post.genre != null)
                  Chip(
                    label: Text(
                      post.genre!,
                      style: const TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 14,
                      color: context.colors.textFaint,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${post.likedBy.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.textFaint,
                      ),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.textFaint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
