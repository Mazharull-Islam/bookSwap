import '../../domain/models/book_review.dart';
import '../../domain/repositories/review_repository.dart';

const maxReviewLength = 500;

class SubmitReview {
  const SubmitReview(this._repository);
  final ReviewRepository _repository;

  /// [existing] is the member's earlier review of the same loan, if any —
  /// editing keeps its creation time.
  Future<BookReview> call({
    BookReview? existing,
    required String requestId,
    required String reviewerId,
    required String reviewerName,
    required String bookId,
    required String bookTitle,
    required String matchKey,
    required int rating,
    required String text,
    DateTime? now,
  }) async {
    if (rating < 1 || rating > 5) {
      throw const ReviewValidationFailure('Choose a rating from 1 to 5 stars.');
    }
    final trimmed = text.trim();
    if (trimmed.length > maxReviewLength) {
      throw const ReviewValidationFailure(
        'Keep your review to $maxReviewLength characters or fewer.',
      );
    }
    final nowMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final review = BookReview(
      id: requestId,
      requestId: requestId,
      reviewerId: reviewerId,
      reviewerName: reviewerName,
      bookId: bookId,
      bookTitle: bookTitle,
      matchKey: existing?.matchKey ?? matchKey,
      rating: rating,
      text: trimmed,
      createdAtMs: existing?.createdAtMs ?? nowMs,
      updatedAtMs: nowMs,
    );
    await _repository.save(review);
    return review;
  }
}

class DeleteReview {
  const DeleteReview(this._repository);
  final ReviewRepository _repository;

  Future<void> call(String reviewId) => _repository.delete(reviewId);
}
