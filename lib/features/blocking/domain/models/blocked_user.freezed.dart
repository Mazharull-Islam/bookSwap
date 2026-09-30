// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedUser {

/// '${blockerId}_${blockedId}' — deterministic so the /requests create
/// rule can do a targeted `exists()` check without needing read access
/// to this collection (blocks are private to the blocker).
 String get id; String get blockerId; String get blockedId; String get blockedName; int get createdAtMs;
/// Create a copy of BlockedUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedUserCopyWith<BlockedUser> get copyWith => _$BlockedUserCopyWithImpl<BlockedUser>(this as BlockedUser, _$identity);

  /// Serializes this BlockedUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.blockerId, blockerId) || other.blockerId == blockerId)&&(identical(other.blockedId, blockedId) || other.blockedId == blockedId)&&(identical(other.blockedName, blockedName) || other.blockedName == blockedName)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,blockerId,blockedId,blockedName,createdAtMs);

@override
String toString() {
  return 'BlockedUser(id: $id, blockerId: $blockerId, blockedId: $blockedId, blockedName: $blockedName, createdAtMs: $createdAtMs)';
}


}

/// @nodoc
abstract mixin class $BlockedUserCopyWith<$Res>  {
  factory $BlockedUserCopyWith(BlockedUser value, $Res Function(BlockedUser) _then) = _$BlockedUserCopyWithImpl;
@useResult
$Res call({
 String id, String blockerId, String blockedId, String blockedName, int createdAtMs
});




}
/// @nodoc
class _$BlockedUserCopyWithImpl<$Res>
    implements $BlockedUserCopyWith<$Res> {
  _$BlockedUserCopyWithImpl(this._self, this._then);

  final BlockedUser _self;
  final $Res Function(BlockedUser) _then;

/// Create a copy of BlockedUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? blockerId = null,Object? blockedId = null,Object? blockedName = null,Object? createdAtMs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,blockerId: null == blockerId ? _self.blockerId : blockerId // ignore: cast_nullable_to_non_nullable
as String,blockedId: null == blockedId ? _self.blockedId : blockedId // ignore: cast_nullable_to_non_nullable
as String,blockedName: null == blockedName ? _self.blockedName : blockedName // ignore: cast_nullable_to_non_nullable
as String,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BlockedUser].
extension BlockedUserPatterns on BlockedUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedUser value)  $default,){
final _that = this;
switch (_that) {
case _BlockedUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedUser value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String blockerId,  String blockedId,  String blockedName,  int createdAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlockedUser() when $default != null:
return $default(_that.id,_that.blockerId,_that.blockedId,_that.blockedName,_that.createdAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String blockerId,  String blockedId,  String blockedName,  int createdAtMs)  $default,) {final _that = this;
switch (_that) {
case _BlockedUser():
return $default(_that.id,_that.blockerId,_that.blockedId,_that.blockedName,_that.createdAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String blockerId,  String blockedId,  String blockedName,  int createdAtMs)?  $default,) {final _that = this;
switch (_that) {
case _BlockedUser() when $default != null:
return $default(_that.id,_that.blockerId,_that.blockedId,_that.blockedName,_that.createdAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlockedUser implements BlockedUser {
  const _BlockedUser({required this.id, required this.blockerId, required this.blockedId, required this.blockedName, required this.createdAtMs});
  factory _BlockedUser.fromJson(Map<String, dynamic> json) => _$BlockedUserFromJson(json);

/// '${blockerId}_${blockedId}' — deterministic so the /requests create
/// rule can do a targeted `exists()` check without needing read access
/// to this collection (blocks are private to the blocker).
@override final  String id;
@override final  String blockerId;
@override final  String blockedId;
@override final  String blockedName;
@override final  int createdAtMs;

/// Create a copy of BlockedUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedUserCopyWith<_BlockedUser> get copyWith => __$BlockedUserCopyWithImpl<_BlockedUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockedUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.blockerId, blockerId) || other.blockerId == blockerId)&&(identical(other.blockedId, blockedId) || other.blockedId == blockedId)&&(identical(other.blockedName, blockedName) || other.blockedName == blockedName)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,blockerId,blockedId,blockedName,createdAtMs);

@override
String toString() {
  return 'BlockedUser(id: $id, blockerId: $blockerId, blockedId: $blockedId, blockedName: $blockedName, createdAtMs: $createdAtMs)';
}


}

/// @nodoc
abstract mixin class _$BlockedUserCopyWith<$Res> implements $BlockedUserCopyWith<$Res> {
  factory _$BlockedUserCopyWith(_BlockedUser value, $Res Function(_BlockedUser) _then) = __$BlockedUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String blockerId, String blockedId, String blockedName, int createdAtMs
});




}
/// @nodoc
class __$BlockedUserCopyWithImpl<$Res>
    implements _$BlockedUserCopyWith<$Res> {
  __$BlockedUserCopyWithImpl(this._self, this._then);

  final _BlockedUser _self;
  final $Res Function(_BlockedUser) _then;

/// Create a copy of BlockedUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? blockerId = null,Object? blockedId = null,Object? blockedName = null,Object? createdAtMs = null,}) {
  return _then(_BlockedUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,blockerId: null == blockerId ? _self.blockerId : blockerId // ignore: cast_nullable_to_non_nullable
as String,blockedId: null == blockedId ? _self.blockedId : blockedId // ignore: cast_nullable_to_non_nullable
as String,blockedName: null == blockedName ? _self.blockedName : blockedName // ignore: cast_nullable_to_non_nullable
as String,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
