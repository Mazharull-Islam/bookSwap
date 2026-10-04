import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/book_of_month_period.dart';

part 'book_of_month_period_dto.freezed.dart';
part 'book_of_month_period_dto.g.dart';

@freezed
abstract class BookOfMonthPeriodDto with _$BookOfMonthPeriodDto {
  const BookOfMonthPeriodDto._();

  const factory BookOfMonthPeriodDto({
    required String id,
    String? discussionPostId,
  }) = _BookOfMonthPeriodDto;

  factory BookOfMonthPeriodDto.fromJson(Map<String, dynamic> json) =>
      _$BookOfMonthPeriodDtoFromJson(json);

  factory BookOfMonthPeriodDto.fromEntity(BookOfMonthPeriod entity) =>
      BookOfMonthPeriodDto(
        id: entity.id,
        discussionPostId: entity.discussionPostId,
      );

  BookOfMonthPeriod toEntity() =>
      BookOfMonthPeriod(id: id, discussionPostId: discussionPostId);

  static BookOfMonthPeriod parse(Map<String, dynamic> json) =>
      BookOfMonthPeriodDto.fromJson(json).toEntity();
}

extension BookOfMonthPeriodJson on BookOfMonthPeriod {
  Map<String, dynamic> toJson() =>
      BookOfMonthPeriodDto.fromEntity(this).toJson();
}
