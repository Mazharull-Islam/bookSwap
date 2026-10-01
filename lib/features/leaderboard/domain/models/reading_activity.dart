import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_activity.freezed.dart';
part 'reading_activity.g.dart';

/// One "I marked a book Read" event, pushed live so the leaderboard can
/// aggregate across members. Deliberately minimal — no book title, rating,
/// or review — the leaderboard only ever needs a reader's name, the book's
/// author/genre, and which period it happened in.
@freezed
abstract class ReadingActivity with _$ReadingActivity {
  const factory ReadingActivity({
    required String id,
    required String userId,
    required String userName,
    @Default('') String author,
    String? genre,
    required String periodId,
    required int markedReadAtMs,
  }) = _ReadingActivity;

  factory ReadingActivity.fromJson(Map<String, dynamic> json) =>
      _$ReadingActivityFromJson(json);
}
