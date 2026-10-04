// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingEntry {

 String get id; String get userId; String get title; String get author;/// Comma-joined, same convention as [Book.genre] — feeds the "genres
/// explored" stat. Populated from search metadata at add time.
 String get genre; String? get publishedYear;/// Synopsis, fetched from Open Library the same way `AddBookPage` does.
/// Best-effort: added asynchronously after the entry itself, so it may
/// briefly be empty right after adding.
 String get description; String? get coverUrl; String? get workKey; ReadingStatus get status;/// 1-5. Only meaningful once [status] is [ReadingStatus.read] — the UI
/// clears it if the status is changed away from Read.
 int? get rating; String get review; int get updatedAtMs;/// Set when the member removes the entry. Kept rather than deleted so the
/// removal syncs to the member's other devices; every reader ignores
/// entries with this set, and old ones are purged locally after a while.
 int? get deletedAtMs;
/// Create a copy of ReadingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingEntryCopyWith<ReadingEntry> get copyWith => _$ReadingEntryCopyWithImpl<ReadingEntry>(this as ReadingEntry, _$identity);

  /// Serializes this ReadingEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.publishedYear, publishedYear) || other.publishedYear == publishedYear)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.review, review) || other.review == review)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs)&&(identical(other.deletedAtMs, deletedAtMs) || other.deletedAtMs == deletedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,author,genre,publishedYear,description,coverUrl,workKey,status,rating,review,updatedAtMs,deletedAtMs);

@override
String toString() {
  return 'ReadingEntry(id: $id, userId: $userId, title: $title, author: $author, genre: $genre, publishedYear: $publishedYear, description: $description, coverUrl: $coverUrl, workKey: $workKey, status: $status, rating: $rating, review: $review, updatedAtMs: $updatedAtMs, deletedAtMs: $deletedAtMs)';
}


}

/// @nodoc
abstract mixin class $ReadingEntryCopyWith<$Res>  {
  factory $ReadingEntryCopyWith(ReadingEntry value, $Res Function(ReadingEntry) _then) = _$ReadingEntryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String author, String genre, String? publishedYear, String description, String? coverUrl, String? workKey, ReadingStatus status, int? rating, String review, int updatedAtMs, int? deletedAtMs
});




}
/// @nodoc
class _$ReadingEntryCopyWithImpl<$Res>
    implements $ReadingEntryCopyWith<$Res> {
  _$ReadingEntryCopyWithImpl(this._self, this._then);

  final ReadingEntry _self;
  final $Res Function(ReadingEntry) _then;

/// Create a copy of ReadingEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? author = null,Object? genre = null,Object? publishedYear = freezed,Object? description = null,Object? coverUrl = freezed,Object? workKey = freezed,Object? status = null,Object? rating = freezed,Object? review = null,Object? updatedAtMs = null,Object? deletedAtMs = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,publishedYear: freezed == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,review: null == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String,updatedAtMs: null == updatedAtMs ? _self.updatedAtMs : updatedAtMs // ignore: cast_nullable_to_non_nullable
as int,deletedAtMs: freezed == deletedAtMs ? _self.deletedAtMs : deletedAtMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingEntry].
extension ReadingEntryPatterns on ReadingEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingEntry value)  $default,){
final _that = this;
switch (_that) {
case _ReadingEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String author,  String genre,  String? publishedYear,  String description,  String? coverUrl,  String? workKey,  ReadingStatus status,  int? rating,  String review,  int updatedAtMs,  int? deletedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingEntry() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.author,_that.genre,_that.publishedYear,_that.description,_that.coverUrl,_that.workKey,_that.status,_that.rating,_that.review,_that.updatedAtMs,_that.deletedAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String author,  String genre,  String? publishedYear,  String description,  String? coverUrl,  String? workKey,  ReadingStatus status,  int? rating,  String review,  int updatedAtMs,  int? deletedAtMs)  $default,) {final _that = this;
switch (_that) {
case _ReadingEntry():
return $default(_that.id,_that.userId,_that.title,_that.author,_that.genre,_that.publishedYear,_that.description,_that.coverUrl,_that.workKey,_that.status,_that.rating,_that.review,_that.updatedAtMs,_that.deletedAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String author,  String genre,  String? publishedYear,  String description,  String? coverUrl,  String? workKey,  ReadingStatus status,  int? rating,  String review,  int updatedAtMs,  int? deletedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _ReadingEntry() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.author,_that.genre,_that.publishedYear,_that.description,_that.coverUrl,_that.workKey,_that.status,_that.rating,_that.review,_that.updatedAtMs,_that.deletedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingEntry implements ReadingEntry {
  const _ReadingEntry({required this.id, required this.userId, required this.title, this.author = '', this.genre = '', this.publishedYear, this.description = '', this.coverUrl, this.workKey, this.status = ReadingStatus.planToRead, this.rating, this.review = '', required this.updatedAtMs, this.deletedAtMs});
  factory _ReadingEntry.fromJson(Map<String, dynamic> json) => _$ReadingEntryFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override@JsonKey() final  String author;
/// Comma-joined, same convention as [Book.genre] — feeds the "genres
/// explored" stat. Populated from search metadata at add time.
@override@JsonKey() final  String genre;
@override final  String? publishedYear;
/// Synopsis, fetched from Open Library the same way `AddBookPage` does.
/// Best-effort: added asynchronously after the entry itself, so it may
/// briefly be empty right after adding.
@override@JsonKey() final  String description;
@override final  String? coverUrl;
@override final  String? workKey;
@override@JsonKey() final  ReadingStatus status;
/// 1-5. Only meaningful once [status] is [ReadingStatus.read] — the UI
/// clears it if the status is changed away from Read.
@override final  int? rating;
@override@JsonKey() final  String review;
@override final  int updatedAtMs;
/// Set when the member removes the entry. Kept rather than deleted so the
/// removal syncs to the member's other devices; every reader ignores
/// entries with this set, and old ones are purged locally after a while.
@override final  int? deletedAtMs;

/// Create a copy of ReadingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingEntryCopyWith<_ReadingEntry> get copyWith => __$ReadingEntryCopyWithImpl<_ReadingEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.publishedYear, publishedYear) || other.publishedYear == publishedYear)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.review, review) || other.review == review)&&(identical(other.updatedAtMs, updatedAtMs) || other.updatedAtMs == updatedAtMs)&&(identical(other.deletedAtMs, deletedAtMs) || other.deletedAtMs == deletedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,author,genre,publishedYear,description,coverUrl,workKey,status,rating,review,updatedAtMs,deletedAtMs);

@override
String toString() {
  return 'ReadingEntry(id: $id, userId: $userId, title: $title, author: $author, genre: $genre, publishedYear: $publishedYear, description: $description, coverUrl: $coverUrl, workKey: $workKey, status: $status, rating: $rating, review: $review, updatedAtMs: $updatedAtMs, deletedAtMs: $deletedAtMs)';
}


}

/// @nodoc
abstract mixin class _$ReadingEntryCopyWith<$Res> implements $ReadingEntryCopyWith<$Res> {
  factory _$ReadingEntryCopyWith(_ReadingEntry value, $Res Function(_ReadingEntry) _then) = __$ReadingEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String author, String genre, String? publishedYear, String description, String? coverUrl, String? workKey, ReadingStatus status, int? rating, String review, int updatedAtMs, int? deletedAtMs
});




}
/// @nodoc
class __$ReadingEntryCopyWithImpl<$Res>
    implements _$ReadingEntryCopyWith<$Res> {
  __$ReadingEntryCopyWithImpl(this._self, this._then);

  final _ReadingEntry _self;
  final $Res Function(_ReadingEntry) _then;

/// Create a copy of ReadingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? author = null,Object? genre = null,Object? publishedYear = freezed,Object? description = null,Object? coverUrl = freezed,Object? workKey = freezed,Object? status = null,Object? rating = freezed,Object? review = null,Object? updatedAtMs = null,Object? deletedAtMs = freezed,}) {
  return _then(_ReadingEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,publishedYear: freezed == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,review: null == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String,updatedAtMs: null == updatedAtMs ? _self.updatedAtMs : updatedAtMs // ignore: cast_nullable_to_non_nullable
as int,deletedAtMs: freezed == deletedAtMs ? _self.deletedAtMs : deletedAtMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
