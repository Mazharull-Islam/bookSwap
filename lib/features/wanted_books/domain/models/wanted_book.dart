import 'package:freezed_annotation/freezed_annotation.dart';

part 'wanted_book.freezed.dart';
part 'wanted_book.g.dart';

@freezed
abstract class WantedBook with _$WantedBook {
  const factory WantedBook({
    required String id,
    required String userId,
    required String title,
    @Default('') String author,
    String? coverUrl,
    String? workKey,
    /// Same format as discovery's `bookGroupKey` (workKey, or a normalized
    /// title|author fallback) — stored so it can be queried directly instead
    /// of recomputed, e.g. for the duplicate-entry check on add.
    required String matchKey,
    required int addedAtMs,
  }) = _WantedBook;

  factory WantedBook.fromJson(Map<String, dynamic> json) =>
      _$WantedBookFromJson(json);
}

/// Mirrors discovery's `bookGroupKey(Book)` so a wanted title and a shelf
/// listing resolve to the same key when they're the same underlying work.
String wantedBookMatchKey({
  required String? workKey,
  required String title,
  required String author,
}) {
  if (workKey != null && workKey.isNotEmpty) return workKey;
  return '${title.trim().toLowerCase()}|${author.trim().toLowerCase()}';
}
