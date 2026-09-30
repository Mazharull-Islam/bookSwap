import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_service.dart';
import '../../domain/models/reading_goal.dart';
import '../../domain/repositories/reading_goal_repository.dart';

class HiveReadingGoalRepository implements ReadingGoalRepository {
  Box<Map> get _box => HiveService.readingGoalsBox;

  ReadingGoal? _decode(String userId) {
    final raw = _box.get(userId);
    return raw == null
        ? null
        : ReadingGoal.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Stream<ReadingGoal?> watchGoal(String userId) async* {
    yield _decode(userId);
    yield* _box.watch(key: userId).map((_) => _decode(userId));
  }

  @override
  Future<ReadingGoal> setGoal(ReadingGoal goal) async {
    await _box.put(goal.userId, goal.toJson());
    return goal;
  }

  @override
  Future<void> clearGoal(String userId) => _box.delete(userId);
}
