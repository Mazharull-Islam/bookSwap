// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_of_month_period.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookOfMonthPeriod {

 String get id; String? get discussionPostId;
/// Create a copy of BookOfMonthPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookOfMonthPeriodCopyWith<BookOfMonthPeriod> get copyWith => _$BookOfMonthPeriodCopyWithImpl<BookOfMonthPeriod>(this as BookOfMonthPeriod, _$identity);

  /// Serializes this BookOfMonthPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookOfMonthPeriod&&(identical(other.id, id) || other.id == id)&&(identical(other.discussionPostId, discussionPostId) || other.discussionPostId == discussionPostId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,discussionPostId);

@override
String toString() {
  return 'BookOfMonthPeriod(id: $id, discussionPostId: $discussionPostId)';
}


}

/// @nodoc
abstract mixin class $BookOfMonthPeriodCopyWith<$Res>  {
  factory $BookOfMonthPeriodCopyWith(BookOfMonthPeriod value, $Res Function(BookOfMonthPeriod) _then) = _$BookOfMonthPeriodCopyWithImpl;
@useResult
$Res call({
 String id, String? discussionPostId
});




}
/// @nodoc
class _$BookOfMonthPeriodCopyWithImpl<$Res>
    implements $BookOfMonthPeriodCopyWith<$Res> {
  _$BookOfMonthPeriodCopyWithImpl(this._self, this._then);

  final BookOfMonthPeriod _self;
  final $Res Function(BookOfMonthPeriod) _then;

/// Create a copy of BookOfMonthPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? discussionPostId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,discussionPostId: freezed == discussionPostId ? _self.discussionPostId : discussionPostId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookOfMonthPeriod].
extension BookOfMonthPeriodPatterns on BookOfMonthPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookOfMonthPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookOfMonthPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookOfMonthPeriod value)  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookOfMonthPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthPeriod() when $default != null:
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
case _BookOfMonthPeriod() when $default != null:
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
case _BookOfMonthPeriod():
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
case _BookOfMonthPeriod() when $default != null:
return $default(_that.id,_that.discussionPostId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookOfMonthPeriod implements BookOfMonthPeriod {
  const _BookOfMonthPeriod({required this.id, this.discussionPostId});
  factory _BookOfMonthPeriod.fromJson(Map<String, dynamic> json) => _$BookOfMonthPeriodFromJson(json);

@override final  String id;
@override final  String? discussionPostId;

/// Create a copy of BookOfMonthPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookOfMonthPeriodCopyWith<_BookOfMonthPeriod> get copyWith => __$BookOfMonthPeriodCopyWithImpl<_BookOfMonthPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookOfMonthPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookOfMonthPeriod&&(identical(other.id, id) || other.id == id)&&(identical(other.discussionPostId, discussionPostId) || other.discussionPostId == discussionPostId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,discussionPostId);

@override
String toString() {
  return 'BookOfMonthPeriod(id: $id, discussionPostId: $discussionPostId)';
}


}

/// @nodoc
abstract mixin class _$BookOfMonthPeriodCopyWith<$Res> implements $BookOfMonthPeriodCopyWith<$Res> {
  factory _$BookOfMonthPeriodCopyWith(_BookOfMonthPeriod value, $Res Function(_BookOfMonthPeriod) _then) = __$BookOfMonthPeriodCopyWithImpl;
@override @useResult
$Res call({
 String id, String? discussionPostId
});




}
/// @nodoc
class __$BookOfMonthPeriodCopyWithImpl<$Res>
    implements _$BookOfMonthPeriodCopyWith<$Res> {
  __$BookOfMonthPeriodCopyWithImpl(this._self, this._then);

  final _BookOfMonthPeriod _self;
  final $Res Function(_BookOfMonthPeriod) _then;

/// Create a copy of BookOfMonthPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? discussionPostId = freezed,}) {
  return _then(_BookOfMonthPeriod(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,discussionPostId: freezed == discussionPostId ? _self.discussionPostId : discussionPostId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
