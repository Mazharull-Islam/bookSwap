// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForumPost _$ForumPostFromJson(Map<String, dynamic> json) => _ForumPost(
  id: json['id'] as String,
  authorId: json['authorId'] as String,
  authorName: json['authorName'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  genre: json['genre'] as String?,
  createdAtMs: (json['createdAtMs'] as num).toInt(),
  likedBy:
      (json['likedBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  reportedBy:
      (json['reportedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ForumPostToJson(_ForumPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'title': instance.title,
      'body': instance.body,
      'genre': instance.genre,
      'createdAtMs': instance.createdAtMs,
      'likedBy': instance.likedBy,
      'reportedBy': instance.reportedBy,
      'replyCount': instance.replyCount,
    };
