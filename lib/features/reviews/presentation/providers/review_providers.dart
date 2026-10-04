import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../application/use_cases/review_use_cases.dart';
import '../../data/repositories/firestore_review_repository.dart';
import '../../domain/entities/book_review.dart';
import '../../domain/rating_summary.dart';
import '../../domain/repositories/review_repository.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>(
  (ref) => FirestoreReviewRepository(FirebaseFirestore.instance),
);

final allReviewsProvider = StreamProvider<List<BookReview>>(
  (ref) => ref.watch(reviewRepositoryProvider).watchAll(),
);

/// Average rating and count per book, keyed like Discover's grouping.
final ratingSummariesProvider = Provider<Map<String, RatingSummary>>(
  (ref) =>
      summarizeRatings(ref.watch(allReviewsProvider).valueOrNull ?? const []),
);

final reviewsForBookProvider = Provider.family<List<BookReview>, String>(
  (ref, matchKey) => reviewsForBook(
    ref.watch(allReviewsProvider).valueOrNull ?? const [],
    matchKey,
  ),
);

/// The signed-in member's own review of a loan, if they've written one.
final myReviewProvider = Provider.family<BookReview?, String>((ref, requestId) {
  final me = ref.watch(currentUserProvider).id;
  final all = ref.watch(allReviewsProvider).valueOrNull ?? const [];
  for (final review in all) {
    if (review.id == requestId && review.reviewerId == me) return review;
  }
  return null;
});

final submitReviewProvider = Provider(
  (ref) => SubmitReview(ref.watch(reviewRepositoryProvider)),
);
final deleteReviewProvider = Provider(
  (ref) => DeleteReview(ref.watch(reviewRepositoryProvider)),
);
