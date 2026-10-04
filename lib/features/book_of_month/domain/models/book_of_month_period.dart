import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_of_month_period.freezed.dart';
part 'book_of_month_period.g.dart';

/// A lightweight index doc — one per period that has ever had a nomination
/// — so the archive can list past periods without Firestore's lack of a
/// "distinct" query. Also carries the period's single Forum discussion
/// thread, created lazily on the period's first nomination.
@freezed
abstract class BookOfMonthPeriod with _$BookOfMonthPeriod {
  const factory BookOfMonthPeriod({
    required String id,
    String? discussionPostId,
  }) = _BookOfMonthPeriod;

  factory BookOfMonthPeriod.fromJson(Map<String, dynamic> json) =>
      _$BookOfMonthPeriodFromJson(json);
}
