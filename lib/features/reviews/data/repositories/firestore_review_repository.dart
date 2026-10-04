import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/book_review.dart';
import '../../domain/repositories/review_repository.dart';

class FirestoreReviewRepository implements ReviewRepository {
  FirestoreReviewRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _reviews =>
      _firestore.collection('book_reviews');

  @override
  Stream<List<BookReview>> watchAll() => _reviews.snapshots().map(
    (s) => s.docs.map((d) => BookReview.fromJson(d.data())).toList(),
  );

  @override
  Future<void> save(BookReview review) =>
      _reviews.doc(review.id).set(review.toJson());

  @override
  Future<void> delete(String reviewId) => _reviews.doc(reviewId).delete();
}
