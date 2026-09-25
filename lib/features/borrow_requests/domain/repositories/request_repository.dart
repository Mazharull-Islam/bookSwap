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
}
