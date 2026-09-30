import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum_post.freezed.dart';
part 'forum_post.g.dart';

@freezed
abstract class ForumPost with _$ForumPost {
  const ForumPost._();

  const factory ForumPost({
    required String id,
    required String authorId,
    required String authorName,
    required String title,
    required String body,
    String? genre,
    required int createdAtMs,
    @Default([]) List<String> likedBy,

    /// Add-only — no "un-report." Non-empty means hidden from the general
    /// feed (SRS §3.7's moderation-latency requirement), with no reviewer
    /// role/UI to restore it — a deliberate, flagged gap for this pass.
    @Default([]) List<String> reportedBy,
    @Default(0) int replyCount,
  }) = _ForumPost;

  factory ForumPost.fromJson(Map<String, dynamic> json) =>
      _$ForumPostFromJson(json);

  bool get isReported => reportedBy.isNotEmpty;
}
