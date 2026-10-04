import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/reading_activity.dart';

part 'reading_activity_dto.freezed.dart';
part 'reading_activity_dto.g.dart';

@freezed
abstract class ReadingActivityDto with _$ReadingActivityDto {
  const ReadingActivityDto._();

  const factory ReadingActivityDto({
    required String id,
    required String userId,
    required String userName,
    @Default('') String author,
    String? genre,
    required String periodId,
    required int markedReadAtMs,
  }) = _ReadingActivityDto;

  factory ReadingActivityDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingActivityDtoFromJson(json);

  factory ReadingActivityDto.fromEntity(ReadingActivity entity) =>
      ReadingActivityDto(
        id: entity.id,
        userId: entity.userId,
        userName: entity.userName,
        author: entity.author,
        genre: entity.genre,
        periodId: entity.periodId,
        markedReadAtMs: entity.markedReadAtMs,
      );

  ReadingActivity toEntity() => ReadingActivity(
    id: id,
    userId: userId,
    userName: userName,
    author: author,
    genre: genre,
    periodId: periodId,
    markedReadAtMs: markedReadAtMs,
  );

  static ReadingActivity parse(Map<String, dynamic> json) =>
      ReadingActivityDto.fromJson(json).toEntity();
}

extension ReadingActivityJson on ReadingActivity {
  Map<String, dynamic> toJson() => ReadingActivityDto.fromEntity(this).toJson();
}
