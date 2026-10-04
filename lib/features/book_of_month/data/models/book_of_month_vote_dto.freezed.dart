// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_of_month_vote_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookOfMonthVoteDto {

 String get id; String get periodId; String get userId; String get matchKey; int get votedAtMs;
/// Create a copy of BookOfMonthVoteDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookOfMonthVoteDtoCopyWith<BookOfMonthVoteDto> get copyWith => _$BookOfMonthVoteDtoCopyWithImpl<BookOfMonthVoteDto>(this as BookOfMonthVoteDto, _$identity);

  /// Serializes this BookOfMonthVoteDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookOfMonthVoteDto&&(identical(other.id, id) || other.id == id)&&(identical(other.periodId, periodId) || other.periodId == periodId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.votedAtMs, votedAtMs) || other.votedAtMs == votedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodId,userId,matchKey,votedAtMs);

@override
String toString() {
  return 'BookOfMonthVoteDto(id: $id, periodId: $periodId, userId: $userId, matchKey: $matchKey, votedAtMs: $votedAtMs)';
}


}

/// @nodoc
abstract mixin class $BookOfMonthVoteDtoCopyWith<$Res>  {
  factory $BookOfMonthVoteDtoCopyWith(BookOfMonthVoteDto value, $Res Function(BookOfMonthVoteDto) _then) = _$BookOfMonthVoteDtoCopyWithImpl;
@useResult
$Res call({
 String id, String periodId, String userId, String matchKey, int votedAtMs
});




}
/// @nodoc
class _$BookOfMonthVoteDtoCopyWithImpl<$Res>
    implements $BookOfMonthVoteDtoCopyWith<$Res> {
  _$BookOfMonthVoteDtoCopyWithImpl(this._self, this._then);

  final BookOfMonthVoteDto _self;
  final $Res Function(BookOfMonthVoteDto) _then;

/// Create a copy of BookOfMonthVoteDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? periodId = null,Object? userId = null,Object? matchKey = null,Object? votedAtMs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,periodId: null == periodId ? _self.periodId : periodId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,votedAtMs: null == votedAtMs ? _self.votedAtMs : votedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookOfMonthVoteDto].
extension BookOfMonthVoteDtoPatterns on BookOfMonthVoteDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookOfMonthVoteDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookOfMonthVoteDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookOfMonthVoteDto value)  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthVoteDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookOfMonthVoteDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthVoteDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String periodId,  String userId,  String matchKey,  int votedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookOfMonthVoteDto() when $default != null:
return $default(_that.id,_that.periodId,_that.userId,_that.matchKey,_that.votedAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String periodId,  String userId,  String matchKey,  int votedAtMs)  $default,) {final _that = this;
switch (_that) {
case _BookOfMonthVoteDto():
return $default(_that.id,_that.periodId,_that.userId,_that.matchKey,_that.votedAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String periodId,  String userId,  String matchKey,  int votedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _BookOfMonthVoteDto() when $default != null:
return $default(_that.id,_that.periodId,_that.userId,_that.matchKey,_that.votedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookOfMonthVoteDto extends BookOfMonthVoteDto {
  const _BookOfMonthVoteDto({required this.id, required this.periodId, required this.userId, required this.matchKey, required this.votedAtMs}): super._();
  factory _BookOfMonthVoteDto.fromJson(Map<String, dynamic> json) => _$BookOfMonthVoteDtoFromJson(json);

@override final  String id;
@override final  String periodId;
@override final  String userId;
@override final  String matchKey;
@override final  int votedAtMs;

/// Create a copy of BookOfMonthVoteDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookOfMonthVoteDtoCopyWith<_BookOfMonthVoteDto> get copyWith => __$BookOfMonthVoteDtoCopyWithImpl<_BookOfMonthVoteDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookOfMonthVoteDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookOfMonthVoteDto&&(identical(other.id, id) || other.id == id)&&(identical(other.periodId, periodId) || other.periodId == periodId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.votedAtMs, votedAtMs) || other.votedAtMs == votedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodId,userId,matchKey,votedAtMs);

@override
String toString() {
  return 'BookOfMonthVoteDto(id: $id, periodId: $periodId, userId: $userId, matchKey: $matchKey, votedAtMs: $votedAtMs)';
}


}

/// @nodoc
abstract mixin class _$BookOfMonthVoteDtoCopyWith<$Res> implements $BookOfMonthVoteDtoCopyWith<$Res> {
  factory _$BookOfMonthVoteDtoCopyWith(_BookOfMonthVoteDto value, $Res Function(_BookOfMonthVoteDto) _then) = __$BookOfMonthVoteDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String periodId, String userId, String matchKey, int votedAtMs
});




}
/// @nodoc
class __$BookOfMonthVoteDtoCopyWithImpl<$Res>
    implements _$BookOfMonthVoteDtoCopyWith<$Res> {
  __$BookOfMonthVoteDtoCopyWithImpl(this._self, this._then);

  final _BookOfMonthVoteDto _self;
  final $Res Function(_BookOfMonthVoteDto) _then;

/// Create a copy of BookOfMonthVoteDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? periodId = null,Object? userId = null,Object? matchKey = null,Object? votedAtMs = null,}) {
  return _then(_BookOfMonthVoteDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,periodId: null == periodId ? _self.periodId : periodId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,votedAtMs: null == votedAtMs ? _self.votedAtMs : votedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
