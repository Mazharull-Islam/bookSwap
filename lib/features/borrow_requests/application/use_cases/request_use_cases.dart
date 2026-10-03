import '../../../books/domain/models/book.dart';
import '../../../books/domain/repositories/book_repository.dart';
import '../../domain/models/borrow_request.dart';
import '../../domain/repositories/request_repository.dart';

class SendBorrowRequest {
  const SendBorrowRequest(this.repository);
  final RequestRepository repository;

  Future<BorrowRequest> call({
    required Book book,
    required String borrowerId,
  }) => repository.sendRequest(book: book, borrowerId: borrowerId);
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
      // Snapshot, so a later edit to the listing can't rewrite the history.
      conditionOut: book.condition,
    );
    await _books.updateBook(book.copyWith(status: BookStatus.lent));
  }
}

/// Lender-only: ends the loan, records the condition the book came back in,
/// and restores the book to `available` — listed at that condition, so
/// Discover doesn't advertise a state the book is no longer in.
class MarkLoanReturned {
  const MarkLoanReturned(this._requests, this._books);
  final RequestRepository _requests;
  final BookRepository _books;

  Future<void> call(
    String requestId, {
    required String bookId,
    required String conditionIn,
  }) async {
    if (!bookConditionOptions.contains(conditionIn)) {
      throw const RequestValidationFailure("Choose the book's condition.");
    }
    await _requests.markReturned(requestId, conditionIn: conditionIn);
    final book = await _books.getBook(bookId);
    if (book != null) {
      await _books.updateBook(
        book.copyWith(status: BookStatus.available, condition: conditionIn),
      );
    }
  }
}

const maxBorrowerNoteLength = 300;

/// Borrower-only: explains a return the lender flagged as worse.
class AddBorrowerNote {
  const AddBorrowerNote(this.repository);
  final RequestRepository repository;

  Future<void> call(String requestId, String note) {
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      throw const RequestValidationFailure('Write a short note first.');
    }
    if (trimmed.length > maxBorrowerNoteLength) {
      throw const RequestValidationFailure(
        'Keep your note to $maxBorrowerNoteLength characters or fewer.',
      );
    }
    return repository.addBorrowerNote(requestId, trimmed);
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

class RequestLoanExtension {
  const RequestLoanExtension(this.repository);
  final RequestRepository repository;

  Future<void> call(String requestId, DateTime proposedReturnDate) =>
      repository.requestExtension(requestId, proposedReturnDate);
}

class ResolveLoanExtension {
  const ResolveLoanExtension(this.repository);
  final RequestRepository repository;

  Future<void> call(String requestId, {required bool approve}) =>
      repository.resolveExtension(requestId, approve: approve);
}
