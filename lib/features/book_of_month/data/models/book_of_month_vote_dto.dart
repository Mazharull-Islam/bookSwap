import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/book_of_month_vote.dart';

part 'book_of_month_vote_dto.freezed.dart';
part 'book_of_month_vote_dto.g.dart';

@freezed
abstract class BookOfMonthVoteDto with _$BookOfMonthVoteDto {
  const BookOfMonthVoteDto._();

  const factory BookOfMonthVoteDto({
    required String id,
    required String periodId,
    required String userId,
    required String matchKey,
    required int votedAtMs,
  }) = _BookOfMonthVoteDto;

  factory BookOfMonthVoteDto.fromJson(Map<String, dynamic> json) =>
      _$BookOfMonthVoteDtoFromJson(json);

  factory BookOfMonthVoteDto.fromEntity(BookOfMonthVote entity) =>
      BookOfMonthVoteDto(
        id: entity.id,
        periodId: entity.periodId,
        userId: entity.userId,
        matchKey: entity.matchKey,
        votedAtMs: entity.votedAtMs,
      );

  BookOfMonthVote toEntity() => BookOfMonthVote(
    id: id,
    periodId: periodId,
    userId: userId,
    matchKey: matchKey,
    votedAtMs: votedAtMs,
  );

  static BookOfMonthVote parse(Map<String, dynamic> json) =>
      BookOfMonthVoteDto.fromJson(json).toEntity();
}

extension BookOfMonthVoteJson on BookOfMonthVote {
  Map<String, dynamic> toJson() => BookOfMonthVoteDto.fromEntity(this).toJson();
}
