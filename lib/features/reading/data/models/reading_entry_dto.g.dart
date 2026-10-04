// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingEntryDto _$ReadingEntryDtoFromJson(Map<String, dynamic> json) =>
    _ReadingEntryDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      author: json['author'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      publishedYear: json['publishedYear'] as String?,
      description: json['description'] as String? ?? '',
      coverUrl: json['coverUrl'] as String?,
      workKey: json['workKey'] as String?,
      status:
          $enumDecodeNullable(_$ReadingStatusEnumMap, json['status']) ??
          ReadingStatus.planToRead,
      rating: (json['rating'] as num?)?.toInt(),
      review: json['review'] as String? ?? '',
      updatedAtMs: (json['updatedAtMs'] as num).toInt(),
      deletedAtMs: (json['deletedAtMs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReadingEntryDtoToJson(_ReadingEntryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'author': instance.author,
      'genre': instance.genre,
      'publishedYear': instance.publishedYear,
      'description': instance.description,
      'coverUrl': instance.coverUrl,
      'workKey': instance.workKey,
      'status': _$ReadingStatusEnumMap[instance.status]!,
      'rating': instance.rating,
      'review': instance.review,
      'updatedAtMs': instance.updatedAtMs,
      'deletedAtMs': instance.deletedAtMs,
    };

const _$ReadingStatusEnumMap = {
  ReadingStatus.planToRead: 'planToRead',
  ReadingStatus.reading: 'reading',
  ReadingStatus.read: 'read',
};
