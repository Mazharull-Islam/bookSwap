import '../../domain/entities/forum_post.dart';
import '../../domain/entities/forum_reply.dart';
import '../../domain/entities/forum_report.dart';
import '../../domain/repositories/forum_repository.dart';

class CreateForumPost {
  const CreateForumPost(this.repository);
  final ForumRepository repository;

  Future<ForumPost> call({
    required String authorId,
    required String authorName,
    required String title,
    required String body,
    String? genre,
  }) => repository.createPost(
    authorId: authorId,
    authorName: authorName,
    title: title,
    body: body,
    genre: genre,
  );
}

class CreateForumReply {
  const CreateForumReply(this.repository);
  final ForumRepository repository;

  Future<ForumReply> call({
    required String postId,
    required String authorId,
    required String authorName,
    required String body,
  }) => repository.createReply(
    postId: postId,
    authorId: authorId,
    authorName: authorName,
    body: body,
  );
}

class SetPostLiked {
  const SetPostLiked(this.repository);
  final ForumRepository repository;

  Future<void> call(String postId, String userId, bool liked) =>
      repository.setPostLiked(postId, userId, liked);
}

class SetReplyLiked {
  const SetReplyLiked(this.repository);
  final ForumRepository repository;

  Future<void> call(String postId, String replyId, String userId, bool liked) =>
      repository.setReplyLiked(postId, replyId, userId, liked);
}

class ReportForumPost {
  const ReportForumPost(this.repository);
  final ForumRepository repository;

  Future<void> call(String postId, String userId, ForumReportReason reason) =>
      repository.reportPost(postId, userId, reason);
}

class ReportForumReply {
  const ReportForumReply(this.repository);
  final ForumRepository repository;

  Future<void> call(
    String postId,
    String replyId,
    String userId,
    ForumReportReason reason,
  ) => repository.reportReply(postId, replyId, userId, reason);
}

class DeleteForumPost {
  const DeleteForumPost(this.repository);
  final ForumRepository repository;

  Future<void> call(String postId) => repository.deletePost(postId);
}

class DeleteForumReply {
  const DeleteForumReply(this.repository);
  final ForumRepository repository;

  Future<void> call(String postId, String replyId) =>
      repository.deleteReply(postId, replyId);
}

class DismissReports {
  const DismissReports(this.repository);
  final ForumRepository repository;

  Future<void> call(ReportedTarget target) => repository.dismissReports(target);
}

class RemoveReported {
  const RemoveReported(this.repository);
  final ForumRepository repository;

  Future<void> call(ReportedTarget target) => repository.removeReported(target);
}
