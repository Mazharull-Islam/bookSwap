import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/repositories/forum_repository.dart';
import '../providers/forum_providers.dart';
import '../widgets/forum_post_tile.dart' show formatForumDate;
import '../widgets/like_button.dart';
import '../widgets/reply_tile.dart';

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

  Future<void> _reportPost() async {
    await ref.read(reportForumPostProvider)(
      widget.postId,
      ref.read(currentUserProvider).id,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reported. This post is now hidden from the feed.'),
        ),
      );
    }
  }

  Future<void> _reportReply(String replyId) async {
    await ref.read(reportForumReplyProvider)(
      widget.postId,
      replyId,
      ref.read(currentUserProvider).id,
    );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reported.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(forumPostProvider(widget.postId)).valueOrNull;
    final replies = ref.watch(forumRepliesProvider(widget.postId));
    final myId = ref.watch(currentUserProvider).id;

    return Scaffold(
      appBar: AppBar(title: Text(post?.title ?? 'Post')),
      body: post == null
          ? const Center(child: CircularProgressIndicator())
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
                      Text(
                        '${post.authorName} · ${formatForumDate(post.createdAtMs)}'
                        '${post.genre != null ? ' · ${post.genre}' : ''}',
                        style: const TextStyle(color: Color(0xFF617065)),
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
                          IconButton(
                            tooltip: 'Report',
                            icon: const Icon(Icons.flag_outlined),
                            onPressed: _reportPost,
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
