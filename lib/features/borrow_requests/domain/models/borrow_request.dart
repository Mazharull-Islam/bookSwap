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

    /// Borrower-proposed new return date, awaiting the lender's approval.
    /// Null once resolved (approved into [expectedReturnDateMs], or
    /// declined and simply cleared) — never a separate history of past
    /// extension attempts.
    int? proposedReturnDateMs,

    /// The book's condition when it went out (snapshotted from its listing
    /// at acceptance) and as the lender found it on return — SRS §3.5's
    /// condition history. See loan_condition.dart for what counts as worse.
    String? conditionOut,
    String? conditionIn,

    /// The borrower's explanation after a return flagged as worse. Optional.
    String? borrowerNote,
  }) = _BorrowRequest;

  factory BorrowRequest.fromJson(Map<String, dynamic> json) =>
      _$BorrowRequestFromJson(json);
}
