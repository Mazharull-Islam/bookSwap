import '../../../books/domain/models/book.dart';
import '../models/borrow_request.dart';

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
  });

  Future<void> decline(String requestId);

  Future<void> shareBorrowerContact(String requestId, String contact);

  /// Lender-only: marks an active loan as returned/exchanged.
  Future<void> markReturned(String requestId);

  /// Borrower-only: proposes a new return date on an active loan.
  Future<void> requestExtension(String requestId, DateTime proposedReturnDate);

  /// Lender-only: approves the pending extension (moving it into
  /// [BorrowRequest.expectedReturnDateMs]) or declines it (leaving the
  /// existing return date untouched). Either way clears the proposal.
  Future<void> resolveExtension(String requestId, {required bool approve});
}
