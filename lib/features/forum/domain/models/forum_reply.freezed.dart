// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forum_reply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForumReply {

 String get id; String get postId; String get authorId; String get authorName; String get body; int get createdAtMs; List<String> get likedBy; List<String> get reportedBy;
/// Create a copy of ForumReply
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumReplyCopyWith<ForumReply> get copyWith => _$ForumReplyCopyWithImpl<ForumReply>(this as ForumReply, _$identity);

  /// Serializes this ForumReply to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumReply&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&const DeepCollectionEquality().equals(other.likedBy, likedBy)&&const DeepCollectionEquality().equals(other.reportedBy, reportedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,authorId,authorName,body,createdAtMs,const DeepCollectionEquality().hash(likedBy),const DeepCollectionEquality().hash(reportedBy));

@override
String toString() {
  return 'ForumReply(id: $id, postId: $postId, authorId: $authorId, authorName: $authorName, body: $body, createdAtMs: $createdAtMs, likedBy: $likedBy, reportedBy: $reportedBy)';
}


}

/// @nodoc
abstract mixin class $ForumReplyCopyWith<$Res>  {
  factory $ForumReplyCopyWith(ForumReply value, $Res Function(ForumReply) _then) = _$ForumReplyCopyWithImpl;
@useResult
$Res call({
 String id, String postId, String authorId, String authorName, String body, int createdAtMs, List<String> likedBy, List<String> reportedBy
});




}
/// @nodoc
class _$ForumReplyCopyWithImpl<$Res>
    implements $ForumReplyCopyWith<$Res> {
  _$ForumReplyCopyWithImpl(this._self, this._then);

  final ForumReply _self;
  final $Res Function(ForumReply) _then;

/// Create a copy of ForumReply
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


/// Adds pattern-matching-related methods to [ForumReply].
extension ForumReplyPatterns on ForumReply {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumReply value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumReply() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumReply value)  $default,){
final _that = this;
switch (_that) {
case _ForumReply():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumReply value)?  $default,){
final _that = this;
switch (_that) {
case _ForumReply() when $default != null:
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
case _ForumReply() when $default != null:
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
case _ForumReply():
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
case _ForumReply() when $default != null:
return $default(_that.id,_that.postId,_that.authorId,_that.authorName,_that.body,_that.createdAtMs,_that.likedBy,_that.reportedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForumReply extends ForumReply {
  const _ForumReply({required this.id, required this.postId, required this.authorId, required this.authorName, required this.body, required this.createdAtMs, final  List<String> likedBy = const [], final  List<String> reportedBy = const []}): _likedBy = likedBy,_reportedBy = reportedBy,super._();
  factory _ForumReply.fromJson(Map<String, dynamic> json) => _$ForumReplyFromJson(json);

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


/// Create a copy of ForumReply
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumReplyCopyWith<_ForumReply> get copyWith => __$ForumReplyCopyWithImpl<_ForumReply>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForumReplyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumReply&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&const DeepCollectionEquality().equals(other._likedBy, _likedBy)&&const DeepCollectionEquality().equals(other._reportedBy, _reportedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,authorId,authorName,body,createdAtMs,const DeepCollectionEquality().hash(_likedBy),const DeepCollectionEquality().hash(_reportedBy));

@override
String toString() {
  return 'ForumReply(id: $id, postId: $postId, authorId: $authorId, authorName: $authorName, body: $body, createdAtMs: $createdAtMs, likedBy: $likedBy, reportedBy: $reportedBy)';
}


}

/// @nodoc
abstract mixin class _$ForumReplyCopyWith<$Res> implements $ForumReplyCopyWith<$Res> {
  factory _$ForumReplyCopyWith(_ForumReply value, $Res Function(_ForumReply) _then) = __$ForumReplyCopyWithImpl;
@override @useResult
$Res call({
 String id, String postId, String authorId, String authorName, String body, int createdAtMs, List<String> likedBy, List<String> reportedBy
});




}
/// @nodoc
class __$ForumReplyCopyWithImpl<$Res>
    implements _$ForumReplyCopyWith<$Res> {
  __$ForumReplyCopyWithImpl(this._self, this._then);

  final _ForumReply _self;
  final $Res Function(_ForumReply) _then;

/// Create a copy of ForumReply
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? authorId = null,Object? authorName = null,Object? body = null,Object? createdAtMs = null,Object? likedBy = null,Object? reportedBy = null,}) {
  return _then(_ForumReply(
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
