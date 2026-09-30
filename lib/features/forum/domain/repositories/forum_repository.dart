import '../models/forum_post.dart';
import '../models/forum_reply.dart';

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

  Future<void> reportPost(String postId, String userId);
  Future<void> reportReply(String postId, String replyId, String userId);
}
