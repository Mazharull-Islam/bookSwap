import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_of_month_vote.freezed.dart';
part 'book_of_month_vote.g.dart';

@freezed
abstract class BookOfMonthVote with _$BookOfMonthVote {
  const factory BookOfMonthVote({
    /// '${periodId}_${userId}' — one vote per user per period. Voting for
    /// a different nominee overwrites this same doc, so a user can never
    /// hold more than one active vote in a period.
    required String id,
    required String periodId,
    required String userId,
    required String matchKey,
    required int votedAtMs,
  }) = _BookOfMonthVote;

  factory BookOfMonthVote.fromJson(Map<String, dynamic> json) =>
      _$BookOfMonthVoteFromJson(json);
}
