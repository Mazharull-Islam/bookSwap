import '../../domain/repositories/leaderboard_repository.dart';

class RecordReadActivity {
  const RecordReadActivity(this.repository);
  final LeaderboardRepository repository;

  Future<void> call({
    required String userId,
    required String userName,
    required String author,
    String? genre,
    required String periodId,
  }) => repository.recordReadEvent(
    userId: userId,
    userName: userName,
    author: author,
    genre: genre,
    periodId: periodId,
  );
}
