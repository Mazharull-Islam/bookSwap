// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_of_month_nomination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookOfMonthNomination {

/// '${periodId}_${matchKey}' — deterministic so nominating the same
/// book twice in the same period is a no-op (checked client-side)
/// rather than a duplicate competing entry that splits votes.
 String get id; String get periodId; String get matchKey; String get title; String get author; String? get coverUrl; String? get workKey; String? get genre; String get nominatedBy; String get nominatedByName; int get nominatedAtMs;
/// Create a copy of BookOfMonthNomination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookOfMonthNominationCopyWith<BookOfMonthNomination> get copyWith => _$BookOfMonthNominationCopyWithImpl<BookOfMonthNomination>(this as BookOfMonthNomination, _$identity);

  /// Serializes this BookOfMonthNomination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookOfMonthNomination&&(identical(other.id, id) || other.id == id)&&(identical(other.periodId, periodId) || other.periodId == periodId)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.nominatedBy, nominatedBy) || other.nominatedBy == nominatedBy)&&(identical(other.nominatedByName, nominatedByName) || other.nominatedByName == nominatedByName)&&(identical(other.nominatedAtMs, nominatedAtMs) || other.nominatedAtMs == nominatedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodId,matchKey,title,author,coverUrl,workKey,genre,nominatedBy,nominatedByName,nominatedAtMs);

@override
String toString() {
  return 'BookOfMonthNomination(id: $id, periodId: $periodId, matchKey: $matchKey, title: $title, author: $author, coverUrl: $coverUrl, workKey: $workKey, genre: $genre, nominatedBy: $nominatedBy, nominatedByName: $nominatedByName, nominatedAtMs: $nominatedAtMs)';
}


}

/// @nodoc
abstract mixin class $BookOfMonthNominationCopyWith<$Res>  {
  factory $BookOfMonthNominationCopyWith(BookOfMonthNomination value, $Res Function(BookOfMonthNomination) _then) = _$BookOfMonthNominationCopyWithImpl;
@useResult
$Res call({
 String id, String periodId, String matchKey, String title, String author, String? coverUrl, String? workKey, String? genre, String nominatedBy, String nominatedByName, int nominatedAtMs
});




}
/// @nodoc
class _$BookOfMonthNominationCopyWithImpl<$Res>
    implements $BookOfMonthNominationCopyWith<$Res> {
  _$BookOfMonthNominationCopyWithImpl(this._self, this._then);

  final BookOfMonthNomination _self;
  final $Res Function(BookOfMonthNomination) _then;

/// Create a copy of BookOfMonthNomination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? periodId = null,Object? matchKey = null,Object? title = null,Object? author = null,Object? coverUrl = freezed,Object? workKey = freezed,Object? genre = freezed,Object? nominatedBy = null,Object? nominatedByName = null,Object? nominatedAtMs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,periodId: null == periodId ? _self.periodId : periodId // ignore: cast_nullable_to_non_nullable
as String,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,nominatedBy: null == nominatedBy ? _self.nominatedBy : nominatedBy // ignore: cast_nullable_to_non_nullable
as String,nominatedByName: null == nominatedByName ? _self.nominatedByName : nominatedByName // ignore: cast_nullable_to_non_nullable
as String,nominatedAtMs: null == nominatedAtMs ? _self.nominatedAtMs : nominatedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookOfMonthNomination].
extension BookOfMonthNominationPatterns on BookOfMonthNomination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookOfMonthNomination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookOfMonthNomination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookOfMonthNomination value)  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthNomination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookOfMonthNomination value)?  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthNomination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String periodId,  String matchKey,  String title,  String author,  String? coverUrl,  String? workKey,  String? genre,  String nominatedBy,  String nominatedByName,  int nominatedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookOfMonthNomination() when $default != null:
return $default(_that.id,_that.periodId,_that.matchKey,_that.title,_that.author,_that.coverUrl,_that.workKey,_that.genre,_that.nominatedBy,_that.nominatedByName,_that.nominatedAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String periodId,  String matchKey,  String title,  String author,  String? coverUrl,  String? workKey,  String? genre,  String nominatedBy,  String nominatedByName,  int nominatedAtMs)  $default,) {final _that = this;
switch (_that) {
case _BookOfMonthNomination():
return $default(_that.id,_that.periodId,_that.matchKey,_that.title,_that.author,_that.coverUrl,_that.workKey,_that.genre,_that.nominatedBy,_that.nominatedByName,_that.nominatedAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String periodId,  String matchKey,  String title,  String author,  String? coverUrl,  String? workKey,  String? genre,  String nominatedBy,  String nominatedByName,  int nominatedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _BookOfMonthNomination() when $default != null:
return $default(_that.id,_that.periodId,_that.matchKey,_that.title,_that.author,_that.coverUrl,_that.workKey,_that.genre,_that.nominatedBy,_that.nominatedByName,_that.nominatedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookOfMonthNomination implements BookOfMonthNomination {
  const _BookOfMonthNomination({required this.id, required this.periodId, required this.matchKey, required this.title, this.author = '', this.coverUrl, this.workKey, this.genre, required this.nominatedBy, required this.nominatedByName, required this.nominatedAtMs});
  factory _BookOfMonthNomination.fromJson(Map<String, dynamic> json) => _$BookOfMonthNominationFromJson(json);

/// '${periodId}_${matchKey}' — deterministic so nominating the same
/// book twice in the same period is a no-op (checked client-side)
/// rather than a duplicate competing entry that splits votes.
@override final  String id;
@override final  String periodId;
@override final  String matchKey;
@override final  String title;
@override@JsonKey() final  String author;
@override final  String? coverUrl;
@override final  String? workKey;
@override final  String? genre;
@override final  String nominatedBy;
@override final  String nominatedByName;
@override final  int nominatedAtMs;

/// Create a copy of BookOfMonthNomination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookOfMonthNominationCopyWith<_BookOfMonthNomination> get copyWith => __$BookOfMonthNominationCopyWithImpl<_BookOfMonthNomination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookOfMonthNominationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookOfMonthNomination&&(identical(other.id, id) || other.id == id)&&(identical(other.periodId, periodId) || other.periodId == periodId)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.workKey, workKey) || other.workKey == workKey)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.nominatedBy, nominatedBy) || other.nominatedBy == nominatedBy)&&(identical(other.nominatedByName, nominatedByName) || other.nominatedByName == nominatedByName)&&(identical(other.nominatedAtMs, nominatedAtMs) || other.nominatedAtMs == nominatedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodId,matchKey,title,author,coverUrl,workKey,genre,nominatedBy,nominatedByName,nominatedAtMs);

@override
String toString() {
  return 'BookOfMonthNomination(id: $id, periodId: $periodId, matchKey: $matchKey, title: $title, author: $author, coverUrl: $coverUrl, workKey: $workKey, genre: $genre, nominatedBy: $nominatedBy, nominatedByName: $nominatedByName, nominatedAtMs: $nominatedAtMs)';
}


}

/// @nodoc
abstract mixin class _$BookOfMonthNominationCopyWith<$Res> implements $BookOfMonthNominationCopyWith<$Res> {
  factory _$BookOfMonthNominationCopyWith(_BookOfMonthNomination value, $Res Function(_BookOfMonthNomination) _then) = __$BookOfMonthNominationCopyWithImpl;
@override @useResult
$Res call({
 String id, String periodId, String matchKey, String title, String author, String? coverUrl, String? workKey, String? genre, String nominatedBy, String nominatedByName, int nominatedAtMs
});




}
/// @nodoc
class __$BookOfMonthNominationCopyWithImpl<$Res>
    implements _$BookOfMonthNominationCopyWith<$Res> {
  __$BookOfMonthNominationCopyWithImpl(this._self, this._then);

  final _BookOfMonthNomination _self;
  final $Res Function(_BookOfMonthNomination) _then;

/// Create a copy of BookOfMonthNomination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? periodId = null,Object? matchKey = null,Object? title = null,Object? author = null,Object? coverUrl = freezed,Object? workKey = freezed,Object? genre = freezed,Object? nominatedBy = null,Object? nominatedByName = null,Object? nominatedAtMs = null,}) {
  return _then(_BookOfMonthNomination(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,periodId: null == periodId ? _self.periodId : periodId // ignore: cast_nullable_to_non_nullable
as String,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,workKey: freezed == workKey ? _self.workKey : workKey // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,nominatedBy: null == nominatedBy ? _self.nominatedBy : nominatedBy // ignore: cast_nullable_to_non_nullable
as String,nominatedByName: null == nominatedByName ? _self.nominatedByName : nominatedByName // ignore: cast_nullable_to_non_nullable
as String,nominatedAtMs: null == nominatedAtMs ? _self.nominatedAtMs : nominatedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
