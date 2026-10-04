import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/reading_activity.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../models/reading_activity_dto.dart';

/// Live, cross-user data, so it bypasses Hive.
class FirestoreLeaderboardRepository implements LeaderboardRepository {
  FirestoreLeaderboardRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _activity =>
      _firestore.collection('reading_activity');

  @override
  Stream<List<ReadingActivity>> watchActivity(String periodId) => _activity
      .where('periodId', isEqualTo: periodId)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => ReadingActivityDto.parse(d.data())).toList(),
      );

  @override
  Future<void> recordReadEvent({
    required String userId,
    required String userName,
    required String author,
    String? genre,
    required String periodId,
  }) {
    final doc = _activity.doc();
    final activity = ReadingActivity(
      id: doc.id,
      userId: userId,
      userName: userName,
      author: author,
      genre: genre,
      periodId: periodId,
      markedReadAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    return doc.set(activity.toJson());
  }
}
