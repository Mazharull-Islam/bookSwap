import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../application/use_cases/forum_use_cases.dart';
import '../../data/repositories/firestore_forum_repository.dart';
import '../../domain/entities/forum_post.dart';
import '../../domain/entities/forum_reply.dart';
import '../../domain/entities/forum_report.dart';
import '../../domain/repositories/forum_repository.dart';

final forumRepositoryProvider = Provider<ForumRepository>(
  (ref) => FirestoreForumRepository(FirebaseFirestore.instance),
);

/// Whether the signed-in member is a moderator. Moderators are added by hand
/// in the Firebase console (a doc in `moderators/{uid}`); nothing in the app
/// can grant the role, and the rules enforce it independently of this flag.
final isModeratorProvider = StreamProvider<bool>((ref) {
  final me = ref.watch(currentUserProvider);
  return ref.watch(forumRepositoryProvider).watchIsModerator(me.id);
});

bool _isModerator(Ref ref) =>
    ref.watch(isModeratorProvider).valueOrNull ?? false;

/// What the signed-in member should see. Anything they reported themselves is
/// gone for them straight away; anything enough people reported is pulled from
/// everyone's feed, except for its author (who sees it flagged as under
/// review) and moderators (who need to see it to act on it).
bool visibleToMember({
  required List<String> reportedBy,
  required bool hidden,
  required String authorId,
  required String memberId,
  required bool moderator,
}) {
  if (reportedBy.contains(memberId)) return false;
  if (!hidden) return true;
  return authorId == memberId || moderator;
}

final forumFeedProvider = Provider<List<ForumPost>>((ref) {
  final posts = ref.watch(_allPostsProvider).valueOrNull ?? const [];
  final me = ref.watch(currentUserProvider).id;
  final moderator = _isModerator(ref);
  return posts
      .where(
        (p) => visibleToMember(
          reportedBy: p.reportedBy,
          hidden: p.isHidden,
          authorId: p.authorId,
          memberId: me,
          moderator: moderator,
        ),
      )
      .toList();
});

final _allPostsProvider = StreamProvider<List<ForumPost>>(
  (ref) => ref.watch(forumRepositoryProvider).watchPosts(),
);

final forumPostProvider = StreamProvider.family<ForumPost?, String>(
  (ref, postId) => ref.watch(forumRepositoryProvider).watchPost(postId),
);

/// Same visibility rules as the feed, applied to a single post's replies.
final forumRepliesProvider = Provider.family<List<ForumReply>, String>((
  ref,
  postId,
) {
  final replies =
      ref.watch(_allRepliesProvider(postId)).valueOrNull ?? const [];
  final me = ref.watch(currentUserProvider).id;
  final moderator = _isModerator(ref);
  return replies
      .where(
        (r) => visibleToMember(
          reportedBy: r.reportedBy,
          hidden: r.isHidden,
          authorId: r.authorId,
          memberId: me,
          moderator: moderator,
        ),
      )
      .toList();
});

final _allRepliesProvider = StreamProvider.family<List<ForumReply>, String>(
  (ref, postId) => ref.watch(forumRepositoryProvider).watchReplies(postId),
);

/// Moderators' queue: everything with at least one report, most-reported first.
final reportedTargetsProvider = StreamProvider<List<ReportedTarget>>(
  (ref) => ref.watch(forumRepositoryProvider).watchReports().map(groupReports),
);

/// The live post or reply a queue row is about; null if it no longer exists.
final reportedContentProvider =
    FutureProvider.family<
      ({ForumPost? post, ForumReply? reply}),
      ReportedTarget
    >((ref, target) async {
      final repo = ref.watch(forumRepositoryProvider);
      if (target.isReply) {
        return (
          post: null,
          reply: await repo.fetchReply(target.postId, target.replyId!),
        );
      }
      return (post: await repo.fetchPost(target.postId), reply: null);
    });

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
final deleteForumPostProvider = Provider(
  (ref) => DeleteForumPost(ref.watch(forumRepositoryProvider)),
);
final deleteForumReplyProvider = Provider(
  (ref) => DeleteForumReply(ref.watch(forumRepositoryProvider)),
);
final dismissReportsProvider = Provider(
  (ref) => DismissReports(ref.watch(forumRepositoryProvider)),
);
final removeReportedProvider = Provider(
  (ref) => RemoveReported(ref.watch(forumRepositoryProvider)),
);
