import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_goal.freezed.dart';
part 'reading_goal.g.dart';

/// One active goal per user — setting a new one (or editing) replaces it
/// and restarts the tracking window from now, rather than keeping a history
/// of past goal periods.
@freezed
abstract class ReadingGoal with _$ReadingGoal {
  const factory ReadingGoal({
    required String userId,
    required int targetCount,
    required int startedAtMs,
    required int periodDays,

    /// Last change, for last-write-wins when syncing between devices.
    @Default(0) int updatedAtMs,

    /// Set when the goal is cleared (soft delete, same reasoning as
    /// ReadingEntry.deletedAtMs).
    int? deletedAtMs,
  }) = _ReadingGoal;

  factory ReadingGoal.fromJson(Map<String, dynamic> json) =>
      _$ReadingGoalFromJson(json);
}
