import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/reading_entry.dart';

part 'reading_entry_dto.freezed.dart';
part 'reading_entry_dto.g.dart';

@freezed
abstract class ReadingEntryDto with _$ReadingEntryDto {
  const ReadingEntryDto._();

  const factory ReadingEntryDto({
    required String id,
    required String userId,
    required String title,
    @Default('') String author,
    @Default('') String genre,
    String? publishedYear,
    @Default('') String description,
    String? coverUrl,
    String? workKey,
    @Default(ReadingStatus.planToRead) ReadingStatus status,
    int? rating,
    @Default('') String review,
    required int updatedAtMs,
    int? deletedAtMs,
  }) = _ReadingEntryDto;

  factory ReadingEntryDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingEntryDtoFromJson(json);

  factory ReadingEntryDto.fromEntity(ReadingEntry entity) => ReadingEntryDto(
    id: entity.id,
    userId: entity.userId,
    title: entity.title,
    author: entity.author,
    genre: entity.genre,
    publishedYear: entity.publishedYear,
    description: entity.description,
    coverUrl: entity.coverUrl,
    workKey: entity.workKey,
    status: entity.status,
    rating: entity.rating,
    review: entity.review,
    updatedAtMs: entity.updatedAtMs,
    deletedAtMs: entity.deletedAtMs,
  );

  ReadingEntry toEntity() => ReadingEntry(
    id: id,
    userId: userId,
    title: title,
    author: author,
    genre: genre,
    publishedYear: publishedYear,
    description: description,
    coverUrl: coverUrl,
    workKey: workKey,
    status: status,
    rating: rating,
    review: review,
    updatedAtMs: updatedAtMs,
    deletedAtMs: deletedAtMs,
  );

  static ReadingEntry parse(Map<String, dynamic> json) =>
      ReadingEntryDto.fromJson(json).toEntity();
}

extension ReadingEntryJson on ReadingEntry {
  Map<String, dynamic> toJson() => ReadingEntryDto.fromEntity(this).toJson();
}
