// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forum_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForumPost {

 String get id; String get authorId; String get authorName; String get title; String get body; String? get genre; int get createdAtMs; List<String> get likedBy;/// Add-only — no "un-report." Non-empty means hidden from the general
/// feed (SRS §3.7's moderation-latency requirement), with no reviewer
/// role/UI to restore it — a deliberate, flagged gap for this pass.
 List<String> get reportedBy; int get replyCount;
/// Create a copy of ForumPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumPostCopyWith<ForumPost> get copyWith => _$ForumPostCopyWithImpl<ForumPost>(this as ForumPost, _$identity);

  /// Serializes this ForumPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumPost&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&const DeepCollectionEquality().equals(other.likedBy, likedBy)&&const DeepCollectionEquality().equals(other.reportedBy, reportedBy)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorId,authorName,title,body,genre,createdAtMs,const DeepCollectionEquality().hash(likedBy),const DeepCollectionEquality().hash(reportedBy),replyCount);

@override
String toString() {
  return 'ForumPost(id: $id, authorId: $authorId, authorName: $authorName, title: $title, body: $body, genre: $genre, createdAtMs: $createdAtMs, likedBy: $likedBy, reportedBy: $reportedBy, replyCount: $replyCount)';
}


}

/// @nodoc
abstract mixin class $ForumPostCopyWith<$Res>  {
  factory $ForumPostCopyWith(ForumPost value, $Res Function(ForumPost) _then) = _$ForumPostCopyWithImpl;
@useResult
$Res call({
 String id, String authorId, String authorName, String title, String body, String? genre, int createdAtMs, List<String> likedBy, List<String> reportedBy, int replyCount
});




}
/// @nodoc
class _$ForumPostCopyWithImpl<$Res>
    implements $ForumPostCopyWith<$Res> {
  _$ForumPostCopyWithImpl(this._self, this._then);

  final ForumPost _self;
  final $Res Function(ForumPost) _then;

/// Create a copy of ForumPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? authorName = null,Object? title = null,Object? body = null,Object? genre = freezed,Object? createdAtMs = null,Object? likedBy = null,Object? reportedBy = null,Object? replyCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,likedBy: null == likedBy ? _self.likedBy : likedBy // ignore: cast_nullable_to_non_nullable
as List<String>,reportedBy: null == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as List<String>,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ForumPost].
extension ForumPostPatterns on ForumPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumPost value)  $default,){
final _that = this;
switch (_that) {
case _ForumPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumPost value)?  $default,){
final _that = this;
switch (_that) {
case _ForumPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId,  String authorName,  String title,  String body,  String? genre,  int createdAtMs,  List<String> likedBy,  List<String> reportedBy,  int replyCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumPost() when $default != null:
return $default(_that.id,_that.authorId,_that.authorName,_that.title,_that.body,_that.genre,_that.createdAtMs,_that.likedBy,_that.reportedBy,_that.replyCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId,  String authorName,  String title,  String body,  String? genre,  int createdAtMs,  List<String> likedBy,  List<String> reportedBy,  int replyCount)  $default,) {final _that = this;
switch (_that) {
case _ForumPost():
return $default(_that.id,_that.authorId,_that.authorName,_that.title,_that.body,_that.genre,_that.createdAtMs,_that.likedBy,_that.reportedBy,_that.replyCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId,  String authorName,  String title,  String body,  String? genre,  int createdAtMs,  List<String> likedBy,  List<String> reportedBy,  int replyCount)?  $default,) {final _that = this;
switch (_that) {
case _ForumPost() when $default != null:
return $default(_that.id,_that.authorId,_that.authorName,_that.title,_that.body,_that.genre,_that.createdAtMs,_that.likedBy,_that.reportedBy,_that.replyCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForumPost extends ForumPost {
  const _ForumPost({required this.id, required this.authorId, required this.authorName, required this.title, required this.body, this.genre, required this.createdAtMs, final  List<String> likedBy = const [], final  List<String> reportedBy = const [], this.replyCount = 0}): _likedBy = likedBy,_reportedBy = reportedBy,super._();
  factory _ForumPost.fromJson(Map<String, dynamic> json) => _$ForumPostFromJson(json);

@override final  String id;
@override final  String authorId;
@override final  String authorName;
@override final  String title;
@override final  String body;
@override final  String? genre;
@override final  int createdAtMs;
 final  List<String> _likedBy;
@override@JsonKey() List<String> get likedBy {
  if (_likedBy is EqualUnmodifiableListView) return _likedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_likedBy);
}

/// Add-only — no "un-report." Non-empty means hidden from the general
/// feed (SRS §3.7's moderation-latency requirement), with no reviewer
/// role/UI to restore it — a deliberate, flagged gap for this pass.
 final  List<String> _reportedBy;
/// Add-only — no "un-report." Non-empty means hidden from the general
/// feed (SRS §3.7's moderation-latency requirement), with no reviewer
/// role/UI to restore it — a deliberate, flagged gap for this pass.
@override@JsonKey() List<String> get reportedBy {
  if (_reportedBy is EqualUnmodifiableListView) return _reportedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reportedBy);
}

@override@JsonKey() final  int replyCount;

/// Create a copy of ForumPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumPostCopyWith<_ForumPost> get copyWith => __$ForumPostCopyWithImpl<_ForumPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForumPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumPost&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&const DeepCollectionEquality().equals(other._likedBy, _likedBy)&&const DeepCollectionEquality().equals(other._reportedBy, _reportedBy)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorId,authorName,title,body,genre,createdAtMs,const DeepCollectionEquality().hash(_likedBy),const DeepCollectionEquality().hash(_reportedBy),replyCount);

@override
String toString() {
  return 'ForumPost(id: $id, authorId: $authorId, authorName: $authorName, title: $title, body: $body, genre: $genre, createdAtMs: $createdAtMs, likedBy: $likedBy, reportedBy: $reportedBy, replyCount: $replyCount)';
}


}

/// @nodoc
abstract mixin class _$ForumPostCopyWith<$Res> implements $ForumPostCopyWith<$Res> {
  factory _$ForumPostCopyWith(_ForumPost value, $Res Function(_ForumPost) _then) = __$ForumPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId, String authorName, String title, String body, String? genre, int createdAtMs, List<String> likedBy, List<String> reportedBy, int replyCount
});




}
/// @nodoc
class __$ForumPostCopyWithImpl<$Res>
    implements _$ForumPostCopyWith<$Res> {
  __$ForumPostCopyWithImpl(this._self, this._then);

  final _ForumPost _self;
  final $Res Function(_ForumPost) _then;

/// Create a copy of ForumPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? authorName = null,Object? title = null,Object? body = null,Object? genre = freezed,Object? createdAtMs = null,Object? likedBy = null,Object? reportedBy = null,Object? replyCount = null,}) {
  return _then(_ForumPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,likedBy: null == likedBy ? _self._likedBy : likedBy // ignore: cast_nullable_to_non_nullable
as List<String>,reportedBy: null == reportedBy ? _self._reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as List<String>,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
