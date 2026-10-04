import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../application/use_cases/reading_goal_use_cases.dart';
import '../../data/repositories/hive_reading_goal_repository.dart';
import '../../domain/entities/reading_goal.dart';
import '../../domain/repositories/reading_goal_repository.dart';

final readingGoalRepositoryProvider = Provider<ReadingGoalRepository>(
  (ref) => HiveReadingGoalRepository(),
);

final myReadingGoalProvider = StreamProvider<ReadingGoal?>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  return ref.watch(readingGoalRepositoryProvider).watchGoal(myId);
});

final setReadingGoalProvider = Provider(
  (ref) => SetReadingGoal(ref.watch(readingGoalRepositoryProvider)),
);
final clearReadingGoalProvider = Provider(
  (ref) => ClearReadingGoal(ref.watch(readingGoalRepositoryProvider)),
);
