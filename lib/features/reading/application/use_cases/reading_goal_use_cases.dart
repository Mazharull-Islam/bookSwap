import '../../domain/entities/reading_goal.dart';
import '../../domain/repositories/reading_goal_repository.dart';

class SetReadingGoal {
  const SetReadingGoal(this.repository);
  final ReadingGoalRepository repository;

  Future<ReadingGoal> call(ReadingGoal goal) => repository.setGoal(goal);
}

class ClearReadingGoal {
  const ClearReadingGoal(this.repository);
  final ReadingGoalRepository repository;

  Future<void> call(String userId) => repository.clearGoal(userId);
}
