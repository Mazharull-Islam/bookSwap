// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedUserDto {

 String get id; String get blockerId; String get blockedId; String get blockedName; int get createdAtMs;
/// Create a copy of BlockedUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockedUserDtoCopyWith<BlockedUserDto> get copyWith => _$BlockedUserDtoCopyWithImpl<BlockedUserDto>(this as BlockedUserDto, _$identity);

  /// Serializes this BlockedUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockedUserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.blockerId, blockerId) || other.blockerId == blockerId)&&(identical(other.blockedId, blockedId) || other.blockedId == blockedId)&&(identical(other.blockedName, blockedName) || other.blockedName == blockedName)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,blockerId,blockedId,blockedName,createdAtMs);

@override
String toString() {
  return 'BlockedUserDto(id: $id, blockerId: $blockerId, blockedId: $blockedId, blockedName: $blockedName, createdAtMs: $createdAtMs)';
}


}

/// @nodoc
abstract mixin class $BlockedUserDtoCopyWith<$Res>  {
  factory $BlockedUserDtoCopyWith(BlockedUserDto value, $Res Function(BlockedUserDto) _then) = _$BlockedUserDtoCopyWithImpl;
@useResult
$Res call({
 String id, String blockerId, String blockedId, String blockedName, int createdAtMs
});




}
/// @nodoc
class _$BlockedUserDtoCopyWithImpl<$Res>
    implements $BlockedUserDtoCopyWith<$Res> {
  _$BlockedUserDtoCopyWithImpl(this._self, this._then);

  final BlockedUserDto _self;
  final $Res Function(BlockedUserDto) _then;

/// Create a copy of BlockedUserDto
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


/// Adds pattern-matching-related methods to [BlockedUserDto].
extension BlockedUserDtoPatterns on BlockedUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlockedUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlockedUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlockedUserDto value)  $default,){
final _that = this;
switch (_that) {
case _BlockedUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlockedUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _BlockedUserDto() when $default != null:
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
case _BlockedUserDto() when $default != null:
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
case _BlockedUserDto():
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
case _BlockedUserDto() when $default != null:
return $default(_that.id,_that.blockerId,_that.blockedId,_that.blockedName,_that.createdAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlockedUserDto extends BlockedUserDto {
  const _BlockedUserDto({required this.id, required this.blockerId, required this.blockedId, required this.blockedName, required this.createdAtMs}): super._();
  factory _BlockedUserDto.fromJson(Map<String, dynamic> json) => _$BlockedUserDtoFromJson(json);

@override final  String id;
@override final  String blockerId;
@override final  String blockedId;
@override final  String blockedName;
@override final  int createdAtMs;

/// Create a copy of BlockedUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedUserDtoCopyWith<_BlockedUserDto> get copyWith => __$BlockedUserDtoCopyWithImpl<_BlockedUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockedUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedUserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.blockerId, blockerId) || other.blockerId == blockerId)&&(identical(other.blockedId, blockedId) || other.blockedId == blockedId)&&(identical(other.blockedName, blockedName) || other.blockedName == blockedName)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,blockerId,blockedId,blockedName,createdAtMs);

@override
String toString() {
  return 'BlockedUserDto(id: $id, blockerId: $blockerId, blockedId: $blockedId, blockedName: $blockedName, createdAtMs: $createdAtMs)';
}


}

/// @nodoc
abstract mixin class _$BlockedUserDtoCopyWith<$Res> implements $BlockedUserDtoCopyWith<$Res> {
  factory _$BlockedUserDtoCopyWith(_BlockedUserDto value, $Res Function(_BlockedUserDto) _then) = __$BlockedUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String blockerId, String blockedId, String blockedName, int createdAtMs
});




}
/// @nodoc
class __$BlockedUserDtoCopyWithImpl<$Res>
    implements _$BlockedUserDtoCopyWith<$Res> {
  __$BlockedUserDtoCopyWithImpl(this._self, this._then);

  final _BlockedUserDto _self;
  final $Res Function(_BlockedUserDto) _then;

/// Create a copy of BlockedUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? blockerId = null,Object? blockedId = null,Object? blockedName = null,Object? createdAtMs = null,}) {
  return _then(_BlockedUserDto(
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
