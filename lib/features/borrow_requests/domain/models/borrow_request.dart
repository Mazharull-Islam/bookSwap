import 'package:freezed_annotation/freezed_annotation.dart';

part 'borrow_request.freezed.dart';
part 'borrow_request.g.dart';

enum RequestStatus { pending, accepted, declined }

@freezed
abstract class BorrowRequest with _$BorrowRequest {
  const factory BorrowRequest({
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
    /// Set once the lender marks the loan as returned/exchanged. Null means
    /// the loan (if accepted) is still active. Drives loan history (SRS §3.5).
    int? returnedAt,
  }) = _BorrowRequest;

  factory BorrowRequest.fromJson(Map<String, dynamic> json) =>
      _$BorrowRequestFromJson(json);
}
