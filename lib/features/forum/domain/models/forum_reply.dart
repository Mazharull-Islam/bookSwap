import 'package:freezed_annotation/freezed_annotation.dart';

part 'forum_reply.freezed.dart';
part 'forum_reply.g.dart';

@freezed
abstract class ForumReply with _$ForumReply {
  const ForumReply._();

  const factory ForumReply({
    required String id,
    required String postId,
    required String authorId,
    required String authorName,
    required String body,
    required int createdAtMs,
    @Default([]) List<String> likedBy,
    @Default([]) List<String> reportedBy,
  }) = _ForumReply;

  factory ForumReply.fromJson(Map<String, dynamic> json) =>
      _$ForumReplyFromJson(json);

  bool get isReported => reportedBy.isNotEmpty;
}
