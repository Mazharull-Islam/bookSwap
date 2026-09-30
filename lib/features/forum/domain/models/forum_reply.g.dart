// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForumReply _$ForumReplyFromJson(Map<String, dynamic> json) => _ForumReply(
  id: json['id'] as String,
  postId: json['postId'] as String,
  authorId: json['authorId'] as String,
  authorName: json['authorName'] as String,
  body: json['body'] as String,
  createdAtMs: (json['createdAtMs'] as num).toInt(),
  likedBy:
      (json['likedBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  reportedBy:
      (json['reportedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$ForumReplyToJson(_ForumReply instance) =>
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
