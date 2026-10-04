// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_of_month_vote_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookOfMonthVoteDto _$BookOfMonthVoteDtoFromJson(Map<String, dynamic> json) =>
    _BookOfMonthVoteDto(
      id: json['id'] as String,
      periodId: json['periodId'] as String,
      userId: json['userId'] as String,
      matchKey: json['matchKey'] as String,
      votedAtMs: (json['votedAtMs'] as num).toInt(),
    );

Map<String, dynamic> _$BookOfMonthVoteDtoToJson(_BookOfMonthVoteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'periodId': instance.periodId,
      'userId': instance.userId,
      'matchKey': instance.matchKey,
      'votedAtMs': instance.votedAtMs,
    };
