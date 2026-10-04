class BookReview {
  const BookReview({
    required this.id,
    required this.requestId,
    required this.reviewerId,
    required this.reviewerName,
    required this.bookId,
    required this.bookTitle,
    required this.matchKey,
    required this.rating,
    this.text = '',
    required this.createdAtMs,
    required this.updatedAtMs,
  });

  /// The loan's request id — a borrower can review a returned loan once,
  /// and the rules verify against that request, so this doubles as the
  /// document id.
  final String id;

  final String requestId;

  final String reviewerId;

  final String reviewerName;

  final String bookId;

  final String bookTitle;

  /// Same shape as discovery's grouping key (work key, else title|author),
  /// so reviews follow the book across editions and owners.
  final String matchKey;

  /// 1-5.
  final int rating;

  final String text;

  final int createdAtMs;

  final int updatedAtMs;

  BookReview copyWith({
    String? id,
    String? requestId,
    String? reviewerId,
    String? reviewerName,
    String? bookId,
    String? bookTitle,
    String? matchKey,
    int? rating,
    String? text,
    int? createdAtMs,
    int? updatedAtMs,
  }) => BookReview(
    id: id ?? this.id,
    requestId: requestId ?? this.requestId,
    reviewerId: reviewerId ?? this.reviewerId,
    reviewerName: reviewerName ?? this.reviewerName,
    bookId: bookId ?? this.bookId,
    bookTitle: bookTitle ?? this.bookTitle,
    matchKey: matchKey ?? this.matchKey,
    rating: rating ?? this.rating,
    text: text ?? this.text,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookReview &&
          id == other.id &&
          requestId == other.requestId &&
          reviewerId == other.reviewerId &&
          reviewerName == other.reviewerName &&
          bookId == other.bookId &&
          bookTitle == other.bookTitle &&
          matchKey == other.matchKey &&
          rating == other.rating &&
          text == other.text &&
          createdAtMs == other.createdAtMs &&
          updatedAtMs == other.updatedAtMs;

  @override
  int get hashCode => Object.hashAll([
    BookReview,
    id,
    requestId,
    reviewerId,
    reviewerName,
    bookId,
    bookTitle,
    matchKey,
    rating,
    text,
    createdAtMs,
    updatedAtMs,
  ]);

  @override
  String toString() => 'BookReview(id: $id)';
}
