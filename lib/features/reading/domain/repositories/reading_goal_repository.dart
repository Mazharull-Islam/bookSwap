import '../models/reading_goal.dart';

abstract interface class ReadingGoalRepository {
  Stream<ReadingGoal?> watchGoal(String userId);
  Future<ReadingGoal> setGoal(ReadingGoal goal);
  Future<void> clearGoal(String userId);
}
