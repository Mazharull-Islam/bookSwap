import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/book_of_month_nomination.dart';
import '../../domain/entities/book_of_month_period.dart';
import '../../domain/entities/book_of_month_vote.dart';
import '../../domain/repositories/book_of_month_repository.dart';
import '../models/book_of_month_nomination_dto.dart';
import '../models/book_of_month_period_dto.dart';
import '../models/book_of_month_vote_dto.dart';
import '../../../../shared/domain/match_key.dart';

class FirestoreBookOfMonthRepository implements BookOfMonthRepository {
  FirestoreBookOfMonthRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _nominations =>
      _firestore.collection('book_of_month_nominations');
  CollectionReference<Map<String, dynamic>> get _votes =>
      _firestore.collection('book_of_month_votes');
  CollectionReference<Map<String, dynamic>> get _periods =>
      _firestore.collection('book_of_month_periods');

  @override
  Stream<List<BookOfMonthNomination>> watchNominations(String periodId) =>
      _nominations
          .where('periodId', isEqualTo: periodId)
          .snapshots()
          .map(
            (s) =>
                (s.docs
                    .map((d) => BookOfMonthNominationDto.parse(d.data()))
                    .toList()
                  ..sort((a, b) => a.nominatedAtMs.compareTo(b.nominatedAtMs))),
          );

  @override
  Stream<List<BookOfMonthVote>> watchVotes(String periodId) => _votes
      .where('periodId', isEqualTo: periodId)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => BookOfMonthVoteDto.parse(d.data())).toList(),
      );

  @override
  Stream<BookOfMonthPeriod?> watchPeriod(String periodId) => _periods
      .doc(periodId)
      .snapshots()
      .map(
        (d) => d.data() == null ? null : BookOfMonthPeriodDto.parse(d.data()!),
      );

  @override
  Stream<List<BookOfMonthPeriod>> watchKnownPeriods({int limit = 24}) =>
      _periods
          .orderBy(FieldPath.documentId, descending: true)
          .limit(limit)
          .snapshots()
          .map(
            (s) => s.docs
                .map((d) => BookOfMonthPeriodDto.parse(d.data()))
                .toList(),
          );

  @override
  Future<void> nominate({
    required String periodId,
    required String nominatedBy,
    required String nominatedByName,
    required String title,
    required String author,
    String? coverUrl,
    String? workKey,
    String? genre,
  }) async {
    final matchKey = workMatchKey(
      workKey: workKey,
      title: title,
      author: author,
    );
    // matchKey (often an Open Library workKey like "/works/OL12345W") can
    // contain '/', which breaks Firestore document IDs — so, unlike
    // wanted_books' matchKey, this can only ever be a field value, never
    // baked into a doc id. Dedup is a query instead of a doc().get().
    final existing = await _nominations
        .where('periodId', isEqualTo: periodId)
        .where('matchKey', isEqualTo: matchKey)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      // Already nominated this period — a no-op, not an error, so the UI
      // can just treat "nominate" as idempotent.
      return;
    }
    final nomDoc = _nominations.doc();
    final nomination = BookOfMonthNomination(
      id: nomDoc.id,
      periodId: periodId,
      matchKey: matchKey,
      title: title,
      author: author,
      coverUrl: coverUrl,
      workKey: workKey,
      genre: genre,
      nominatedBy: nominatedBy,
      nominatedByName: nominatedByName,
      nominatedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await nomDoc.set(nomination.toJson());

    final periodDoc = _periods.doc(periodId);
    if (!(await periodDoc.get()).exists) {
      await periodDoc.set(BookOfMonthPeriod(id: periodId).toJson());
    }
  }

  @override
  Future<void> vote({
    required String periodId,
    required String userId,
    required String matchKey,
  }) {
    final voteDoc = _votes.doc('${periodId}_$userId');
    final vote = BookOfMonthVote(
      id: voteDoc.id,
      periodId: periodId,
      userId: userId,
      matchKey: matchKey,
      votedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    return voteDoc.set(vote.toJson());
  }

  @override
  Future<void> setDiscussionThread(String periodId, String postId) =>
      _periods.doc(periodId).update({'discussionPostId': postId});
}
