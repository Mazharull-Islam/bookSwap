// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookReview {

/// The loan's request id — a borrower can review a returned loan once,
/// and the rules verify against that request, so this doubles as the
/// document id.
 String get id; String get requestId; String get reviewerId; String get reviewerName; String get bookId; String get bookTitle;/// Same shape as discovery's grouping key (work key, else title|author),
/// so reviews follow the book across editions and owners.
 String get matchKey;/// 1-5.
 int get rating; String get text; int get createdAtMs; int get updatedAtMs;
/// Create a copy of BookReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookReviewCopyWith<BookReview> get copyWith => _$BookReviewCopyWithImpl<BookReview>(this as BookReview, _$identity);

  /// Serializes this BookReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookReview&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.reviewerId, reviewerId) || other.reviewerId == reviewerId)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,reviewerId,reviewerName,bookId,bookTitle,matchKey,rating,text,createdAtMs,updatedAtMs);

@override
String toString() {
  return 'BookReview(id: $id, requestId: $requestId, reviewerId: $reviewerId, reviewerName: $reviewerName, bookId: $bookId, bookTitle: $bookTitle, matchKey: $matchKey, rating: $rating, text: $text, createdAtMs: $createdAtMs, updatedAtMs: $updatedAtMs)';
}


}

/// @nodoc
abstract mixin class $BookReviewCopyWith<$Res>  {
  factory $BookReviewCopyWith(BookReview value, $Res Function(BookReview) _then) = _$BookReviewCopyWithImpl;
@useResult
$Res call({
 String id, String requestId, String reviewerId, String reviewerName, String bookId, String bookTitle, String matchKey, int rating, String text, int createdAtMs, int updatedAtMs
});




}
/// @nodoc
class _$BookReviewCopyWithImpl<$Res>
    implements $BookReviewCopyWith<$Res> {
  _$BookReviewCopyWithImpl(this._self, this._then);

  final BookReview _self;
  final $Res Function(BookReview) _then;

/// Create a copy of BookReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestId = null,Object? reviewerId = null,Object? reviewerName = null,Object? bookId = null,Object? bookTitle = null,Object? matchKey = null,Object? rating = null,Object? text = null,Object? createdAtMs = null,Object? updatedAtMs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,reviewerId: null == reviewerId ? _self.reviewerId : reviewerId // ignore: cast_nullable_to_non_nullable
as String,reviewerName: null == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,updatedAtMs: null == updatedAtMs ? _self.updatedAtMs : updatedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookReview].
extension BookReviewPatterns on BookReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookReview value)  $default,){
final _that = this;
switch (_that) {
case _BookReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookReview value)?  $default,){
final _that = this;
switch (_that) {
case _BookReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requestId,  String reviewerId,  String reviewerName,  String bookId,  String bookTitle,  String matchKey,  int rating,  String text,  int createdAtMs,  int updatedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookReview() when $default != null:
return $default(_that.id,_that.requestId,_that.reviewerId,_that.reviewerName,_that.bookId,_that.bookTitle,_that.matchKey,_that.rating,_that.text,_that.createdAtMs,_that.updatedAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requestId,  String reviewerId,  String reviewerName,  String bookId,  String bookTitle,  String matchKey,  int rating,  String text,  int createdAtMs,  int updatedAtMs)  $default,) {final _that = this;
switch (_that) {
case _BookReview():
return $default(_that.id,_that.requestId,_that.reviewerId,_that.reviewerName,_that.bookId,_that.bookTitle,_that.matchKey,_that.rating,_that.text,_that.createdAtMs,_that.updatedAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requestId,  String reviewerId,  String reviewerName,  String bookId,  String bookTitle,  String matchKey,  int rating,  String text,  int createdAtMs,  int updatedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _BookReview() when $default != null:
return $default(_that.id,_that.requestId,_that.reviewerId,_that.reviewerName,_that.bookId,_that.bookTitle,_that.matchKey,_that.rating,_that.text,_that.createdAtMs,_that.updatedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookReview implements BookReview {
  const _BookReview({required this.id, required this.requestId, required this.reviewerId, required this.reviewerName, required this.bookId, required this.bookTitle, required this.matchKey, required this.rating, this.text = '', required this.createdAtMs, required this.updatedAtMs});
  factory _BookReview.fromJson(Map<String, dynamic> json) => _$BookReviewFromJson(json);

/// The loan's request id — a borrower can review a returned loan once,
/// and the rules verify against that request, so this doubles as the
/// document id.
@override final  String id;
@override final  String requestId;
@override final  String reviewerId;
@override final  String reviewerName;
@override final  String bookId;
@override final  String bookTitle;
/// Same shape as discovery's grouping key (work key, else title|author),
/// so reviews follow the book across editions and owners.
@override final  String matchKey;
/// 1-5.
@override final  int rating;
@override@JsonKey() final  String text;
@override final  int createdAtMs;
@override final  int updatedAtMs;

/// Create a copy of BookReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookReviewCopyWith<_BookReview> get copyWith => __$BookReviewCopyWithImpl<_BookReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookReview&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.reviewerId, reviewerId) || other.reviewerId == reviewerId)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,reviewerId,reviewerName,bookId,bookTitle,matchKey,rating,text,createdAtMs,updatedAtMs);

@override
String toString() {
  return 'BookReview(id: $id, requestId: $requestId, reviewerId: $reviewerId, reviewerName: $reviewerName, bookId: $bookId, bookTitle: $bookTitle, matchKey: $matchKey, rating: $rating, text: $text, createdAtMs: $createdAtMs, updatedAtMs: $updatedAtMs)';
}


}

/// @nodoc
abstract mixin class _$BookReviewCopyWith<$Res> implements $BookReviewCopyWith<$Res> {
  factory _$BookReviewCopyWith(_BookReview value, $Res Function(_BookReview) _then) = __$BookReviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String requestId, String reviewerId, String reviewerName, String bookId, String bookTitle, String matchKey, int rating, String text, int createdAtMs, int updatedAtMs
});




}
/// @nodoc
class __$BookReviewCopyWithImpl<$Res>
    implements _$BookReviewCopyWith<$Res> {
  __$BookReviewCopyWithImpl(this._self, this._then);

  final _BookReview _self;
  final $Res Function(_BookReview) _then;

/// Create a copy of BookReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = null,Object? reviewerId = null,Object? reviewerName = null,Object? bookId = null,Object? bookTitle = null,Object? matchKey = null,Object? rating = null,Object? text = null,Object? createdAtMs = null,Object? updatedAtMs = null,}) {
  return _then(_BookReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,reviewerId: null == reviewerId ? _self.reviewerId : reviewerId // ignore: cast_nullable_to_non_nullable
as String,reviewerName: null == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,updatedAtMs: null == updatedAtMs ? _self.updatedAtMs : updatedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
