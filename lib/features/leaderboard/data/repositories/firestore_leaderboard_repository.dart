import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/reading_activity.dart';
import '../../domain/repositories/leaderboard_repository.dart';

/// Live, cross-user data like requests/wanted_books/blocks/forum/book_of_month
/// — bypasses Hive.
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
        (s) => s.docs.map((d) => ReadingActivity.fromJson(d.data())).toList(),
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
