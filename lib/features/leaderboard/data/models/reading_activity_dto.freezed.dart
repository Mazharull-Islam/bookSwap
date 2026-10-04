// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_activity_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingActivityDto {

 String get id; String get userId; String get userName; String get author; String? get genre; String get periodId; int get markedReadAtMs;
/// Create a copy of ReadingActivityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingActivityDtoCopyWith<ReadingActivityDto> get copyWith => _$ReadingActivityDtoCopyWithImpl<ReadingActivityDto>(this as ReadingActivityDto, _$identity);

  /// Serializes this ReadingActivityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingActivityDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.author, author) || other.author == author)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.periodId, periodId) || other.periodId == periodId)&&(identical(other.markedReadAtMs, markedReadAtMs) || other.markedReadAtMs == markedReadAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,author,genre,periodId,markedReadAtMs);

@override
String toString() {
  return 'ReadingActivityDto(id: $id, userId: $userId, userName: $userName, author: $author, genre: $genre, periodId: $periodId, markedReadAtMs: $markedReadAtMs)';
}


}

/// @nodoc
abstract mixin class $ReadingActivityDtoCopyWith<$Res>  {
  factory $ReadingActivityDtoCopyWith(ReadingActivityDto value, $Res Function(ReadingActivityDto) _then) = _$ReadingActivityDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String userName, String author, String? genre, String periodId, int markedReadAtMs
});




}
/// @nodoc
class _$ReadingActivityDtoCopyWithImpl<$Res>
    implements $ReadingActivityDtoCopyWith<$Res> {
  _$ReadingActivityDtoCopyWithImpl(this._self, this._then);

  final ReadingActivityDto _self;
  final $Res Function(ReadingActivityDto) _then;

/// Create a copy of ReadingActivityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? author = null,Object? genre = freezed,Object? periodId = null,Object? markedReadAtMs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,periodId: null == periodId ? _self.periodId : periodId // ignore: cast_nullable_to_non_nullable
as String,markedReadAtMs: null == markedReadAtMs ? _self.markedReadAtMs : markedReadAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingActivityDto].
extension ReadingActivityDtoPatterns on ReadingActivityDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingActivityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingActivityDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingActivityDto value)  $default,){
final _that = this;
switch (_that) {
case _ReadingActivityDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingActivityDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingActivityDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String author,  String? genre,  String periodId,  int markedReadAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingActivityDto() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.author,_that.genre,_that.periodId,_that.markedReadAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String author,  String? genre,  String periodId,  int markedReadAtMs)  $default,) {final _that = this;
switch (_that) {
case _ReadingActivityDto():
return $default(_that.id,_that.userId,_that.userName,_that.author,_that.genre,_that.periodId,_that.markedReadAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String userName,  String author,  String? genre,  String periodId,  int markedReadAtMs)?  $default,) {final _that = this;
switch (_that) {
case _ReadingActivityDto() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.author,_that.genre,_that.periodId,_that.markedReadAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingActivityDto extends ReadingActivityDto {
  const _ReadingActivityDto({required this.id, required this.userId, required this.userName, this.author = '', this.genre, required this.periodId, required this.markedReadAtMs}): super._();
  factory _ReadingActivityDto.fromJson(Map<String, dynamic> json) => _$ReadingActivityDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String userName;
@override@JsonKey() final  String author;
@override final  String? genre;
@override final  String periodId;
@override final  int markedReadAtMs;

/// Create a copy of ReadingActivityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingActivityDtoCopyWith<_ReadingActivityDto> get copyWith => __$ReadingActivityDtoCopyWithImpl<_ReadingActivityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingActivityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingActivityDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.author, author) || other.author == author)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.periodId, periodId) || other.periodId == periodId)&&(identical(other.markedReadAtMs, markedReadAtMs) || other.markedReadAtMs == markedReadAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,author,genre,periodId,markedReadAtMs);

@override
String toString() {
  return 'ReadingActivityDto(id: $id, userId: $userId, userName: $userName, author: $author, genre: $genre, periodId: $periodId, markedReadAtMs: $markedReadAtMs)';
}


}

/// @nodoc
abstract mixin class _$ReadingActivityDtoCopyWith<$Res> implements $ReadingActivityDtoCopyWith<$Res> {
  factory _$ReadingActivityDtoCopyWith(_ReadingActivityDto value, $Res Function(_ReadingActivityDto) _then) = __$ReadingActivityDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String userName, String author, String? genre, String periodId, int markedReadAtMs
});




}
/// @nodoc
class __$ReadingActivityDtoCopyWithImpl<$Res>
    implements _$ReadingActivityDtoCopyWith<$Res> {
  __$ReadingActivityDtoCopyWithImpl(this._self, this._then);

  final _ReadingActivityDto _self;
  final $Res Function(_ReadingActivityDto) _then;

/// Create a copy of ReadingActivityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? author = null,Object? genre = freezed,Object? periodId = null,Object? markedReadAtMs = null,}) {
  return _then(_ReadingActivityDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,periodId: null == periodId ? _self.periodId : periodId // ignore: cast_nullable_to_non_nullable
as String,markedReadAtMs: null == markedReadAtMs ? _self.markedReadAtMs : markedReadAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
