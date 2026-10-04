import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/forum_reply.dart';

part 'forum_reply_dto.freezed.dart';
part 'forum_reply_dto.g.dart';

@freezed
abstract class ForumReplyDto with _$ForumReplyDto {
  const ForumReplyDto._();

  const factory ForumReplyDto({
    required String id,
    required String postId,
    required String authorId,
    required String authorName,
    required String body,
    required int createdAtMs,
    @Default([]) List<String> likedBy,
    @Default([]) List<String> reportedBy,
  }) = _ForumReplyDto;

  factory ForumReplyDto.fromJson(Map<String, dynamic> json) =>
      _$ForumReplyDtoFromJson(json);

  factory ForumReplyDto.fromEntity(ForumReply entity) => ForumReplyDto(
    id: entity.id,
    postId: entity.postId,
    authorId: entity.authorId,
    authorName: entity.authorName,
    body: entity.body,
    createdAtMs: entity.createdAtMs,
    likedBy: entity.likedBy,
    reportedBy: entity.reportedBy,
  );

  ForumReply toEntity() => ForumReply(
    id: id,
    postId: postId,
    authorId: authorId,
    authorName: authorName,
    body: body,
    createdAtMs: createdAtMs,
    likedBy: likedBy,
    reportedBy: reportedBy,
  );

  static ForumReply parse(Map<String, dynamic> json) =>
      ForumReplyDto.fromJson(json).toEntity();
}

extension ForumReplyJson on ForumReply {
  Map<String, dynamic> toJson() => ForumReplyDto.fromEntity(this).toJson();
}
