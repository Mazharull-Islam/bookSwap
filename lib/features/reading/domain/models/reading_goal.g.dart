// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingGoal _$ReadingGoalFromJson(Map<String, dynamic> json) => _ReadingGoal(
  userId: json['userId'] as String,
  targetCount: (json['targetCount'] as num).toInt(),
  startedAtMs: (json['startedAtMs'] as num).toInt(),
  periodDays: (json['periodDays'] as num).toInt(),
);

Map<String, dynamic> _$ReadingGoalToJson(_ReadingGoal instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'targetCount': instance.targetCount,
      'startedAtMs': instance.startedAtMs,
      'periodDays': instance.periodDays,
    };
