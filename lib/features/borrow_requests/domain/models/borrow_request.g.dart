// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BorrowRequest _$BorrowRequestFromJson(Map<String, dynamic> json) =>
    _BorrowRequest(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      bookCoverUrl: json['bookCoverUrl'] as String?,
      borrowerId: json['borrowerId'] as String,
      lenderId: json['lenderId'] as String,
      status:
          $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
          RequestStatus.pending,
      requestedAt: (json['requestedAt'] as num).toInt(),
      respondedAt: (json['respondedAt'] as num?)?.toInt(),
      expectedReturnDateMs: (json['expectedReturnDateMs'] as num?)?.toInt(),
      borrowerContact: json['borrowerContact'] as String?,
      lenderContact: json['lenderContact'] as String?,
    );

Map<String, dynamic> _$BorrowRequestToJson(_BorrowRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'bookTitle': instance.bookTitle,
      'bookCoverUrl': instance.bookCoverUrl,
      'borrowerId': instance.borrowerId,
      'lenderId': instance.lenderId,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'requestedAt': instance.requestedAt,
      'respondedAt': instance.respondedAt,
      'expectedReturnDateMs': instance.expectedReturnDateMs,
      'borrowerContact': instance.borrowerContact,
      'lenderContact': instance.lenderContact,
    };

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.accepted: 'accepted',
  RequestStatus.declined: 'declined',
};
