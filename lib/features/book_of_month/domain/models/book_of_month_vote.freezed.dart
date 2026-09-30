// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_of_month_vote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookOfMonthVote {

/// '${periodId}_${userId}' — one vote per user per period. Voting for
/// a different nominee overwrites this same doc, so a user can never
/// hold more than one active vote in a period.
 String get id; String get periodId; String get userId; String get matchKey; int get votedAtMs;
/// Create a copy of BookOfMonthVote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookOfMonthVoteCopyWith<BookOfMonthVote> get copyWith => _$BookOfMonthVoteCopyWithImpl<BookOfMonthVote>(this as BookOfMonthVote, _$identity);

  /// Serializes this BookOfMonthVote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookOfMonthVote&&(identical(other.id, id) || other.id == id)&&(identical(other.periodId, periodId) || other.periodId == periodId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.votedAtMs, votedAtMs) || other.votedAtMs == votedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodId,userId,matchKey,votedAtMs);

@override
String toString() {
  return 'BookOfMonthVote(id: $id, periodId: $periodId, userId: $userId, matchKey: $matchKey, votedAtMs: $votedAtMs)';
}


}

/// @nodoc
abstract mixin class $BookOfMonthVoteCopyWith<$Res>  {
  factory $BookOfMonthVoteCopyWith(BookOfMonthVote value, $Res Function(BookOfMonthVote) _then) = _$BookOfMonthVoteCopyWithImpl;
@useResult
$Res call({
 String id, String periodId, String userId, String matchKey, int votedAtMs
});




}
/// @nodoc
class _$BookOfMonthVoteCopyWithImpl<$Res>
    implements $BookOfMonthVoteCopyWith<$Res> {
  _$BookOfMonthVoteCopyWithImpl(this._self, this._then);

  final BookOfMonthVote _self;
  final $Res Function(BookOfMonthVote) _then;

/// Create a copy of BookOfMonthVote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? periodId = null,Object? userId = null,Object? matchKey = null,Object? votedAtMs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,periodId: null == periodId ? _self.periodId : periodId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,votedAtMs: null == votedAtMs ? _self.votedAtMs : votedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookOfMonthVote].
extension BookOfMonthVotePatterns on BookOfMonthVote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookOfMonthVote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookOfMonthVote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookOfMonthVote value)  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthVote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookOfMonthVote value)?  $default,){
final _that = this;
switch (_that) {
case _BookOfMonthVote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String periodId,  String userId,  String matchKey,  int votedAtMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookOfMonthVote() when $default != null:
return $default(_that.id,_that.periodId,_that.userId,_that.matchKey,_that.votedAtMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String periodId,  String userId,  String matchKey,  int votedAtMs)  $default,) {final _that = this;
switch (_that) {
case _BookOfMonthVote():
return $default(_that.id,_that.periodId,_that.userId,_that.matchKey,_that.votedAtMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String periodId,  String userId,  String matchKey,  int votedAtMs)?  $default,) {final _that = this;
switch (_that) {
case _BookOfMonthVote() when $default != null:
return $default(_that.id,_that.periodId,_that.userId,_that.matchKey,_that.votedAtMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookOfMonthVote implements BookOfMonthVote {
  const _BookOfMonthVote({required this.id, required this.periodId, required this.userId, required this.matchKey, required this.votedAtMs});
  factory _BookOfMonthVote.fromJson(Map<String, dynamic> json) => _$BookOfMonthVoteFromJson(json);

/// '${periodId}_${userId}' — one vote per user per period. Voting for
/// a different nominee overwrites this same doc, so a user can never
/// hold more than one active vote in a period.
@override final  String id;
@override final  String periodId;
@override final  String userId;
@override final  String matchKey;
@override final  int votedAtMs;

/// Create a copy of BookOfMonthVote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookOfMonthVoteCopyWith<_BookOfMonthVote> get copyWith => __$BookOfMonthVoteCopyWithImpl<_BookOfMonthVote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookOfMonthVoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookOfMonthVote&&(identical(other.id, id) || other.id == id)&&(identical(other.periodId, periodId) || other.periodId == periodId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.votedAtMs, votedAtMs) || other.votedAtMs == votedAtMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,periodId,userId,matchKey,votedAtMs);

@override
String toString() {
  return 'BookOfMonthVote(id: $id, periodId: $periodId, userId: $userId, matchKey: $matchKey, votedAtMs: $votedAtMs)';
}


}

/// @nodoc
abstract mixin class _$BookOfMonthVoteCopyWith<$Res> implements $BookOfMonthVoteCopyWith<$Res> {
  factory _$BookOfMonthVoteCopyWith(_BookOfMonthVote value, $Res Function(_BookOfMonthVote) _then) = __$BookOfMonthVoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String periodId, String userId, String matchKey, int votedAtMs
});




}
/// @nodoc
class __$BookOfMonthVoteCopyWithImpl<$Res>
    implements _$BookOfMonthVoteCopyWith<$Res> {
  __$BookOfMonthVoteCopyWithImpl(this._self, this._then);

  final _BookOfMonthVote _self;
  final $Res Function(_BookOfMonthVote) _then;

/// Create a copy of BookOfMonthVote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? periodId = null,Object? userId = null,Object? matchKey = null,Object? votedAtMs = null,}) {
  return _then(_BookOfMonthVote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,periodId: null == periodId ? _self.periodId : periodId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,matchKey: null == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String,votedAtMs: null == votedAtMs ? _self.votedAtMs : votedAtMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
