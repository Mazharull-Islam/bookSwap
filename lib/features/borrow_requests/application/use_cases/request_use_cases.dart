import '../../../books/domain/models/book.dart';
import '../../../books/domain/repositories/book_repository.dart';
import '../../domain/models/borrow_request.dart';
import '../../domain/repositories/request_repository.dart';

class SendBorrowRequest {
  const SendBorrowRequest(this.repository);
  final RequestRepository repository;

  Future<BorrowRequest> call({required Book book, required String borrowerId}) =>
      repository.sendRequest(book: book, borrowerId: borrowerId);
}

/// Accepting a request also starts the loan: the book moves to `lent` so it
/// stops showing as requestable elsewhere (SRS §3.5). The book update goes
/// through the local-first BookRepository (Hive), not Firestore directly, so
/// it rides the normal sync/push path like any other shelf edit.
class AcceptBorrowRequest {
  const AcceptBorrowRequest(this._requests, this._books);
  final RequestRepository _requests;
  final BookRepository _books;

  Future<void> call(
    String requestId, {
    required String bookId,
    required DateTime expectedReturnDate,
    required String lenderContact,
  }) async {
    final book = await _books.getBook(bookId);
    if (book == null) {
      throw const RequestValidationFailure('This book no longer exists.');
    }
    if (book.status != BookStatus.available) {
      throw const RequestValidationFailure('This book is no longer available.');
    }
    await _requests.accept(
      requestId,
      expectedReturnDate: expectedReturnDate,
      lenderContact: lenderContact,
    );
    await _books.updateBook(book.copyWith(status: BookStatus.lent));
  }
}

/// Lender-only: ends the loan and restores the book to `available`.
class MarkLoanReturned {
  const MarkLoanReturned(this._requests, this._books);
  final RequestRepository _requests;
  final BookRepository _books;

  Future<void> call(String requestId, {required String bookId}) async {
    await _requests.markReturned(requestId);
    final book = await _books.getBook(bookId);
    if (book != null) {
      await _books.updateBook(book.copyWith(status: BookStatus.available));
    }
  }
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
