import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_entry.freezed.dart';
part 'reading_entry.g.dart';

enum ReadingStatus { planToRead, reading, read }

@freezed
abstract class ReadingEntry with _$ReadingEntry {
  const factory ReadingEntry({
    required String id,
    required String userId,
    required String title,
    @Default('') String author,
    String? coverUrl,
    String? workKey,
    @Default(ReadingStatus.planToRead) ReadingStatus status,
    /// 1-5. Only meaningful once [status] is [ReadingStatus.read] — the UI
    /// clears it if the status is changed away from Read.
    int? rating,
    @Default('') String review,
    required int updatedAtMs,
  }) = _ReadingEntry;

  factory ReadingEntry.fromJson(Map<String, dynamic> json) =>
      _$ReadingEntryFromJson(json);
}

/// Same shape as discovery's `bookGroupKey` / wanted_books' matchKey — kept
/// as its own tiny copy rather than a cross-feature import, since reading
/// entries and wishlist entries are unrelated concepts that just happen to
/// use the same dedup strategy.
String readingMatchKey({
  required String? workKey,
  required String title,
  required String author,
}) {
  if (workKey != null && workKey.isNotEmpty) return workKey;
  return '${title.trim().toLowerCase()}|${author.trim().toLowerCase()}';
}
