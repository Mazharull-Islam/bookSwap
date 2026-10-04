import '../entities/book_review.dart';

class ReviewValidationFailure implements Exception {
  const ReviewValidationFailure(this.message);
  final String message;
}

abstract interface class ReviewRepository {
  /// Every review — Discover needs a rating per listed book, and the
  /// collection is small enough to listen to whole at this scale.
  Stream<List<BookReview>> watchAll();

  /// Creates the review, or edits it if the loan already has one.
  Future<void> save(BookReview review);

  Future<void> delete(String reviewId);
}
