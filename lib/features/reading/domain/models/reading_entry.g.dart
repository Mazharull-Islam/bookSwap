// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingEntry _$ReadingEntryFromJson(Map<String, dynamic> json) =>
    _ReadingEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      author: json['author'] as String? ?? '',
      coverUrl: json['coverUrl'] as String?,
      workKey: json['workKey'] as String?,
      status:
          $enumDecodeNullable(_$ReadingStatusEnumMap, json['status']) ??
          ReadingStatus.planToRead,
      rating: (json['rating'] as num?)?.toInt(),
      review: json['review'] as String? ?? '',
      updatedAtMs: (json['updatedAtMs'] as num).toInt(),
    );

Map<String, dynamic> _$ReadingEntryToJson(_ReadingEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'author': instance.author,
      'coverUrl': instance.coverUrl,
      'workKey': instance.workKey,
      'status': _$ReadingStatusEnumMap[instance.status]!,
      'rating': instance.rating,
      'review': instance.review,
      'updatedAtMs': instance.updatedAtMs,
    };

const _$ReadingStatusEnumMap = {
  ReadingStatus.planToRead: 'planToRead',
  ReadingStatus.reading: 'reading',
  ReadingStatus.read: 'read',
};
