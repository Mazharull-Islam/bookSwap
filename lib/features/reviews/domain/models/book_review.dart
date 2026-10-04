import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_review.freezed.dart';
part 'book_review.g.dart';

@freezed
abstract class BookReview with _$BookReview {
  const factory BookReview({
    /// The loan's request id — a borrower can review a returned loan once,
    /// and the rules verify against that request, so this doubles as the
    /// document id.
    required String id,
    required String requestId,
    required String reviewerId,
    required String reviewerName,
    required String bookId,
    required String bookTitle,

    /// Same shape as discovery's grouping key (work key, else title|author),
    /// so reviews follow the book across editions and owners.
    required String matchKey,

    /// 1-5.
    required int rating,
    @Default('') String text,
    required int createdAtMs,
    required int updatedAtMs,
  }) = _BookReview;

  factory BookReview.fromJson(Map<String, dynamic> json) =>
      _$BookReviewFromJson(json);
}

/// Mirrors discovery's bookGroupKey — its own tiny copy rather than a
/// cross-feature import, same precedent as wanted_books/reading.
String reviewMatchKey({
  required String? workKey,
  required String title,
  required String author,
}) {
  if (workKey != null && workKey.isNotEmpty) return workKey;
  return '${title.trim().toLowerCase()}|${author.trim().toLowerCase()}';
}
