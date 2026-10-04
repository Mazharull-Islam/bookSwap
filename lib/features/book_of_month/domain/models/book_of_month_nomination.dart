import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_of_month_nomination.freezed.dart';
part 'book_of_month_nomination.g.dart';

@freezed
abstract class BookOfMonthNomination with _$BookOfMonthNomination {
  const factory BookOfMonthNomination({
    /// '${periodId}_${matchKey}' — deterministic so nominating the same
    /// book twice in the same period is a no-op (checked client-side)
    /// rather than a duplicate competing entry that splits votes.
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
  }) = _BookOfMonthNomination;

  factory BookOfMonthNomination.fromJson(Map<String, dynamic> json) =>
      _$BookOfMonthNominationFromJson(json);
}

/// Same shape as discovery's bookGroupKey / wanted_books' matchKey — its own
/// tiny copy rather than a cross-feature import, same precedent as
/// reading/wanted_books.
String bomMatchKey({
  required String? workKey,
  required String title,
  required String author,
}) {
  if (workKey != null && workKey.isNotEmpty) return workKey;
  return '${title.trim().toLowerCase()}|${author.trim().toLowerCase()}';
}
