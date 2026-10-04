// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_reply_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForumReplyDto _$ForumReplyDtoFromJson(Map<String, dynamic> json) =>
    _ForumReplyDto(
      id: json['id'] as String,
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      body: json['body'] as String,
      createdAtMs: (json['createdAtMs'] as num).toInt(),
      likedBy:
          (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      reportedBy:
          (json['reportedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ForumReplyDtoToJson(_ForumReplyDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'body': instance.body,
      'createdAtMs': instance.createdAtMs,
      'likedBy': instance.likedBy,
      'reportedBy': instance.reportedBy,
    };
