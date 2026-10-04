// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forum_reply_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForumReplyDto {

 String get id; String get postId; String get authorId; String get authorName; String get body; int get createdAtMs; List<String> get likedBy; List<String> get reportedBy;
/// Create a copy of ForumReplyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumReplyDtoCopyWith<ForumReplyDto> get copyWith => _$ForumReplyDtoCopyWithImpl<ForumReplyDto>(this as ForumReplyDto, _$identity);

  /// Serializes this ForumReplyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumReplyDto&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&const DeepCollectionEquality().equals(other.likedBy, likedBy)&&const DeepCollectionEquality().equals(other.reportedBy, reportedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,authorId,authorName,body,createdAtMs,const DeepCollectionEquality().hash(likedBy),const DeepCollectionEquality().hash(reportedBy));

@override
String toString() {
  return 'ForumReplyDto(id: $id, postId: $postId, authorId: $authorId, authorName: $authorName, body: $body, createdAtMs: $createdAtMs, likedBy: $likedBy, reportedBy: $reportedBy)';
}


}

/// @nodoc
abstract mixin class $ForumReplyDtoCopyWith<$Res>  {
  factory $ForumReplyDtoCopyWith(ForumReplyDto value, $Res Function(ForumReplyDto) _then) = _$ForumReplyDtoCopyWithImpl;
@useResult
$Res call({
 String id, String postId, String authorId, String authorName, String body, int createdAtMs, List<String> likedBy, List<String> reportedBy
});




}
/// @nodoc
class _$ForumReplyDtoCopyWithImpl<$Res>
    implements $ForumReplyDtoCopyWith<$Res> {
  _$ForumReplyDtoCopyWithImpl(this._self, this._then);

  final ForumReplyDto _self;
  final $Res Function(ForumReplyDto) _then;

/// Create a copy of ForumReplyDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? authorId = null,Object? authorName = null,Object? body = null,Object? createdAtMs = null,Object? likedBy = null,Object? reportedBy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,likedBy: null == likedBy ? _self.likedBy : likedBy // ignore: cast_nullable_to_non_nullable
as List<String>,reportedBy: null == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ForumReplyDto].
extension ForumReplyDtoPatterns on ForumReplyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumReplyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumReplyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumReplyDto value)  $default,){
final _that = this;
switch (_that) {
case _ForumReplyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumReplyDto value)?  $default,){
final _that = this;
switch (_that) {
case _ForumReplyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String postId,  String authorId,  String authorName,  String body,  int createdAtMs,  List<String> likedBy,  List<String> reportedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumReplyDto() when $default != null:
return $default(_that.id,_that.postId,_that.authorId,_that.authorName,_that.body,_that.createdAtMs,_that.likedBy,_that.reportedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String postId,  String authorId,  String authorName,  String body,  int createdAtMs,  List<String> likedBy,  List<String> reportedBy)  $default,) {final _that = this;
switch (_that) {
case _ForumReplyDto():
return $default(_that.id,_that.postId,_that.authorId,_that.authorName,_that.body,_that.createdAtMs,_that.likedBy,_that.reportedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String postId,  String authorId,  String authorName,  String body,  int createdAtMs,  List<String> likedBy,  List<String> reportedBy)?  $default,) {final _that = this;
switch (_that) {
case _ForumReplyDto() when $default != null:
return $default(_that.id,_that.postId,_that.authorId,_that.authorName,_that.body,_that.createdAtMs,_that.likedBy,_that.reportedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForumReplyDto extends ForumReplyDto {
  const _ForumReplyDto({required this.id, required this.postId, required this.authorId, required this.authorName, required this.body, required this.createdAtMs, final  List<String> likedBy = const [], final  List<String> reportedBy = const []}): _likedBy = likedBy,_reportedBy = reportedBy,super._();
  factory _ForumReplyDto.fromJson(Map<String, dynamic> json) => _$ForumReplyDtoFromJson(json);

@override final  String id;
@override final  String postId;
@override final  String authorId;
@override final  String authorName;
@override final  String body;
@override final  int createdAtMs;
 final  List<String> _likedBy;
@override@JsonKey() List<String> get likedBy {
  if (_likedBy is EqualUnmodifiableListView) return _likedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_likedBy);
}

 final  List<String> _reportedBy;
@override@JsonKey() List<String> get reportedBy {
  if (_reportedBy is EqualUnmodifiableListView) return _reportedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reportedBy);
}


/// Create a copy of ForumReplyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumReplyDtoCopyWith<_ForumReplyDto> get copyWith => __$ForumReplyDtoCopyWithImpl<_ForumReplyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForumReplyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumReplyDto&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&const DeepCollectionEquality().equals(other._likedBy, _likedBy)&&const DeepCollectionEquality().equals(other._reportedBy, _reportedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,authorId,authorName,body,createdAtMs,const DeepCollectionEquality().hash(_likedBy),const DeepCollectionEquality().hash(_reportedBy));

@override
String toString() {
  return 'ForumReplyDto(id: $id, postId: $postId, authorId: $authorId, authorName: $authorName, body: $body, createdAtMs: $createdAtMs, likedBy: $likedBy, reportedBy: $reportedBy)';
}


}

/// @nodoc
abstract mixin class _$ForumReplyDtoCopyWith<$Res> implements $ForumReplyDtoCopyWith<$Res> {
  factory _$ForumReplyDtoCopyWith(_ForumReplyDto value, $Res Function(_ForumReplyDto) _then) = __$ForumReplyDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String postId, String authorId, String authorName, String body, int createdAtMs, List<String> likedBy, List<String> reportedBy
});




}
/// @nodoc
class __$ForumReplyDtoCopyWithImpl<$Res>
    implements _$ForumReplyDtoCopyWith<$Res> {
  __$ForumReplyDtoCopyWithImpl(this._self, this._then);

  final _ForumReplyDto _self;
  final $Res Function(_ForumReplyDto) _then;

/// Create a copy of ForumReplyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? authorId = null,Object? authorName = null,Object? body = null,Object? createdAtMs = null,Object? likedBy = null,Object? reportedBy = null,}) {
  return _then(_ForumReplyDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,likedBy: null == likedBy ? _self._likedBy : likedBy // ignore: cast_nullable_to_non_nullable
as List<String>,reportedBy: null == reportedBy ? _self._reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
