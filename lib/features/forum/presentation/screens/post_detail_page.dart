import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/repositories/forum_repository.dart';
import '../providers/forum_providers.dart';
import '../widgets/forum_post_tile.dart' show formatForumDate;
import '../widgets/like_button.dart';
import '../widgets/reply_tile.dart';
import '../widgets/report_dialog.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/member_avatar.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({super.key, required this.postId});
  final String postId;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final _reply = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _sendReply() async {
    final body = _reply.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    final me = ref.read(currentUserProvider);
    try {
      await ref.read(createForumReplyProvider)(
        postId: widget.postId,
        authorId: me.id,
        authorName: me.displayName,
        body: body,
      );
      _reply.clear();
    } on ForumValidationFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _say(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _reportPost() async {
    final reason = await showReportDialog(context, what: 'post');
    if (reason == null) return;
    try {
      await ref.read(reportForumPostProvider)(
        widget.postId,
        ref.read(currentUserProvider).id,
        reason,
      );
      _say('Reported. You will no longer see this post.');
      if (mounted) Navigator.of(context).pop();
    } on ForumValidationFailure catch (e) {
      _say(e.message);
    }
  }

  Future<void> _reportReply(String replyId) async {
    final reason = await showReportDialog(context, what: 'reply');
    if (reason == null) return;
    try {
      await ref.read(reportForumReplyProvider)(
        widget.postId,
        replyId,
        ref.read(currentUserProvider).id,
        reason,
      );
      _say('Reported. You will no longer see this reply.');
    } on ForumValidationFailure catch (e) {
      _say(e.message);
    }
  }

  Future<void> _deletePost({required bool asModerator}) async {
    if (!await confirmRemoval(
      context,
      what: 'post',
      asModerator: asModerator,
    )) {
      return;
    }
    await ref.read(deleteForumPostProvider)(widget.postId);
    _say(asModerator ? 'Post removed.' : 'Post deleted.');
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _deleteReply(String replyId, {required bool asModerator}) async {
    if (!await confirmRemoval(
      context,
      what: 'reply',
      asModerator: asModerator,
    )) {
      return;
    }
    await ref.read(deleteForumReplyProvider)(widget.postId, replyId);
    _say(asModerator ? 'Reply removed.' : 'Reply deleted.');
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(forumPostProvider(widget.postId));
    final post = postState.valueOrNull;
    final replies = ref.watch(forumRepliesProvider(widget.postId));
    final myId = ref.watch(currentUserProvider).id;
    final moderator = ref.watch(isModeratorProvider).valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(post?.title ?? 'Post')),
      body: post == null
          ? postState.hasValue
                ? Center(
                    child: Text(
                      'This post is no longer available.',
                      style: TextStyle(color: context.colors.textMuted),
                    ),
                  )
                : const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          MemberAvatar(
                            userId: post.authorId,
                            name: post.authorName,
                            radius: 14,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${post.authorName} · ${formatForumDate(post.createdAtMs)}'
                              '${post.genre != null ? ' · ${post.genre}' : ''}',
                              style: TextStyle(color: context.colors.textMuted),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(post.body),
                      Row(
                        children: [
                          LikeButton(
                            liked: post.likedBy.contains(myId),
                            count: post.likedBy.length,
                            onToggle: () => ref.read(setPostLikedProvider)(
                              post.id,
                              myId,
                              !post.likedBy.contains(myId),
                            ),
                          ),
                          const Spacer(),
                          if (post.isHidden)
                            Text(
                              'Under review',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.colors.danger,
                              ),
                            ),
                          if (post.authorId != myId)
                            IconButton(
                              tooltip: 'Report',
                              icon: const Icon(Icons.flag_outlined),
                              onPressed: _reportPost,
                            ),
                          if (post.authorId == myId || moderator)
                            IconButton(
                              tooltip: post.authorId == myId
                                  ? 'Delete post'
                                  : 'Remove post',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deletePost(
                                asModerator: post.authorId != myId,
                              ),
                            ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        '${replies.length} ${replies.length == 1 ? 'reply' : 'replies'}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      ...replies.map(
                        (reply) => ReplyTile(
                          reply: reply,
                          likedByMe: reply.likedBy.contains(myId),
                          onToggleLike: () => ref.read(setReplyLikedProvider)(
                            widget.postId,
                            reply.id,
                            myId,
                            !reply.likedBy.contains(myId),
                          ),
                          onReport: () => _reportReply(reply.id),
                          canReport: reply.authorId != myId,
                          onRemove: reply.authorId == myId || moderator
                              ? () => _deleteReply(
                                  reply.id,
                                  asModerator: reply.authorId != myId,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _reply,
                            enabled: !_sending,
                            label: 'Write a reply...',
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          tooltip: 'Send reply',
                          onPressed: _sending ? null : _sendReply,
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
