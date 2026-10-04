import '../../../books/domain/entities/book.dart';
import '../entities/borrow_request.dart';

class RequestValidationFailure implements Exception {
  const RequestValidationFailure(this.message);
  final String message;
}

abstract interface class RequestRepository {
  /// Requests aimed at books I own.
  Stream<List<BorrowRequest>> watchIncoming(String lenderId);

  /// Requests I've sent.
  Stream<List<BorrowRequest>> watchOutgoing(String borrowerId);

  Future<BorrowRequest> sendRequest({
    required Book book,
    required String borrowerId,
  });

  Future<void> accept(
    String requestId, {
    required DateTime expectedReturnDate,
    required String lenderContact,
    required String conditionOut,
  });

  Future<void> decline(String requestId);

  Future<void> shareBorrowerContact(String requestId, String contact);

  /// Lender-only: marks an active loan as returned/exchanged.
  /// [conditionIn] is the condition the lender found the book in.
  Future<void> markReturned(String requestId, {required String conditionIn});

  /// Borrower-only: explains a return that was flagged as worse.
  Future<void> addBorrowerNote(String requestId, String note);

  /// Borrower-only: proposes a new return date on an active loan.
  Future<void> requestExtension(String requestId, DateTime proposedReturnDate);

  /// Lender-only: approves the pending extension (moving it into
  /// [BorrowRequest.expectedReturnDateMs]) or declines it (leaving the
  /// existing return date untouched). Either way clears the proposal.
  Future<void> resolveExtension(String requestId, {required bool approve});
}
