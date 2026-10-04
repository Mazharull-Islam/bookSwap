import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/reading_goal.dart';

part 'reading_goal_dto.freezed.dart';
part 'reading_goal_dto.g.dart';

@freezed
abstract class ReadingGoalDto with _$ReadingGoalDto {
  const ReadingGoalDto._();

  const factory ReadingGoalDto({
    required String userId,
    required int targetCount,
    required int startedAtMs,
    required int periodDays,
    @Default(0) int updatedAtMs,
    int? deletedAtMs,
  }) = _ReadingGoalDto;

  factory ReadingGoalDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingGoalDtoFromJson(json);

  factory ReadingGoalDto.fromEntity(ReadingGoal entity) => ReadingGoalDto(
    userId: entity.userId,
    targetCount: entity.targetCount,
    startedAtMs: entity.startedAtMs,
    periodDays: entity.periodDays,
    updatedAtMs: entity.updatedAtMs,
    deletedAtMs: entity.deletedAtMs,
  );

  ReadingGoal toEntity() => ReadingGoal(
    userId: userId,
    targetCount: targetCount,
    startedAtMs: startedAtMs,
    periodDays: periodDays,
    updatedAtMs: updatedAtMs,
    deletedAtMs: deletedAtMs,
  );

  static ReadingGoal parse(Map<String, dynamic> json) =>
      ReadingGoalDto.fromJson(json).toEntity();
}

extension ReadingGoalJson on ReadingGoal {
  Map<String, dynamic> toJson() => ReadingGoalDto.fromEntity(this).toJson();
}
