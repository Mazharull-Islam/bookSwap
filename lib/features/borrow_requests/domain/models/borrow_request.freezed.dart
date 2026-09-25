// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrow_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BorrowRequest {

 String get id; String get bookId; String get bookTitle; String? get bookCoverUrl; String get borrowerId; String get lenderId; RequestStatus get status; int get requestedAt; int? get respondedAt; int? get expectedReturnDateMs;// Denormalized onto the request itself (not read from /profiles) so
// Firestore rules can gate exactly when each becomes visible — neither
// is present until the lender accepts; the borrower's is only added
// once they explicitly choose to share it. See firestore.rules.
 String? get borrowerContact; String? get lenderContact;
/// Create a copy of BorrowRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowRequestCopyWith<BorrowRequest> get copyWith => _$BorrowRequestCopyWithImpl<BorrowRequest>(this as BorrowRequest, _$identity);

  /// Serializes this BorrowRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BorrowRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.bookCoverUrl, bookCoverUrl) || other.bookCoverUrl == bookCoverUrl)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.lenderId, lenderId) || other.lenderId == lenderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.expectedReturnDateMs, expectedReturnDateMs) || other.expectedReturnDateMs == expectedReturnDateMs)&&(identical(other.borrowerContact, borrowerContact) || other.borrowerContact == borrowerContact)&&(identical(other.lenderContact, lenderContact) || other.lenderContact == lenderContact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,bookTitle,bookCoverUrl,borrowerId,lenderId,status,requestedAt,respondedAt,expectedReturnDateMs,borrowerContact,lenderContact);

@override
String toString() {
  return 'BorrowRequest(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, borrowerId: $borrowerId, lenderId: $lenderId, status: $status, requestedAt: $requestedAt, respondedAt: $respondedAt, expectedReturnDateMs: $expectedReturnDateMs, borrowerContact: $borrowerContact, lenderContact: $lenderContact)';
}


}

/// @nodoc
abstract mixin class $BorrowRequestCopyWith<$Res>  {
  factory $BorrowRequestCopyWith(BorrowRequest value, $Res Function(BorrowRequest) _then) = _$BorrowRequestCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, String bookTitle, String? bookCoverUrl, String borrowerId, String lenderId, RequestStatus status, int requestedAt, int? respondedAt, int? expectedReturnDateMs, String? borrowerContact, String? lenderContact
});




}
/// @nodoc
class _$BorrowRequestCopyWithImpl<$Res>
    implements $BorrowRequestCopyWith<$Res> {
  _$BorrowRequestCopyWithImpl(this._self, this._then);

  final BorrowRequest _self;
  final $Res Function(BorrowRequest) _then;

/// Create a copy of BorrowRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? bookTitle = null,Object? bookCoverUrl = freezed,Object? borrowerId = null,Object? lenderId = null,Object? status = null,Object? requestedAt = null,Object? respondedAt = freezed,Object? expectedReturnDateMs = freezed,Object? borrowerContact = freezed,Object? lenderContact = freezed,}) {
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
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BorrowRequest].
extension BorrowRequestPatterns on BorrowRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BorrowRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BorrowRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BorrowRequest value)  $default,){
final _that = this;
switch (_that) {
case _BorrowRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BorrowRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BorrowRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookId,  String bookTitle,  String? bookCoverUrl,  String borrowerId,  String lenderId,  RequestStatus status,  int requestedAt,  int? respondedAt,  int? expectedReturnDateMs,  String? borrowerContact,  String? lenderContact)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BorrowRequest() when $default != null:
return $default(_that.id,_that.bookId,_that.bookTitle,_that.bookCoverUrl,_that.borrowerId,_that.lenderId,_that.status,_that.requestedAt,_that.respondedAt,_that.expectedReturnDateMs,_that.borrowerContact,_that.lenderContact);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookId,  String bookTitle,  String? bookCoverUrl,  String borrowerId,  String lenderId,  RequestStatus status,  int requestedAt,  int? respondedAt,  int? expectedReturnDateMs,  String? borrowerContact,  String? lenderContact)  $default,) {final _that = this;
switch (_that) {
case _BorrowRequest():
return $default(_that.id,_that.bookId,_that.bookTitle,_that.bookCoverUrl,_that.borrowerId,_that.lenderId,_that.status,_that.requestedAt,_that.respondedAt,_that.expectedReturnDateMs,_that.borrowerContact,_that.lenderContact);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookId,  String bookTitle,  String? bookCoverUrl,  String borrowerId,  String lenderId,  RequestStatus status,  int requestedAt,  int? respondedAt,  int? expectedReturnDateMs,  String? borrowerContact,  String? lenderContact)?  $default,) {final _that = this;
switch (_that) {
case _BorrowRequest() when $default != null:
return $default(_that.id,_that.bookId,_that.bookTitle,_that.bookCoverUrl,_that.borrowerId,_that.lenderId,_that.status,_that.requestedAt,_that.respondedAt,_that.expectedReturnDateMs,_that.borrowerContact,_that.lenderContact);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BorrowRequest implements BorrowRequest {
  const _BorrowRequest({required this.id, required this.bookId, required this.bookTitle, this.bookCoverUrl, required this.borrowerId, required this.lenderId, this.status = RequestStatus.pending, required this.requestedAt, this.respondedAt, this.expectedReturnDateMs, this.borrowerContact, this.lenderContact});
  factory _BorrowRequest.fromJson(Map<String, dynamic> json) => _$BorrowRequestFromJson(json);

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
// Denormalized onto the request itself (not read from /profiles) so
// Firestore rules can gate exactly when each becomes visible — neither
// is present until the lender accepts; the borrower's is only added
// once they explicitly choose to share it. See firestore.rules.
@override final  String? borrowerContact;
@override final  String? lenderContact;

/// Create a copy of BorrowRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowRequestCopyWith<_BorrowRequest> get copyWith => __$BorrowRequestCopyWithImpl<_BorrowRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BorrowRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BorrowRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.bookTitle, bookTitle) || other.bookTitle == bookTitle)&&(identical(other.bookCoverUrl, bookCoverUrl) || other.bookCoverUrl == bookCoverUrl)&&(identical(other.borrowerId, borrowerId) || other.borrowerId == borrowerId)&&(identical(other.lenderId, lenderId) || other.lenderId == lenderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.expectedReturnDateMs, expectedReturnDateMs) || other.expectedReturnDateMs == expectedReturnDateMs)&&(identical(other.borrowerContact, borrowerContact) || other.borrowerContact == borrowerContact)&&(identical(other.lenderContact, lenderContact) || other.lenderContact == lenderContact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,bookTitle,bookCoverUrl,borrowerId,lenderId,status,requestedAt,respondedAt,expectedReturnDateMs,borrowerContact,lenderContact);

@override
String toString() {
  return 'BorrowRequest(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, borrowerId: $borrowerId, lenderId: $lenderId, status: $status, requestedAt: $requestedAt, respondedAt: $respondedAt, expectedReturnDateMs: $expectedReturnDateMs, borrowerContact: $borrowerContact, lenderContact: $lenderContact)';
}


}

/// @nodoc
abstract mixin class _$BorrowRequestCopyWith<$Res> implements $BorrowRequestCopyWith<$Res> {
  factory _$BorrowRequestCopyWith(_BorrowRequest value, $Res Function(_BorrowRequest) _then) = __$BorrowRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, String bookTitle, String? bookCoverUrl, String borrowerId, String lenderId, RequestStatus status, int requestedAt, int? respondedAt, int? expectedReturnDateMs, String? borrowerContact, String? lenderContact
});




}
/// @nodoc
class __$BorrowRequestCopyWithImpl<$Res>
    implements _$BorrowRequestCopyWith<$Res> {
  __$BorrowRequestCopyWithImpl(this._self, this._then);

  final _BorrowRequest _self;
  final $Res Function(_BorrowRequest) _then;

/// Create a copy of BorrowRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? bookTitle = null,Object? bookCoverUrl = freezed,Object? borrowerId = null,Object? lenderId = null,Object? status = null,Object? requestedAt = null,Object? respondedAt = freezed,Object? expectedReturnDateMs = freezed,Object? borrowerContact = freezed,Object? lenderContact = freezed,}) {
  return _then(_BorrowRequest(
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
as String?,
  ));
}


}

// dart format on
