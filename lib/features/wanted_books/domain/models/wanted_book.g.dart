// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wanted_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WantedBook _$WantedBookFromJson(Map<String, dynamic> json) => _WantedBook(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  author: json['author'] as String? ?? '',
  coverUrl: json['coverUrl'] as String?,
  workKey: json['workKey'] as String?,
  matchKey: json['matchKey'] as String,
  addedAtMs: (json['addedAtMs'] as num).toInt(),
);

Map<String, dynamic> _$WantedBookToJson(_WantedBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'author': instance.author,
      'coverUrl': instance.coverUrl,
      'workKey': instance.workKey,
      'matchKey': instance.matchKey,
      'addedAtMs': instance.addedAtMs,
    };
