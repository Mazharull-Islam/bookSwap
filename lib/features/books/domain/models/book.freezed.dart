// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Book {

 String get id; String get ownerId; String get title; String get author; String get genre; String get condition; double get estimatedValue; String get description; String? get coverPhotoUrl; String? get isbn;/// Open Library work key (e.g. "/works/OL82563W"), if this book came
/// from a title-search selection. The canonical identity for matching
/// the "same book" across users/editions — title/author strings alone
/// are unreliable since a single work has many differently-titled or
/// differently-punctuated editions.
 String? get workKey; BookStatus get status;
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.estimatedValue, estimatedValue) || other.estimatedValue == estimatedValue)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverPhotoUrl, coverPhotoUrl) || other.coverPhotoUrl == coverPhotoUrl)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,title,author,genre,condition,estimatedValue,description,coverPhotoUrl,isbn,workKey,status);

@override
String toString() {
  return 'Book(id: $id, ownerId: $ownerId, title: $title, author: $author, genre: $genre, condition: $condition, estimatedValue: $estimatedValue, description: $description, coverPhotoUrl: $coverPhotoUrl, isbn: $isbn, workKey: $workKey, status: $status)';
}


}

/// @nodoc
abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String title, String author, String genre, String condition, double estimatedValue, String description, String? coverPhotoUrl, String? isbn, String? workKey, BookStatus status
});




}
/// @nodoc
class _$BookCopyWithImpl<$Res>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._self, this._then);

  final Book _self;
  final $Res Function(Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? title = null,Object? author = null,Object? genre = null,Object? condition = null,Object? estimatedValue = null,Object? description = null,Object? coverPhotoUrl = freezed,Object? isbn = freezed,Object? workKey = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,estimatedValue: null == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,coverPhotoUrl: freezed == coverPhotoUrl ? _self.coverPhotoUrl : coverPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Book].
extension BookPatterns on Book {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Book value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Book value)  $default,){
final _that = this;
switch (_that) {
case _Book():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Book value)?  $default,){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String title,  String author,  String genre,  String condition,  double estimatedValue,  String description,  String? coverPhotoUrl,  String? isbn,  String? workKey,  BookStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.ownerId,_that.title,_that.author,_that.genre,_that.condition,_that.estimatedValue,_that.description,_that.coverPhotoUrl,_that.isbn,_that.workKey,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String title,  String author,  String genre,  String condition,  double estimatedValue,  String description,  String? coverPhotoUrl,  String? isbn,  String? workKey,  BookStatus status)  $default,) {final _that = this;
switch (_that) {
case _Book():
return $default(_that.id,_that.ownerId,_that.title,_that.author,_that.genre,_that.condition,_that.estimatedValue,_that.description,_that.coverPhotoUrl,_that.isbn,_that.workKey,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String title,  String author,  String genre,  String condition,  double estimatedValue,  String description,  String? coverPhotoUrl,  String? isbn,  String? workKey,  BookStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.ownerId,_that.title,_that.author,_that.genre,_that.condition,_that.estimatedValue,_that.description,_that.coverPhotoUrl,_that.isbn,_that.workKey,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Book extends Book {
  const _Book({required this.id, required this.ownerId, required this.title, required this.author, required this.genre, required this.condition, required this.estimatedValue, this.description = '', this.coverPhotoUrl, this.isbn, this.workKey, this.status = BookStatus.available}): super._();
  factory _Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

@override final  String id;
@override final  String ownerId;
@override final  String title;
@override final  String author;
@override final  String genre;
@override final  String condition;
@override final  double estimatedValue;
@override@JsonKey() final  String description;
@override final  String? coverPhotoUrl;
@override final  String? isbn;
/// Open Library work key (e.g. "/works/OL82563W"), if this book came
/// from a title-search selection. The canonical identity for matching
/// the "same book" across users/editions — title/author strings alone
/// are unreliable since a single work has many differently-titled or
/// differently-punctuated editions.
@override final  String? workKey;
@override@JsonKey() final  BookStatus status;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCopyWith<_Book> get copyWith => __$BookCopyWithImpl<_Book>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.estimatedValue, estimatedValue) || other.estimatedValue == estimatedValue)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverPhotoUrl, coverPhotoUrl) || other.coverPhotoUrl == coverPhotoUrl)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,title,author,genre,condition,estimatedValue,description,coverPhotoUrl,isbn,workKey,status);

@override
String toString() {
  return 'Book(id: $id, ownerId: $ownerId, title: $title, author: $author, genre: $genre, condition: $condition, estimatedValue: $estimatedValue, description: $description, coverPhotoUrl: $coverPhotoUrl, isbn: $isbn, workKey: $workKey, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String title, String author, String genre, String condition, double estimatedValue, String description, String? coverPhotoUrl, String? isbn, String? workKey, BookStatus status
});




}
/// @nodoc
class __$BookCopyWithImpl<$Res>
    implements _$BookCopyWith<$Res> {
  __$BookCopyWithImpl(this._self, this._then);

  final _Book _self;
  final $Res Function(_Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? title = null,Object? author = null,Object? genre = null,Object? condition = null,Object? estimatedValue = null,Object? description = null,Object? coverPhotoUrl = freezed,Object? isbn = freezed,Object? workKey = freezed,Object? status = null,}) {
  return _then(_Book(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,estimatedValue: null == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,coverPhotoUrl: freezed == coverPhotoUrl ? _self.coverPhotoUrl : coverPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookStatus,
  ));
}


}

// dart format on
