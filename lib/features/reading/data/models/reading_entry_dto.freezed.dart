// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_entry_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingEntryDto {

 String get id; String get userId; String get title; String get author; String get genre; String? get publishedYear; String get description; String? get coverUrl; String? get workKey; ReadingStatus get status; int? get rating; String get review; int get updatedAtMs; int? get deletedAtMs;
/// Create a copy of ReadingEntryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingEntryDtoCopyWith<ReadingEntryDto> get copyWith => _$ReadingEntryDtoCopyWithImpl<ReadingEntryDto>(this as ReadingEntryDto, _$identity);

  /// Serializes this ReadingEntryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingEntryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.publishedYear, publishedYear) || other.publishedYear == publishedYear)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.review, review) || other.review == review)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs)&&(identical(other.deletedAtMs, deletedAtMs) || other.deletedAtMs == deletedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,author,genre,publishedYear,description,coverUrl,workKey,status,rating,review,updatedAtMs,deletedAtMs);

@override
String toString() {
  return 'ReadingEntryDto(id: $id, userId: $userId, title: $title, author: $author, genre: $genre, publishedYear: $publishedYear, description: $description, coverUrl: $coverUrl, workKey: $workKey, status: $status, rating: $rating, review: $review, updatedAtMs: $updatedAtMs, deletedAtMs: $deletedAtMs)';
}


}

/// @nodoc
abstract mixin class $ReadingEntryDtoCopyWith<$Res>  {
  factory $ReadingEntryDtoCopyWith(ReadingEntryDto value, $Res Function(ReadingEntryDto) _then) = _$ReadingEntryDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String author, String genre, String? publishedYear, String description, String? coverUrl, String? workKey, ReadingStatus status, int? rating, String review, int updatedAtMs, int? deletedAtMs
});




}
/// @nodoc
class _$ReadingEntryDtoCopyWithImpl<$Res>
    implements $ReadingEntryDtoCopyWith<$Res> {
  _$ReadingEntryDtoCopyWithImpl(this._self, this._then);

  final ReadingEntryDto _self;
  final $Res Function(ReadingEntryDto) _then;

/// Create a copy of ReadingEntryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? author = null,Object? genre = null,Object? publishedYear = freezed,Object? description = null,Object? coverUrl = freezed,Object? workKey = freezed,Object? status = null,Object? rating = freezed,Object? review = null,Object? updatedAtMs = null,Object? deletedAtMs = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,publishedYear: freezed == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,review: null == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String,updatedAtMs: null == updatedAtMs ? _self.updatedAtMs : updatedAtMs // ignore: cast_nullable_to_non_nullable
as int,deletedAtMs: freezed == deletedAtMs ? _self.deletedAtMs : deletedAtMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingEntryDto].
extension ReadingEntryDtoPatterns on ReadingEntryDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingEntryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingEntryDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingEntryDto value)  $default,){
final _that = this;
switch (_that) {
case _ReadingEntryDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingEntryDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingEntryDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String author,  String genre,  String? publishedYear,  String description,  String? coverUrl,  String? workKey,  ReadingStatus status,  int? rating,  String review,  int updatedAtMs,  int? deletedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingEntryDto() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.author,_that.genre,_that.publishedYear,_that.description,_that.coverUrl,_that.workKey,_that.status,_that.rating,_that.review,_that.updatedAtMs,_that.deletedAtMs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String author,  String genre,  String? publishedYear,  String description,  String? coverUrl,  String? workKey,  ReadingStatus status,  int? rating,  String review,  int updatedAtMs,  int? deletedAtMs)  $default,) {final _that = this;
switch (_that) {
case _ReadingEntryDto():
return $default(_that.id,_that.userId,_that.title,_that.author,_that.genre,_that.publishedYear,_that.description,_that.coverUrl,_that.workKey,_that.status,_that.rating,_that.review,_that.updatedAtMs,_that.deletedAtMs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String author,  String genre,  String? publishedYear,  String description,  String? coverUrl,  String? workKey,  ReadingStatus status,  int? rating,  String review,  int updatedAtMs,  int? deletedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _ReadingEntryDto() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.author,_that.genre,_that.publishedYear,_that.description,_that.coverUrl,_that.workKey,_that.status,_that.rating,_that.review,_that.updatedAtMs,_that.deletedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingEntryDto extends ReadingEntryDto {
  const _ReadingEntryDto({required this.id, required this.userId, required this.title, this.author = '', this.genre = '', this.publishedYear, this.description = '', this.coverUrl, this.workKey, this.status = ReadingStatus.planToRead, this.rating, this.review = '', required this.updatedAtMs, this.deletedAtMs}): super._();
  factory _ReadingEntryDto.fromJson(Map<String, dynamic> json) => _$ReadingEntryDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override@JsonKey() final  String author;
@override@JsonKey() final  String genre;
@override final  String? publishedYear;
@override@JsonKey() final  String description;
@override final  String? coverUrl;
@override final  String? workKey;
@override@JsonKey() final  ReadingStatus status;
@override final  int? rating;
@override@JsonKey() final  String review;
@override final  int updatedAtMs;
@override final  int? deletedAtMs;

/// Create a copy of ReadingEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingEntryDtoCopyWith<_ReadingEntryDto> get copyWith => __$ReadingEntryDtoCopyWithImpl<_ReadingEntryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingEntryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingEntryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.publishedYear, publishedYear) || other.publishedYear == publishedYear)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.review, review) || other.review == review)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs)&&(identical(other.deletedAtMs, deletedAtMs) || other.deletedAtMs == deletedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,author,genre,publishedYear,description,coverUrl,workKey,status,rating,review,updatedAtMs,deletedAtMs);

@override
String toString() {
  return 'ReadingEntryDto(id: $id, userId: $userId, title: $title, author: $author, genre: $genre, publishedYear: $publishedYear, description: $description, coverUrl: $coverUrl, workKey: $workKey, status: $status, rating: $rating, review: $review, updatedAtMs: $updatedAtMs, deletedAtMs: $deletedAtMs)';
}


}

/// @nodoc
abstract mixin class _$ReadingEntryDtoCopyWith<$Res> implements $ReadingEntryDtoCopyWith<$Res> {
  factory _$ReadingEntryDtoCopyWith(_ReadingEntryDto value, $Res Function(_ReadingEntryDto) _then) = __$ReadingEntryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String author, String genre, String? publishedYear, String description, String? coverUrl, String? workKey, ReadingStatus status, int? rating, String review, int updatedAtMs, int? deletedAtMs
});




}
/// @nodoc
class __$ReadingEntryDtoCopyWithImpl<$Res>
    implements _$ReadingEntryDtoCopyWith<$Res> {
  __$ReadingEntryDtoCopyWithImpl(this._self, this._then);

  final _ReadingEntryDto _self;
  final $Res Function(_ReadingEntryDto) _then;

/// Create a copy of ReadingEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? author = null,Object? genre = null,Object? publishedYear = freezed,Object? description = null,Object? coverUrl = freezed,Object? workKey = freezed,Object? status = null,Object? rating = freezed,Object? review = null,Object? updatedAtMs = null,Object? deletedAtMs = freezed,}) {
  return _then(_ReadingEntryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,publishedYear: freezed == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,review: null == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String,updatedAtMs: null == updatedAtMs ? _self.updatedAtMs : updatedAtMs // ignore: cast_nullable_to_non_nullable
as int,deletedAtMs: freezed == deletedAtMs ? _self.deletedAtMs : deletedAtMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
