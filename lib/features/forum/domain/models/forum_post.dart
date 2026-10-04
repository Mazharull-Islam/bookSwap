import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum_post.freezed.dart';
part 'forum_post.g.dart';

/// Distinct reporters needed to hide a post or reply from the feed. One
/// report alone would let a single member silence anyone.
const forumHideThreshold = 3;

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

    /// Distinct members who reported this. Members can only add themselves;
    /// a moderator dismissing the reports is the only way it shrinks.
    @Default([]) List<String> reportedBy,
    @Default(0) int replyCount,
  }) = _ForumPost;

  factory ForumPost.fromJson(Map<String, dynamic> json) =>
      _$ForumPostFromJson(json);

  bool get isReported => reportedBy.isNotEmpty;

  /// Pulled from the general feed once enough different members report it.
  bool get isHidden => reportedBy.length >= forumHideThreshold;
}
