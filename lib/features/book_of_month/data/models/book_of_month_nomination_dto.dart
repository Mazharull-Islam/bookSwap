import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/book_of_month_nomination.dart';

part 'book_of_month_nomination_dto.freezed.dart';
part 'book_of_month_nomination_dto.g.dart';

@freezed
abstract class BookOfMonthNominationDto with _$BookOfMonthNominationDto {
  const BookOfMonthNominationDto._();

  const factory BookOfMonthNominationDto({
    required String id,
    required String periodId,
    required String matchKey,
    required String title,
    @Default('') String author,
    String? coverUrl,
    String? workKey,
    String? genre,
    required String nominatedBy,
    required String nominatedByName,
    required int nominatedAtMs,
  }) = _BookOfMonthNominationDto;

  factory BookOfMonthNominationDto.fromJson(Map<String, dynamic> json) =>
      _$BookOfMonthNominationDtoFromJson(json);

  factory BookOfMonthNominationDto.fromEntity(BookOfMonthNomination entity) =>
      BookOfMonthNominationDto(
        id: entity.id,
        periodId: entity.periodId,
        matchKey: entity.matchKey,
        title: entity.title,
        author: entity.author,
        coverUrl: entity.coverUrl,
        workKey: entity.workKey,
        genre: entity.genre,
        nominatedBy: entity.nominatedBy,
        nominatedByName: entity.nominatedByName,
        nominatedAtMs: entity.nominatedAtMs,
      );

  BookOfMonthNomination toEntity() => BookOfMonthNomination(
    id: id,
    periodId: periodId,
    matchKey: matchKey,
    title: title,
    author: author,
    coverUrl: coverUrl,
    workKey: workKey,
    genre: genre,
    nominatedBy: nominatedBy,
    nominatedByName: nominatedByName,
    nominatedAtMs: nominatedAtMs,
  );

  static BookOfMonthNomination parse(Map<String, dynamic> json) =>
      BookOfMonthNominationDto.fromJson(json).toEntity();
}

extension BookOfMonthNominationJson on BookOfMonthNomination {
  Map<String, dynamic> toJson() =>
      BookOfMonthNominationDto.fromEntity(this).toJson();
}
