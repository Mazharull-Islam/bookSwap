// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_goal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingGoalDto _$ReadingGoalDtoFromJson(Map<String, dynamic> json) =>
    _ReadingGoalDto(
      userId: json['userId'] as String,
      targetCount: (json['targetCount'] as num).toInt(),
      startedAtMs: (json['startedAtMs'] as num).toInt(),
      periodDays: (json['periodDays'] as num).toInt(),
      updatedAtMs: (json['updatedAtMs'] as num?)?.toInt() ?? 0,
      deletedAtMs: (json['deletedAtMs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReadingGoalDtoToJson(_ReadingGoalDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'targetCount': instance.targetCount,
      'startedAtMs': instance.startedAtMs,
      'periodDays': instance.periodDays,
      'updatedAtMs': instance.updatedAtMs,
      'deletedAtMs': instance.deletedAtMs,
    };
