// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookReview _$BookReviewFromJson(Map<String, dynamic> json) => _BookReview(
  id: json['id'] as String,
  requestId: json['requestId'] as String,
  reviewerId: json['reviewerId'] as String,
  reviewerName: json['reviewerName'] as String,
  bookId: json['bookId'] as String,
  bookTitle: json['bookTitle'] as String,
  matchKey: json['matchKey'] as String,
  rating: (json['rating'] as num).toInt(),
  text: json['text'] as String? ?? '',
  createdAtMs: (json['createdAtMs'] as num).toInt(),
  updatedAtMs: (json['updatedAtMs'] as num).toInt(),
);

Map<String, dynamic> _$BookReviewToJson(_BookReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'reviewerId': instance.reviewerId,
      'reviewerName': instance.reviewerName,
      'bookId': instance.bookId,
      'bookTitle': instance.bookTitle,
      'matchKey': instance.matchKey,
      'rating': instance.rating,
      'text': instance.text,
      'createdAtMs': instance.createdAtMs,
      'updatedAtMs': instance.updatedAtMs,
    };
