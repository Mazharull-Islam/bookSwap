import '../entities/reading_activity.dart';

abstract interface class LeaderboardRepository {
  Stream<List<ReadingActivity>> watchActivity(String periodId);

  Future<void> recordReadEvent({
    required String userId,
    required String userName,
    required String author,
    String? genre,
    required String periodId,
  });
}
