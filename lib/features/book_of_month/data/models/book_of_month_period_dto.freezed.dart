// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_of_month_period_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookOfMonthPeriodDto {

 String get id; String? get discussionPostId;
/// Create a copy of BookOfMonthPeriodDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookOfMonthPeriodDtoCopyWith<BookOfMonthPeriodDto> get copyWith => _$BookOfMonthPeriodDtoCopyWithImpl<BookOfMonthPeriodDto>(this as BookOfMonthPeriodDto, _$identity);

  /// Serializes this BookOfMonthPeriodDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookOfMonthPeriodDto&&(identical(other.id, id) || other.id == id)&&(identical(other.discussionPostId, discussionPostId) || other.discussionPostId == discussionPostId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,discussionPostId);

@override
String toString() {
  return 'BookOfMonthPeriodDto(id: $id, discussionPostId: $discussionPostId)';
}


}

/// @nodoc
abstract mixin class $BookOfMonthPeriodDtoCopyWith<$Res>  {
  factory $BookOfMonthPeriodDtoCopyWith(BookOfMonthPeriodDto value, $Res Function(BookOfMonthPeriodDto) _then) = _$BookOfMonthPeriodDtoCopyWithImpl;
@useResult
$Res call({
 String id, String? discussionPostId
});




}
/// @nodoc
class _$BookOfMonthPeriodDtoCopyWithImpl<$Res>
    implements $BookOfMonthPeriodDtoCopyWith<$Res> {
  _$BookOfMonthPeriodDtoCopyWithImpl(this._self, this._then);

  final BookOfMonthPeriodDto _self;
  final $Res Function(BookOfMonthPeriodDto) _then;

/// Create a copy of BookOfMonthPeriodDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? discussionPostId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,discussionPostId: freezed == discussionPostId ? _self.discussionPostId : discussionPostId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookOfMonthPeriodDto].
extension BookOfMonthPeriodDtoPatterns on BookOfMonthPeriodDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookOfMonthPeriodDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookOfMonthPeriodDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookOfMonthPeriodDto value)  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthPeriodDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookOfMonthPeriodDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthPeriodDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? discussionPostId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookOfMonthPeriodDto() when $default != null:
return $default(_that.id,_that.discussionPostId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? discussionPostId)  $default,) {final _that = this;
switch (_that) {
case _BookOfMonthPeriodDto():
return $default(_that.id,_that.discussionPostId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? discussionPostId)?  $default,) {final _that = this;
switch (_that) {
case _BookOfMonthPeriodDto() when $default != null:
return $default(_that.id,_that.discussionPostId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookOfMonthPeriodDto extends BookOfMonthPeriodDto {
  const _BookOfMonthPeriodDto({required this.id, this.discussionPostId}): super._();
  factory _BookOfMonthPeriodDto.fromJson(Map<String, dynamic> json) => _$BookOfMonthPeriodDtoFromJson(json);

@override final  String id;
@override final  String? discussionPostId;

/// Create a copy of BookOfMonthPeriodDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookOfMonthPeriodDtoCopyWith<_BookOfMonthPeriodDto> get copyWith => __$BookOfMonthPeriodDtoCopyWithImpl<_BookOfMonthPeriodDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookOfMonthPeriodDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookOfMonthPeriodDto&&(identical(other.id, id) || other.id == id)&&(identical(other.discussionPostId, discussionPostId) || other.discussionPostId == discussionPostId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,discussionPostId);

@override
String toString() {
  return 'BookOfMonthPeriodDto(id: $id, discussionPostId: $discussionPostId)';
}


}

/// @nodoc
abstract mixin class _$BookOfMonthPeriodDtoCopyWith<$Res> implements $BookOfMonthPeriodDtoCopyWith<$Res> {
  factory _$BookOfMonthPeriodDtoCopyWith(_BookOfMonthPeriodDto value, $Res Function(_BookOfMonthPeriodDto) _then) = __$BookOfMonthPeriodDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? discussionPostId
});




}
/// @nodoc
class __$BookOfMonthPeriodDtoCopyWithImpl<$Res>
    implements _$BookOfMonthPeriodDtoCopyWith<$Res> {
  __$BookOfMonthPeriodDtoCopyWithImpl(this._self, this._then);

  final _BookOfMonthPeriodDto _self;
  final $Res Function(_BookOfMonthPeriodDto) _then;

/// Create a copy of BookOfMonthPeriodDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? discussionPostId = freezed,}) {
  return _then(_BookOfMonthPeriodDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,discussionPostId: freezed == discussionPostId ? _self.discussionPostId : discussionPostId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
