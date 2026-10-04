import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/forum_post.dart';

part 'forum_post_dto.freezed.dart';
part 'forum_post_dto.g.dart';

@freezed
abstract class ForumPostDto with _$ForumPostDto {
  const ForumPostDto._();

  const factory ForumPostDto({
    required String id,
    required String authorId,
    required String authorName,
    required String title,
    required String body,
    String? genre,
    required int createdAtMs,
    @Default([]) List<String> likedBy,
    @Default([]) List<String> reportedBy,
    @Default(0) int replyCount,
  }) = _ForumPostDto;

  factory ForumPostDto.fromJson(Map<String, dynamic> json) =>
      _$ForumPostDtoFromJson(json);

  factory ForumPostDto.fromEntity(ForumPost entity) => ForumPostDto(
    id: entity.id,
    authorId: entity.authorId,
    authorName: entity.authorName,
    title: entity.title,
    body: entity.body,
    genre: entity.genre,
    createdAtMs: entity.createdAtMs,
    likedBy: entity.likedBy,
    reportedBy: entity.reportedBy,
    replyCount: entity.replyCount,
  );

  ForumPost toEntity() => ForumPost(
    id: id,
    authorId: authorId,
    authorName: authorName,
    title: title,
    body: body,
    genre: genre,
    createdAtMs: createdAtMs,
    likedBy: likedBy,
    reportedBy: reportedBy,
    replyCount: replyCount,
  );

  static ForumPost parse(Map<String, dynamic> json) =>
      ForumPostDto.fromJson(json).toEntity();
}

extension ForumPostJson on ForumPost {
  Map<String, dynamic> toJson() => ForumPostDto.fromEntity(this).toJson();
}
