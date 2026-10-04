import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/borrow_request.dart';

part 'borrow_request_dto.freezed.dart';
part 'borrow_request_dto.g.dart';

@freezed
abstract class BorrowRequestDto with _$BorrowRequestDto {
  const BorrowRequestDto._();

  const factory BorrowRequestDto({
    required String id,
    required String bookId,
    required String bookTitle,
    String? bookCoverUrl,
    required String borrowerId,
    required String lenderId,
    @Default(RequestStatus.pending) RequestStatus status,
    required int requestedAt,
    int? respondedAt,
    int? expectedReturnDateMs,
    String? borrowerContact,
    String? lenderContact,
    int? returnedAt,
    int? proposedReturnDateMs,
    String? conditionOut,
    String? conditionIn,
    String? borrowerNote,
  }) = _BorrowRequestDto;

  factory BorrowRequestDto.fromJson(Map<String, dynamic> json) =>
      _$BorrowRequestDtoFromJson(json);

  factory BorrowRequestDto.fromEntity(BorrowRequest entity) => BorrowRequestDto(
    id: entity.id,
    bookId: entity.bookId,
    bookTitle: entity.bookTitle,
    bookCoverUrl: entity.bookCoverUrl,
    borrowerId: entity.borrowerId,
    lenderId: entity.lenderId,
    status: entity.status,
    requestedAt: entity.requestedAt,
    respondedAt: entity.respondedAt,
    expectedReturnDateMs: entity.expectedReturnDateMs,
    borrowerContact: entity.borrowerContact,
    lenderContact: entity.lenderContact,
    returnedAt: entity.returnedAt,
    proposedReturnDateMs: entity.proposedReturnDateMs,
    conditionOut: entity.conditionOut,
    conditionIn: entity.conditionIn,
    borrowerNote: entity.borrowerNote,
  );

  BorrowRequest toEntity() => BorrowRequest(
    id: id,
    bookId: bookId,
    bookTitle: bookTitle,
    bookCoverUrl: bookCoverUrl,
    borrowerId: borrowerId,
    lenderId: lenderId,
    status: status,
    requestedAt: requestedAt,
    respondedAt: respondedAt,
    expectedReturnDateMs: expectedReturnDateMs,
    borrowerContact: borrowerContact,
    lenderContact: lenderContact,
    returnedAt: returnedAt,
    proposedReturnDateMs: proposedReturnDateMs,
    conditionOut: conditionOut,
    conditionIn: conditionIn,
    borrowerNote: borrowerNote,
  );

  static BorrowRequest parse(Map<String, dynamic> json) =>
      BorrowRequestDto.fromJson(json).toEntity();
}

extension BorrowRequestJson on BorrowRequest {
  Map<String, dynamic> toJson() => BorrowRequestDto.fromEntity(this).toJson();
}
