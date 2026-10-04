import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/book.dart';

part 'book_dto.freezed.dart';
part 'book_dto.g.dart';

@freezed
abstract class BookDto with _$BookDto {
  const BookDto._();

  const factory BookDto({
    required String id,
    required String ownerId,
    required String title,
    required String author,
    required String genre,
    required String condition,
    required double estimatedValue,
    @Default('') String description,
    String? coverPhotoUrl,
    String? isbn,
    String? workKey,
    @Default(BookStatus.available) BookStatus status,
    @Default(0) int updatedAtMs,
  }) = _BookDto;

  factory BookDto.fromJson(Map<String, dynamic> json) =>
      _$BookDtoFromJson(json);

  factory BookDto.fromEntity(Book entity) => BookDto(
    id: entity.id,
    ownerId: entity.ownerId,
    title: entity.title,
    author: entity.author,
    genre: entity.genre,
    condition: entity.condition,
    estimatedValue: entity.estimatedValue,
    description: entity.description,
    coverPhotoUrl: entity.coverPhotoUrl,
    isbn: entity.isbn,
    workKey: entity.workKey,
    status: entity.status,
    updatedAtMs: entity.updatedAtMs,
  );

  Book toEntity() => Book(
    id: id,
    ownerId: ownerId,
    title: title,
    author: author,
    genre: genre,
    condition: condition,
    estimatedValue: estimatedValue,
    description: description,
    coverPhotoUrl: coverPhotoUrl,
    isbn: isbn,
    workKey: workKey,
    status: status,
    updatedAtMs: updatedAtMs,
  );

  static Book parse(Map<String, dynamic> json) =>
      BookDto.fromJson(json).toEntity();
}

extension BookJson on Book {
  Map<String, dynamic> toJson() => BookDto.fromEntity(this).toJson();
}
