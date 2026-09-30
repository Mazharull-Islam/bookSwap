import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/use_cases/forum_use_cases.dart';
import '../../data/repositories/firestore_forum_repository.dart';
import '../../domain/models/forum_post.dart';
import '../../domain/models/forum_reply.dart';
import '../../domain/repositories/forum_repository.dart';

final forumRepositoryProvider = Provider<ForumRepository>(
  (ref) => FirestoreForumRepository(FirebaseFirestore.instance),
);

/// Reported posts are filtered out here — hidden from the general feed
/// immediately, per SRS §3.7's moderation-latency requirement. There's no
/// reviewer role to unhide one, so this is currently permanent once
/// reported; see the forum feature's known-gaps note.
final forumFeedProvider = Provider<List<ForumPost>>((ref) {
  final posts = ref.watch(_allPostsProvider).valueOrNull ?? const [];
  return posts.where((p) => !p.isReported).toList();
});

final _allPostsProvider = StreamProvider<List<ForumPost>>(
  (ref) => ref.watch(forumRepositoryProvider).watchPosts(),
);

final forumPostProvider = StreamProvider.family<ForumPost?, String>(
  (ref, postId) => ref.watch(forumRepositoryProvider).watchPost(postId),
);

/// Same reported-hiding treatment as the feed, applied to a single post's
/// replies.
final forumRepliesProvider = Provider.family<List<ForumReply>, String>((
  ref,
  postId,
) {
  final replies =
      ref.watch(_allRepliesProvider(postId)).valueOrNull ?? const [];
  return replies.where((r) => !r.isReported).toList();
});

final _allRepliesProvider = StreamProvider.family<List<ForumReply>, String>(
  (ref, postId) => ref.watch(forumRepositoryProvider).watchReplies(postId),
);

final createForumPostProvider = Provider(
  (ref) => CreateForumPost(ref.watch(forumRepositoryProvider)),
);
final createForumReplyProvider = Provider(
  (ref) => CreateForumReply(ref.watch(forumRepositoryProvider)),
);
final setPostLikedProvider = Provider(
  (ref) => SetPostLiked(ref.watch(forumRepositoryProvider)),
);
final setReplyLikedProvider = Provider(
  (ref) => SetReplyLiked(ref.watch(forumRepositoryProvider)),
);
final reportForumPostProvider = Provider(
  (ref) => ReportForumPost(ref.watch(forumRepositoryProvider)),
);
final reportForumReplyProvider = Provider(
  (ref) => ReportForumReply(ref.watch(forumRepositoryProvider)),
);
