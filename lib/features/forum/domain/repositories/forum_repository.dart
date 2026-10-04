import '../entities/forum_post.dart';
import '../entities/forum_reply.dart';
import '../entities/forum_report.dart';

class ForumValidationFailure implements Exception {
  const ForumValidationFailure(this.message);
  final String message;
}

abstract interface class ForumRepository {
  Stream<List<ForumPost>> watchPosts();
  Stream<ForumPost?> watchPost(String postId);
  Stream<List<ForumReply>> watchReplies(String postId);

  Future<ForumPost> createPost({
    required String authorId,
    required String authorName,
    required String title,
    required String body,
    String? genre,
  });

  Future<ForumReply> createReply({
    required String postId,
    required String authorId,
    required String authorName,
    required String body,
  });

  Future<void> setPostLiked(String postId, String userId, bool liked);
  Future<void> setReplyLiked(
    String postId,
    String replyId,
    String userId,
    bool liked,
  );

  /// Throws [ForumValidationFailure] if [userId] already reported it.
  Future<void> reportPost(
    String postId,
    String userId,
    ForumReportReason reason,
  );
  Future<void> reportReply(
    String postId,
    String replyId,
    String userId,
    ForumReportReason reason,
  );

  /// Author removing their own post or reply (moderators use the same calls).
  Future<void> deletePost(String postId);
  Future<void> deleteReply(String postId, String replyId);

  /// Whether [userId] is listed in `moderators`. Granted by hand in the
  /// Firebase console; the app can only read it.
  Stream<bool> watchIsModerator(String userId);
  Stream<List<ForumReport>> watchReports();
  Future<ForumPost?> fetchPost(String postId);
  Future<ForumReply?> fetchReply(String postId, String replyId);

  /// Clears the reports, which restores the item to the feed.
  Future<void> dismissReports(ReportedTarget target);

  /// Deletes the reported item and its reports.
  Future<void> removeReported(ReportedTarget target);
}
