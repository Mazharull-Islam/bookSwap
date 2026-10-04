// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_of_month_vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookOfMonthVote _$BookOfMonthVoteFromJson(Map<String, dynamic> json) =>
    _BookOfMonthVote(
      id: json['id'] as String,
      periodId: json['periodId'] as String,
      userId: json['userId'] as String,
      matchKey: json['matchKey'] as String,
      votedAtMs: (json['votedAtMs'] as num).toInt(),
    );

Map<String, dynamic> _$BookOfMonthVoteToJson(_BookOfMonthVote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'periodId': instance.periodId,
      'userId': instance.userId,
      'matchKey': instance.matchKey,
      'votedAtMs': instance.votedAtMs,
    };
