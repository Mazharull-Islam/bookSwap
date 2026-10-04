// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_goal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingGoalDto {

 String get userId; int get targetCount; int get startedAtMs; int get periodDays; int get updatedAtMs; int? get deletedAtMs;
/// Create a copy of ReadingGoalDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingGoalDtoCopyWith<ReadingGoalDto> get copyWith => _$ReadingGoalDtoCopyWithImpl<ReadingGoalDto>(this as ReadingGoalDto, _$identity);

  /// Serializes this ReadingGoalDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingGoalDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.periodDays, periodDays) || other.periodDays == periodDays)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs)&&(identical(other.deletedAtMs, deletedAtMs) || other.deletedAtMs == deletedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,targetCount,startedAtMs,periodDays,updatedAtMs,deletedAtMs);

@override
String toString() {
  return 'ReadingGoalDto(userId: $userId, targetCount: $targetCount, startedAtMs: $startedAtMs, periodDays: $periodDays, updatedAtMs: $updatedAtMs, deletedAtMs: $deletedAtMs)';
}


}

/// @nodoc
abstract mixin class $ReadingGoalDtoCopyWith<$Res>  {
  factory $ReadingGoalDtoCopyWith(ReadingGoalDto value, $Res Function(ReadingGoalDto) _then) = _$ReadingGoalDtoCopyWithImpl;
@useResult
$Res call({
 String userId, int targetCount, int startedAtMs, int periodDays, int updatedAtMs, int? deletedAtMs
});




}
/// @nodoc
class _$ReadingGoalDtoCopyWithImpl<$Res>
    implements $ReadingGoalDtoCopyWith<$Res> {
  _$ReadingGoalDtoCopyWithImpl(this._self, this._then);

  final ReadingGoalDto _self;
  final $Res Function(ReadingGoalDto) _then;

/// Create a copy of ReadingGoalDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? targetCount = null,Object? startedAtMs = null,Object? periodDays = null,Object? updatedAtMs = null,Object? deletedAtMs = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,periodDays: null == periodDays ? _self.periodDays : periodDays // ignore: cast_nullable_to_non_nullable
as int,updatedAtMs: null == updatedAtMs ? _self.updatedAtMs : updatedAtMs // ignore: cast_nullable_to_non_nullable
as int,deletedAtMs: freezed == deletedAtMs ? _self.deletedAtMs : deletedAtMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingGoalDto].
extension ReadingGoalDtoPatterns on ReadingGoalDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingGoalDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingGoalDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingGoalDto value)  $default,){
final _that = this;
switch (_that) {
case _ReadingGoalDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingGoalDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingGoalDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  int targetCount,  int startedAtMs,  int periodDays,  int updatedAtMs,  int? deletedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingGoalDto() when $default != null:
return $default(_that.userId,_that.targetCount,_that.startedAtMs,_that.periodDays,_that.updatedAtMs,_that.deletedAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  int targetCount,  int startedAtMs,  int periodDays,  int updatedAtMs,  int? deletedAtMs)  $default,) {final _that = this;
switch (_that) {
case _ReadingGoalDto():
return $default(_that.userId,_that.targetCount,_that.startedAtMs,_that.periodDays,_that.updatedAtMs,_that.deletedAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  int targetCount,  int startedAtMs,  int periodDays,  int updatedAtMs,  int? deletedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _ReadingGoalDto() when $default != null:
return $default(_that.userId,_that.targetCount,_that.startedAtMs,_that.periodDays,_that.updatedAtMs,_that.deletedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingGoalDto extends ReadingGoalDto {
  const _ReadingGoalDto({required this.userId, required this.targetCount, required this.startedAtMs, required this.periodDays, this.updatedAtMs = 0, this.deletedAtMs}): super._();
  factory _ReadingGoalDto.fromJson(Map<String, dynamic> json) => _$ReadingGoalDtoFromJson(json);

@override final  String userId;
@override final  int targetCount;
@override final  int startedAtMs;
@override final  int periodDays;
@override@JsonKey() final  int updatedAtMs;
@override final  int? deletedAtMs;

/// Create a copy of ReadingGoalDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingGoalDtoCopyWith<_ReadingGoalDto> get copyWith => __$ReadingGoalDtoCopyWithImpl<_ReadingGoalDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingGoalDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingGoalDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.periodDays, periodDays) || other.periodDays == periodDays)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs)&&(identical(other.deletedAtMs, deletedAtMs) || other.deletedAtMs == deletedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,targetCount,startedAtMs,periodDays,updatedAtMs,deletedAtMs);

@override
String toString() {
  return 'ReadingGoalDto(userId: $userId, targetCount: $targetCount, startedAtMs: $startedAtMs, periodDays: $periodDays, updatedAtMs: $updatedAtMs, deletedAtMs: $deletedAtMs)';
}


}

/// @nodoc
abstract mixin class _$ReadingGoalDtoCopyWith<$Res> implements $ReadingGoalDtoCopyWith<$Res> {
  factory _$ReadingGoalDtoCopyWith(_ReadingGoalDto value, $Res Function(_ReadingGoalDto) _then) = __$ReadingGoalDtoCopyWithImpl;
@override @useResult
$Res call({
 String userId, int targetCount, int startedAtMs, int periodDays, int updatedAtMs, int? deletedAtMs
});




}
/// @nodoc
class __$ReadingGoalDtoCopyWithImpl<$Res>
    implements _$ReadingGoalDtoCopyWith<$Res> {
  __$ReadingGoalDtoCopyWithImpl(this._self, this._then);

  final _ReadingGoalDto _self;
  final $Res Function(_ReadingGoalDto) _then;

/// Create a copy of ReadingGoalDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? targetCount = null,Object? startedAtMs = null,Object? periodDays = null,Object? updatedAtMs = null,Object? deletedAtMs = freezed,}) {
  return _then(_ReadingGoalDto(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,startedAtMs: null == startedAtMs ? _self.startedAtMs : startedAtMs // ignore: cast_nullable_to_non_nullable
as int,periodDays: null == periodDays ? _self.periodDays : periodDays // ignore: cast_nullable_to_non_nullable
as int,updatedAtMs: null == updatedAtMs ? _self.updatedAtMs : updatedAtMs // ignore: cast_nullable_to_non_nullable
as int,deletedAtMs: freezed == deletedAtMs ? _self.deletedAtMs : deletedAtMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
