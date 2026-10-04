import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/wanted_book.dart';

part 'wanted_book_dto.freezed.dart';
part 'wanted_book_dto.g.dart';

@freezed
abstract class WantedBookDto with _$WantedBookDto {
  const WantedBookDto._();

  const factory WantedBookDto({
    required String id,
    required String userId,
    required String title,
    @Default('') String author,
    String? coverUrl,
    String? workKey,
    required String matchKey,
    required int addedAtMs,
  }) = _WantedBookDto;

  factory WantedBookDto.fromJson(Map<String, dynamic> json) =>
      _$WantedBookDtoFromJson(json);

  factory WantedBookDto.fromEntity(WantedBook entity) => WantedBookDto(
    id: entity.id,
    userId: entity.userId,
    title: entity.title,
    author: entity.author,
    coverUrl: entity.coverUrl,
    workKey: entity.workKey,
    matchKey: entity.matchKey,
    addedAtMs: entity.addedAtMs,
  );

  WantedBook toEntity() => WantedBook(
    id: id,
    userId: userId,
    title: title,
    author: author,
    coverUrl: coverUrl,
    workKey: workKey,
    matchKey: matchKey,
    addedAtMs: addedAtMs,
  );

  static WantedBook parse(Map<String, dynamic> json) =>
      WantedBookDto.fromJson(json).toEntity();
}

extension WantedBookJson on WantedBook {
  Map<String, dynamic> toJson() => WantedBookDto.fromEntity(this).toJson();
}
