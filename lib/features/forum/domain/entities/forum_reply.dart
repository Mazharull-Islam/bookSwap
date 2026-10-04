import 'forum_post.dart' show forumHideThreshold;
import 'package:collection/collection.dart';

const DeepCollectionEquality _eq = DeepCollectionEquality();

class ForumReply {
  const ForumReply({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.body,
    required this.createdAtMs,
    this.likedBy = const [],
    this.reportedBy = const [],
  });

  final String id;

  final String postId;

  final String authorId;

  final String authorName;

  final String body;

  final int createdAtMs;

  final List<String> likedBy;

  final List<String> reportedBy;

  ForumReply copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? authorName,
    String? body,
    int? createdAtMs,
    List<String>? likedBy,
    List<String>? reportedBy,
  }) => ForumReply(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    authorId: authorId ?? this.authorId,
    authorName: authorName ?? this.authorName,
    body: body ?? this.body,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    likedBy: likedBy ?? this.likedBy,
    reportedBy: reportedBy ?? this.reportedBy,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForumReply &&
          id == other.id &&
          postId == other.postId &&
          authorId == other.authorId &&
          authorName == other.authorName &&
          body == other.body &&
          createdAtMs == other.createdAtMs &&
          _eq.equals(likedBy, other.likedBy) &&
          _eq.equals(reportedBy, other.reportedBy);

  @override
  int get hashCode => Object.hashAll([
    ForumReply,
    id,
    postId,
    authorId,
    authorName,
    body,
    createdAtMs,
    _eq.hash(likedBy),
    _eq.hash(reportedBy),
  ]);

  @override
  String toString() => 'ForumReply(id: $id)';

  bool get isReported => reportedBy.isNotEmpty;

  bool get isHidden => reportedBy.length >= forumHideThreshold;
}
