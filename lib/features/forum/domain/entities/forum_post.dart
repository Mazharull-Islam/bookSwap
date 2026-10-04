import 'package:collection/collection.dart';

/// Marks "argument not passed" in [copyWith], so null can be passed on purpose.
const Object _keep = Object();

const DeepCollectionEquality _eq = DeepCollectionEquality();

/// Distinct reporters needed to hide a post or reply from the feed. One
/// report alone would let a single member silence anyone.
const forumHideThreshold = 3;

class ForumPost {
  const ForumPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.body,
    this.genre,
    required this.createdAtMs,
    this.likedBy = const [],
    this.reportedBy = const [],
    this.replyCount = 0,
  });

  final String id;

  final String authorId;

  final String authorName;

  final String title;

  final String body;

  final String? genre;

  final int createdAtMs;

  final List<String> likedBy;

  /// Distinct members who reported this. Members can only add themselves;
  /// a moderator dismissing the reports is the only way it shrinks.
  final List<String> reportedBy;

  final int replyCount;

  ForumPost copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? title,
    String? body,
    Object? genre = _keep,
    int? createdAtMs,
    List<String>? likedBy,
    List<String>? reportedBy,
    int? replyCount,
  }) => ForumPost(
    id: id ?? this.id,
    authorId: authorId ?? this.authorId,
    authorName: authorName ?? this.authorName,
    title: title ?? this.title,
    body: body ?? this.body,
    genre: identical(genre, _keep) ? this.genre : genre as String?,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    likedBy: likedBy ?? this.likedBy,
    reportedBy: reportedBy ?? this.reportedBy,
    replyCount: replyCount ?? this.replyCount,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForumPost &&
          id == other.id &&
          authorId == other.authorId &&
          authorName == other.authorName &&
          title == other.title &&
          body == other.body &&
          genre == other.genre &&
          createdAtMs == other.createdAtMs &&
          _eq.equals(likedBy, other.likedBy) &&
          _eq.equals(reportedBy, other.reportedBy) &&
          replyCount == other.replyCount;

  @override
  int get hashCode => Object.hashAll([
    ForumPost,
    id,
    authorId,
    authorName,
    title,
    body,
    genre,
    createdAtMs,
    _eq.hash(likedBy),
    _eq.hash(reportedBy),
    replyCount,
  ]);

  @override
  String toString() => 'ForumPost(id: $id)';

  bool get isReported => reportedBy.isNotEmpty;

  /// Pulled from the general feed once enough different members report it.
  bool get isHidden => reportedBy.length >= forumHideThreshold;
}
