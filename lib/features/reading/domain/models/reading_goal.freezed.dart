// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingGoal {

 String get userId; int get targetCount; int get startedAtMs; int get periodDays;/// Last change, for last-write-wins when syncing between devices.
 int get updatedAtMs;/// Set when the goal is cleared (soft delete, same reasoning as
/// ReadingEntry.deletedAtMs).
 int? get deletedAtMs;
/// Create a copy of ReadingGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingGoalCopyWith<ReadingGoal> get copyWith => _$ReadingGoalCopyWithImpl<ReadingGoal>(this as ReadingGoal, _$identity);

  /// Serializes this ReadingGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingGoal&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.periodDays, periodDays) || other.periodDays == periodDays)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs)&&(identical(other.deletedAtMs, deletedAtMs) || other.deletedAtMs == deletedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,targetCount,startedAtMs,periodDays,updatedAtMs,deletedAtMs);

@override
String toString() {
  return 'ReadingGoal(userId: $userId, targetCount: $targetCount, startedAtMs: $startedAtMs, periodDays: $periodDays, updatedAtMs: $updatedAtMs, deletedAtMs: $deletedAtMs)';
}


}

/// @nodoc
abstract mixin class $ReadingGoalCopyWith<$Res>  {
  factory $ReadingGoalCopyWith(ReadingGoal value, $Res Function(ReadingGoal) _then) = _$ReadingGoalCopyWithImpl;
@useResult
$Res call({
 String userId, int targetCount, int startedAtMs, int periodDays, int updatedAtMs, int? deletedAtMs
});




}
/// @nodoc
class _$ReadingGoalCopyWithImpl<$Res>
    implements $ReadingGoalCopyWith<$Res> {
  _$ReadingGoalCopyWithImpl(this._self, this._then);

  final ReadingGoal _self;
  final $Res Function(ReadingGoal) _then;

/// Create a copy of ReadingGoal
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


/// Adds pattern-matching-related methods to [ReadingGoal].
extension ReadingGoalPatterns on ReadingGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingGoal value)  $default,){
final _that = this;
switch (_that) {
case _ReadingGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingGoal value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingGoal() when $default != null:
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
case _ReadingGoal() when $default != null:
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
case _ReadingGoal():
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
case _ReadingGoal() when $default != null:
return $default(_that.userId,_that.targetCount,_that.startedAtMs,_that.periodDays,_that.updatedAtMs,_that.deletedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingGoal implements ReadingGoal {
  const _ReadingGoal({required this.userId, required this.targetCount, required this.startedAtMs, required this.periodDays, this.updatedAtMs = 0, this.deletedAtMs});
  factory _ReadingGoal.fromJson(Map<String, dynamic> json) => _$ReadingGoalFromJson(json);

@override final  String userId;
@override final  int targetCount;
@override final  int startedAtMs;
@override final  int periodDays;
/// Last change, for last-write-wins when syncing between devices.
@override@JsonKey() final  int updatedAtMs;
/// Set when the goal is cleared (soft delete, same reasoning as
/// ReadingEntry.deletedAtMs).
@override final  int? deletedAtMs;

/// Create a copy of ReadingGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingGoalCopyWith<_ReadingGoal> get copyWith => __$ReadingGoalCopyWithImpl<_ReadingGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingGoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingGoal&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.startedAtMs, startedAtMs) || other.startedAtMs == startedAtMs)&&(identical(other.periodDays, periodDays) || other.periodDays == periodDays)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs)&&(identical(other.deletedAtMs, deletedAtMs) || other.deletedAtMs == deletedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,targetCount,startedAtMs,periodDays,updatedAtMs,deletedAtMs);

@override
String toString() {
  return 'ReadingGoal(userId: $userId, targetCount: $targetCount, startedAtMs: $startedAtMs, periodDays: $periodDays, updatedAtMs: $updatedAtMs, deletedAtMs: $deletedAtMs)';
}


}

/// @nodoc
abstract mixin class _$ReadingGoalCopyWith<$Res> implements $ReadingGoalCopyWith<$Res> {
  factory _$ReadingGoalCopyWith(_ReadingGoal value, $Res Function(_ReadingGoal) _then) = __$ReadingGoalCopyWithImpl;
@override @useResult
$Res call({
 String userId, int targetCount, int startedAtMs, int periodDays, int updatedAtMs, int? deletedAtMs
});




}
/// @nodoc
class __$ReadingGoalCopyWithImpl<$Res>
    implements _$ReadingGoalCopyWith<$Res> {
  __$ReadingGoalCopyWithImpl(this._self, this._then);

  final _ReadingGoal _self;
  final $Res Function(_ReadingGoal) _then;

/// Create a copy of ReadingGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? targetCount = null,Object? startedAtMs = null,Object? periodDays = null,Object? updatedAtMs = null,Object? deletedAtMs = freezed,}) {
  return _then(_ReadingGoal(
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
