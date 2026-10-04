// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wanted_book_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WantedBookDto {

 String get id; String get userId; String get title; String get author; String? get coverUrl; String? get workKey; String get matchKey; int get addedAtMs;
/// Create a copy of WantedBookDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WantedBookDtoCopyWith<WantedBookDto> get copyWith => _$WantedBookDtoCopyWithImpl<WantedBookDto>(this as WantedBookDto, _$identity);

  /// Serializes this WantedBookDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WantedBookDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.addedAtMs, addedAtMs) || other.addedAtMs == addedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,author,coverUrl,workKey,matchKey,addedAtMs);

@override
String toString() {
  return 'WantedBookDto(id: $id, userId: $userId, title: $title, author: $author, coverUrl: $coverUrl, workKey: $workKey, matchKey: $matchKey, addedAtMs: $addedAtMs)';
}


}

/// @nodoc
abstract mixin class $WantedBookDtoCopyWith<$Res>  {
  factory $WantedBookDtoCopyWith(WantedBookDto value, $Res Function(WantedBookDto) _then) = _$WantedBookDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String author, String? coverUrl, String? workKey, String matchKey, int addedAtMs
});




}
/// @nodoc
class _$WantedBookDtoCopyWithImpl<$Res>
    implements $WantedBookDtoCopyWith<$Res> {
  _$WantedBookDtoCopyWithImpl(this._self, this._then);

  final WantedBookDto _self;
  final $Res Function(WantedBookDto) _then;

/// Create a copy of WantedBookDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? author = null,Object? coverUrl = freezed,Object? workKey = freezed,Object? matchKey = null,Object? addedAtMs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,addedAtMs: null == addedAtMs ? _self.addedAtMs : addedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WantedBookDto].
extension WantedBookDtoPatterns on WantedBookDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WantedBookDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WantedBookDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WantedBookDto value)  $default,){
final _that = this;
switch (_that) {
case _WantedBookDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WantedBookDto value)?  $default,){
final _that = this;
switch (_that) {
case _WantedBookDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String author,  String? coverUrl,  String? workKey,  String matchKey,  int addedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WantedBookDto() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.author,_that.coverUrl,_that.workKey,_that.matchKey,_that.addedAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String author,  String? coverUrl,  String? workKey,  String matchKey,  int addedAtMs)  $default,) {final _that = this;
switch (_that) {
case _WantedBookDto():
return $default(_that.id,_that.userId,_that.title,_that.author,_that.coverUrl,_that.workKey,_that.matchKey,_that.addedAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String author,  String? coverUrl,  String? workKey,  String matchKey,  int addedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _WantedBookDto() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.author,_that.coverUrl,_that.workKey,_that.matchKey,_that.addedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WantedBookDto extends WantedBookDto {
  const _WantedBookDto({required this.id, required this.userId, required this.title, this.author = '', this.coverUrl, this.workKey, required this.matchKey, required this.addedAtMs}): super._();
  factory _WantedBookDto.fromJson(Map<String, dynamic> json) => _$WantedBookDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override@JsonKey() final  String author;
@override final  String? coverUrl;
@override final  String? workKey;
@override final  String matchKey;
@override final  int addedAtMs;

/// Create a copy of WantedBookDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WantedBookDtoCopyWith<_WantedBookDto> get copyWith => __$WantedBookDtoCopyWithImpl<_WantedBookDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WantedBookDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WantedBookDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.addedAtMs, addedAtMs) || other.addedAtMs == addedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,author,coverUrl,workKey,matchKey,addedAtMs);

@override
String toString() {
  return 'WantedBookDto(id: $id, userId: $userId, title: $title, author: $author, coverUrl: $coverUrl, workKey: $workKey, matchKey: $matchKey, addedAtMs: $addedAtMs)';
}


}

/// @nodoc
abstract mixin class _$WantedBookDtoCopyWith<$Res> implements $WantedBookDtoCopyWith<$Res> {
  factory _$WantedBookDtoCopyWith(_WantedBookDto value, $Res Function(_WantedBookDto) _then) = __$WantedBookDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String author, String? coverUrl, String? workKey, String matchKey, int addedAtMs
});




}
/// @nodoc
class __$WantedBookDtoCopyWithImpl<$Res>
    implements _$WantedBookDtoCopyWith<$Res> {
  __$WantedBookDtoCopyWithImpl(this._self, this._then);

  final _WantedBookDto _self;
  final $Res Function(_WantedBookDto) _then;

/// Create a copy of WantedBookDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? author = null,Object? coverUrl = freezed,Object? workKey = freezed,Object? matchKey = null,Object? addedAtMs = null,}) {
  return _then(_WantedBookDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,addedAtMs: null == addedAtMs ? _self.addedAtMs : addedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
