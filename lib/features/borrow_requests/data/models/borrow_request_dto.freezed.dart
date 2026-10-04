// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrow_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BorrowRequestDto {

 String get id; String get bookId; String get bookTitle; String? get bookCoverUrl; String get borrowerId; String get lenderId; RequestStatus get status; int get requestedAt; int? get respondedAt; int? get expectedReturnDateMs; String? get borrowerContact; String? get lenderContact; int? get returnedAt; int? get proposedReturnDateMs; String? get conditionOut; String? get conditionIn; String? get borrowerNote;
/// Create a copy of BorrowRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowRequestDtoCopyWith<BorrowRequestDto> get copyWith => _$BorrowRequestDtoCopyWithImpl<BorrowRequestDto>(this as BorrowRequestDto, _$identity);

  /// Serializes this BorrowRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BorrowRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.bookCoverUrl, bookCoverUrl) || other.bookCoverUrl == bookCoverUrl)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.lenderId, lenderId) || other.lenderId == lenderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.expectedReturnDateMs, expectedReturnDateMs) || other.expectedReturnDateMs == expectedReturnDateMs)&&(identical(other.borrowerContact, borrowerContact) || other.borrowerContact == borrowerContact)&&(identical(other.lenderContact, lenderContact) || other.lenderContact == lenderContact)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt)&&(identical(other.proposedReturnDateMs, proposedReturnDateMs) || other.proposedReturnDateMs == proposedReturnDateMs)&&(identical(other.conditionOut, conditionOut) || other.conditionOut == conditionOut)&&(identical(other.conditionIn, conditionIn) || other.conditionIn == conditionIn)&&(identical(other.borrowerNote, borrowerNote) || other.borrowerNote == borrowerNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,bookTitle,bookCoverUrl,borrowerId,lenderId,status,requestedAt,respondedAt,expectedReturnDateMs,borrowerContact,lenderContact,returnedAt,proposedReturnDateMs,conditionOut,conditionIn,borrowerNote);

@override
String toString() {
  return 'BorrowRequestDto(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, borrowerId: $borrowerId, lenderId: $lenderId, status: $status, requestedAt: $requestedAt, respondedAt: $respondedAt, expectedReturnDateMs: $expectedReturnDateMs, borrowerContact: $borrowerContact, lenderContact: $lenderContact, returnedAt: $returnedAt, proposedReturnDateMs: $proposedReturnDateMs, conditionOut: $conditionOut, conditionIn: $conditionIn, borrowerNote: $borrowerNote)';
}


}

/// @nodoc
abstract mixin class $BorrowRequestDtoCopyWith<$Res>  {
  factory $BorrowRequestDtoCopyWith(BorrowRequestDto value, $Res Function(BorrowRequestDto) _then) = _$BorrowRequestDtoCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, String bookTitle, String? bookCoverUrl, String borrowerId, String lenderId, RequestStatus status, int requestedAt, int? respondedAt, int? expectedReturnDateMs, String? borrowerContact, String? lenderContact, int? returnedAt, int? proposedReturnDateMs, String? conditionOut, String? conditionIn, String? borrowerNote
});




}
/// @nodoc
class _$BorrowRequestDtoCopyWithImpl<$Res>
    implements $BorrowRequestDtoCopyWith<$Res> {
  _$BorrowRequestDtoCopyWithImpl(this._self, this._then);

  final BorrowRequestDto _self;
  final $Res Function(BorrowRequestDto) _then;

/// Create a copy of BorrowRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? bookTitle = null,Object? bookCoverUrl = freezed,Object? borrowerId = null,Object? lenderId = null,Object? status = null,Object? requestedAt = null,Object? respondedAt = freezed,Object? expectedReturnDateMs = freezed,Object? borrowerContact = freezed,Object? lenderContact = freezed,Object? returnedAt = freezed,Object? proposedReturnDateMs = freezed,Object? conditionOut = freezed,Object? conditionIn = freezed,Object? borrowerNote = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,bookCoverUrl: freezed == bookCoverUrl ? _self.bookCoverUrl : bookCoverUrl // ignore: cast_nullable_to_non_nullable
as String?,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,lenderId: null == lenderId ? _self.lenderId : lenderId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as int,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as int?,expectedReturnDateMs: freezed == expectedReturnDateMs ? _self.expectedReturnDateMs : expectedReturnDateMs // ignore: cast_nullable_to_non_nullable
as int?,borrowerContact: freezed == borrowerContact ? _self.borrowerContact : borrowerContact // ignore: cast_nullable_to_non_nullable
as String?,lenderContact: freezed == lenderContact ? _self.lenderContact : lenderContact // ignore: cast_nullable_to_non_nullable
as String?,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as int?,proposedReturnDateMs: freezed == proposedReturnDateMs ? _self.proposedReturnDateMs : proposedReturnDateMs // ignore: cast_nullable_to_non_nullable
as int?,conditionOut: freezed == conditionOut ? _self.conditionOut : conditionOut // ignore: cast_nullable_to_non_nullable
as String?,conditionIn: freezed == conditionIn ? _self.conditionIn : conditionIn // ignore: cast_nullable_to_non_nullable
as String?,borrowerNote: freezed == borrowerNote ? _self.borrowerNote : borrowerNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BorrowRequestDto].
extension BorrowRequestDtoPatterns on BorrowRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BorrowRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BorrowRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BorrowRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _BorrowRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BorrowRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _BorrowRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookId,  String bookTitle,  String? bookCoverUrl,  String borrowerId,  String lenderId,  RequestStatus status,  int requestedAt,  int? respondedAt,  int? expectedReturnDateMs,  String? borrowerContact,  String? lenderContact,  int? returnedAt,  int? proposedReturnDateMs,  String? conditionOut,  String? conditionIn,  String? borrowerNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BorrowRequestDto() when $default != null:
return $default(_that.id,_that.bookId,_that.bookTitle,_that.bookCoverUrl,_that.borrowerId,_that.lenderId,_that.status,_that.requestedAt,_that.respondedAt,_that.expectedReturnDateMs,_that.borrowerContact,_that.lenderContact,_that.returnedAt,_that.proposedReturnDateMs,_that.conditionOut,_that.conditionIn,_that.borrowerNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookId,  String bookTitle,  String? bookCoverUrl,  String borrowerId,  String lenderId,  RequestStatus status,  int requestedAt,  int? respondedAt,  int? expectedReturnDateMs,  String? borrowerContact,  String? lenderContact,  int? returnedAt,  int? proposedReturnDateMs,  String? conditionOut,  String? conditionIn,  String? borrowerNote)  $default,) {final _that = this;
switch (_that) {
case _BorrowRequestDto():
return $default(_that.id,_that.bookId,_that.bookTitle,_that.bookCoverUrl,_that.borrowerId,_that.lenderId,_that.status,_that.requestedAt,_that.respondedAt,_that.expectedReturnDateMs,_that.borrowerContact,_that.lenderContact,_that.returnedAt,_that.proposedReturnDateMs,_that.conditionOut,_that.conditionIn,_that.borrowerNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookId,  String bookTitle,  String? bookCoverUrl,  String borrowerId,  String lenderId,  RequestStatus status,  int requestedAt,  int? respondedAt,  int? expectedReturnDateMs,  String? borrowerContact,  String? lenderContact,  int? returnedAt,  int? proposedReturnDateMs,  String? conditionOut,  String? conditionIn,  String? borrowerNote)?  $default,) {final _that = this;
switch (_that) {
case _BorrowRequestDto() when $default != null:
return $default(_that.id,_that.bookId,_that.bookTitle,_that.bookCoverUrl,_that.borrowerId,_that.lenderId,_that.status,_that.requestedAt,_that.respondedAt,_that.expectedReturnDateMs,_that.borrowerContact,_that.lenderContact,_that.returnedAt,_that.proposedReturnDateMs,_that.conditionOut,_that.conditionIn,_that.borrowerNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BorrowRequestDto extends BorrowRequestDto {
  const _BorrowRequestDto({required this.id, required this.bookId, required this.bookTitle, this.bookCoverUrl, required this.borrowerId, required this.lenderId, this.status = RequestStatus.pending, required this.requestedAt, this.respondedAt, this.expectedReturnDateMs, this.borrowerContact, this.lenderContact, this.returnedAt, this.proposedReturnDateMs, this.conditionOut, this.conditionIn, this.borrowerNote}): super._();
  factory _BorrowRequestDto.fromJson(Map<String, dynamic> json) => _$BorrowRequestDtoFromJson(json);

@override final  String id;
@override final  String bookId;
@override final  String bookTitle;
@override final  String? bookCoverUrl;
@override final  String borrowerId;
@override final  String lenderId;
@override@JsonKey() final  RequestStatus status;
@override final  int requestedAt;
@override final  int? respondedAt;
@override final  int? expectedReturnDateMs;
@override final  String? borrowerContact;
@override final  String? lenderContact;
@override final  int? returnedAt;
@override final  int? proposedReturnDateMs;
@override final  String? conditionOut;
@override final  String? conditionIn;
@override final  String? borrowerNote;

/// Create a copy of BorrowRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowRequestDtoCopyWith<_BorrowRequestDto> get copyWith => __$BorrowRequestDtoCopyWithImpl<_BorrowRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BorrowRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BorrowRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.bookCoverUrl, bookCoverUrl) || other.bookCoverUrl == bookCoverUrl)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.lenderId, lenderId) || other.lenderId == lenderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.expectedReturnDateMs, expectedReturnDateMs) || other.expectedReturnDateMs == expectedReturnDateMs)&&(identical(other.borrowerContact, borrowerContact) || other.borrowerContact == borrowerContact)&&(identical(other.lenderContact, lenderContact) || other.lenderContact == lenderContact)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt)&&(identical(other.proposedReturnDateMs, proposedReturnDateMs) || other.proposedReturnDateMs == proposedReturnDateMs)&&(identical(other.conditionOut, conditionOut) || other.conditionOut == conditionOut)&&(identical(other.conditionIn, conditionIn) || other.conditionIn == conditionIn)&&(identical(other.borrowerNote, borrowerNote) || other.borrowerNote == borrowerNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,bookTitle,bookCoverUrl,borrowerId,lenderId,status,requestedAt,respondedAt,expectedReturnDateMs,borrowerContact,lenderContact,returnedAt,proposedReturnDateMs,conditionOut,conditionIn,borrowerNote);

@override
String toString() {
  return 'BorrowRequestDto(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, borrowerId: $borrowerId, lenderId: $lenderId, status: $status, requestedAt: $requestedAt, respondedAt: $respondedAt, expectedReturnDateMs: $expectedReturnDateMs, borrowerContact: $borrowerContact, lenderContact: $lenderContact, returnedAt: $returnedAt, proposedReturnDateMs: $proposedReturnDateMs, conditionOut: $conditionOut, conditionIn: $conditionIn, borrowerNote: $borrowerNote)';
}


}

/// @nodoc
abstract mixin class _$BorrowRequestDtoCopyWith<$Res> implements $BorrowRequestDtoCopyWith<$Res> {
  factory _$BorrowRequestDtoCopyWith(_BorrowRequestDto value, $Res Function(_BorrowRequestDto) _then) = __$BorrowRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, String bookTitle, String? bookCoverUrl, String borrowerId, String lenderId, RequestStatus status, int requestedAt, int? respondedAt, int? expectedReturnDateMs, String? borrowerContact, String? lenderContact, int? returnedAt, int? proposedReturnDateMs, String? conditionOut, String? conditionIn, String? borrowerNote
});




}
/// @nodoc
class __$BorrowRequestDtoCopyWithImpl<$Res>
    implements _$BorrowRequestDtoCopyWith<$Res> {
  __$BorrowRequestDtoCopyWithImpl(this._self, this._then);

  final _BorrowRequestDto _self;
  final $Res Function(_BorrowRequestDto) _then;

/// Create a copy of BorrowRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? bookTitle = null,Object? bookCoverUrl = freezed,Object? borrowerId = null,Object? lenderId = null,Object? status = null,Object? requestedAt = null,Object? respondedAt = freezed,Object? expectedReturnDateMs = freezed,Object? borrowerContact = freezed,Object? lenderContact = freezed,Object? returnedAt = freezed,Object? proposedReturnDateMs = freezed,Object? conditionOut = freezed,Object? conditionIn = freezed,Object? borrowerNote = freezed,}) {
  return _then(_BorrowRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,bookTitle: null == bookTitle ? _self.bookTitle : bookTitle // ignore: cast_nullable_to_non_nullable
as String,bookCoverUrl: freezed == bookCoverUrl ? _self.bookCoverUrl : bookCoverUrl // ignore: cast_nullable_to_non_nullable
as String?,borrowerId: null == borrowerId ? _self.borrowerId : borrowerId // ignore: cast_nullable_to_non_nullable
as String,lenderId: null == lenderId ? _self.lenderId : lenderId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as int,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as int?,expectedReturnDateMs: freezed == expectedReturnDateMs ? _self.expectedReturnDateMs : expectedReturnDateMs // ignore: cast_nullable_to_non_nullable
as int?,borrowerContact: freezed == borrowerContact ? _self.borrowerContact : borrowerContact // ignore: cast_nullable_to_non_nullable
as String?,lenderContact: freezed == lenderContact ? _self.lenderContact : lenderContact // ignore: cast_nullable_to_non_nullable
as String?,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as int?,proposedReturnDateMs: freezed == proposedReturnDateMs ? _self.proposedReturnDateMs : proposedReturnDateMs // ignore: cast_nullable_to_non_nullable
as int?,conditionOut: freezed == conditionOut ? _self.conditionOut : conditionOut // ignore: cast_nullable_to_non_nullable
as String?,conditionIn: freezed == conditionIn ? _self.conditionIn : conditionIn // ignore: cast_nullable_to_non_nullable
as String?,borrowerNote: freezed == borrowerNote ? _self.borrowerNote : borrowerNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
