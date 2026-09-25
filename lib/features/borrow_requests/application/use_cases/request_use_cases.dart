import '../../../books/domain/models/book.dart';
import '../../domain/models/borrow_request.dart';
import '../../domain/repositories/request_repository.dart';

class SendBorrowRequest {
  const SendBorrowRequest(this.repository);
  final RequestRepository repository;

  Future<BorrowRequest> call({required Book book, required String borrowerId}) =>
      repository.sendRequest(book: book, borrowerId: borrowerId);
}

class AcceptBorrowRequest {
  const AcceptBorrowRequest(this.repository);
  final RequestRepository repository;

  Future<void> call(
    String requestId, {
    required DateTime expectedReturnDate,
    required String lenderContact,
  }) => repository.accept(
    requestId,
    expectedReturnDate: expectedReturnDate,
    lenderContact: lenderContact,
  );
}

class DeclineBorrowRequest {
  const DeclineBorrowRequest(this.repository);
  final RequestRepository repository;

  Future<void> call(String requestId) => repository.decline(requestId);
}

class ShareBorrowerContact {
  const ShareBorrowerContact(this.repository);
  final RequestRepository repository;

  Future<void> call(String requestId, String contact) =>
      repository.shareBorrowerContact(requestId, contact);
}
