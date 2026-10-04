// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_of_month_nomination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookOfMonthNomination _$BookOfMonthNominationFromJson(
  Map<String, dynamic> json,
) => _BookOfMonthNomination(
  id: json['id'] as String,
  periodId: json['periodId'] as String,
  matchKey: json['matchKey'] as String,
  title: json['title'] as String,
  author: json['author'] as String? ?? '',
  coverUrl: json['coverUrl'] as String?,
  workKey: json['workKey'] as String?,
  genre: json['genre'] as String?,
  nominatedBy: json['nominatedBy'] as String,
  nominatedByName: json['nominatedByName'] as String,
  nominatedAtMs: (json['nominatedAtMs'] as num).toInt(),
);

Map<String, dynamic> _$BookOfMonthNominationToJson(
  _BookOfMonthNomination instance,
) => <String, dynamic>{
  'id': instance.id,
  'periodId': instance.periodId,
  'matchKey': instance.matchKey,
  'title': instance.title,
  'author': instance.author,
  'coverUrl': instance.coverUrl,
  'workKey': instance.workKey,
  'genre': instance.genre,
  'nominatedBy': instance.nominatedBy,
  'nominatedByName': instance.nominatedByName,
  'nominatedAtMs': instance.nominatedAtMs,
};
