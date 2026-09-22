// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  title: json['title'] as String,
  author: json['author'] as String,
  genre: json['genre'] as String,
  condition: json['condition'] as String,
  estimatedValue: (json['estimatedValue'] as num).toDouble(),
  description: json['description'] as String? ?? '',
  coverPhotoUrl: json['coverPhotoUrl'] as String?,
  isbn: json['isbn'] as String?,
  status:
      $enumDecodeNullable(_$BookStatusEnumMap, json['status']) ??
      BookStatus.available,
);

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'title': instance.title,
  'author': instance.author,
  'genre': instance.genre,
  'condition': instance.condition,
  'estimatedValue': instance.estimatedValue,
  'description': instance.description,
  'coverPhotoUrl': instance.coverPhotoUrl,
  'isbn': instance.isbn,
  'status': _$BookStatusEnumMap[instance.status]!,
};

const _$BookStatusEnumMap = {
  BookStatus.available: 'available',
  BookStatus.requested: 'requested',
  BookStatus.lent: 'lent',
  BookStatus.returned: 'returned',
};
