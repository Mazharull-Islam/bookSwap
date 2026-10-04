// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_activity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingActivityDto _$ReadingActivityDtoFromJson(Map<String, dynamic> json) =>
    _ReadingActivityDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      author: json['author'] as String? ?? '',
      genre: json['genre'] as String?,
      periodId: json['periodId'] as String,
      markedReadAtMs: (json['markedReadAtMs'] as num).toInt(),
    );

Map<String, dynamic> _$ReadingActivityDtoToJson(_ReadingActivityDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'author': instance.author,
      'genre': instance.genre,
      'periodId': instance.periodId,
      'markedReadAtMs': instance.markedReadAtMs,
    };
