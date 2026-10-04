import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/book_review.dart';

part 'book_review_dto.freezed.dart';
part 'book_review_dto.g.dart';

@freezed
abstract class BookReviewDto with _$BookReviewDto {
  const BookReviewDto._();

  const factory BookReviewDto({
    required String id,
    required String requestId,
    required String reviewerId,
    required String reviewerName,
    required String bookId,
    required String bookTitle,
    required String matchKey,
    required int rating,
    @Default('') String text,
    required int createdAtMs,
    required int updatedAtMs,
  }) = _BookReviewDto;

  factory BookReviewDto.fromJson(Map<String, dynamic> json) =>
      _$BookReviewDtoFromJson(json);

  factory BookReviewDto.fromEntity(BookReview entity) => BookReviewDto(
    id: entity.id,
    requestId: entity.requestId,
    reviewerId: entity.reviewerId,
    reviewerName: entity.reviewerName,
    bookId: entity.bookId,
    bookTitle: entity.bookTitle,
    matchKey: entity.matchKey,
    rating: entity.rating,
    text: entity.text,
    createdAtMs: entity.createdAtMs,
    updatedAtMs: entity.updatedAtMs,
  );

  BookReview toEntity() => BookReview(
    id: id,
    requestId: requestId,
    reviewerId: reviewerId,
    reviewerName: reviewerName,
    bookId: bookId,
    bookTitle: bookTitle,
    matchKey: matchKey,
    rating: rating,
    text: text,
    createdAtMs: createdAtMs,
    updatedAtMs: updatedAtMs,
  );

  static BookReview parse(Map<String, dynamic> json) =>
      BookReviewDto.fromJson(json).toEntity();
}

extension BookReviewJson on BookReview {
  Map<String, dynamic> toJson() => BookReviewDto.fromEntity(this).toJson();
}
