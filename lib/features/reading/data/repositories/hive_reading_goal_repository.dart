import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_service.dart';
import '../../domain/entities/reading_goal.dart';
import '../../domain/repositories/reading_goal_repository.dart';
import '../models/reading_goal_dto.dart';

class HiveReadingGoalRepository implements ReadingGoalRepository {
  Box<Map> get _box => HiveService.readingGoalsBox;

  ReadingGoal? _decode(String userId) {
    final raw = _box.get(userId);
    if (raw == null) return null;
    final goal = ReadingGoalDto.parse(Map<String, dynamic>.from(raw));
    return goal.deletedAtMs == null ? goal : null;
  }

  @override
  Stream<ReadingGoal?> watchGoal(String userId) async* {
    yield _decode(userId);
    yield* _box.watch(key: userId).map((_) => _decode(userId));
  }

  @override
  Future<ReadingGoal> setGoal(ReadingGoal goal) async {
    final saved = goal.copyWith(
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
      deletedAtMs: null,
    );
    await _box.put(goal.userId, saved.toJson());
    return saved;
  }

  /// A soft delete, so clearing the goal syncs to other devices.
  @override
  Future<void> clearGoal(String userId) async {
    final raw = _box.get(userId);
    if (raw == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final goal = ReadingGoalDto.parse(Map<String, dynamic>.from(raw));
    await _box.put(
      userId,
      goal.copyWith(deletedAtMs: now, updatedAtMs: now).toJson(),
    );
  }
}
