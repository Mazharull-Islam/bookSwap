/// Marks "argument not passed" in [copyWith], so null can be passed on purpose.
const Object _keep = Object();

enum RequestStatus { pending, accepted, declined }

class BorrowRequest {
  const BorrowRequest({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    this.bookCoverUrl,
    required this.borrowerId,
    required this.lenderId,
    this.status = RequestStatus.pending,
    required this.requestedAt,
    this.respondedAt,
    this.expectedReturnDateMs,
    this.borrowerContact,
    this.lenderContact,
    this.returnedAt,
    this.proposedReturnDateMs,
    this.conditionOut,
    this.conditionIn,
    this.borrowerNote,
  });

  final String id;

  final String bookId;

  final String bookTitle;

  final String? bookCoverUrl;

  final String borrowerId;

  final String lenderId;

  final RequestStatus status;

  final int requestedAt;

  final int? respondedAt;

  final int? expectedReturnDateMs;

  final String? borrowerContact;

  final String? lenderContact;

  /// Set once the lender marks the loan as returned/exchanged. Null means
  /// the loan (if accepted) is still active. Drives loan history (SRS §3.5).
  final int? returnedAt;

  /// Borrower-proposed new return date, awaiting the lender's approval.
  /// Null once resolved (approved into [expectedReturnDateMs], or
  /// declined and simply cleared) — never a separate history of past
  /// extension attempts.
  final int? proposedReturnDateMs;

  /// The book's condition when it went out (snapshotted from its listing
  /// at acceptance) and as the lender found it on return — SRS §3.5's
  /// condition history. See loan_condition.dart for what counts as worse.
  final String? conditionOut;

  final String? conditionIn;

  /// The borrower's explanation after a return flagged as worse. Optional.
  final String? borrowerNote;

  /// Still in play: asked for, or out on loan. A declined request and a loan
  /// that came back are both over.
  bool get isOpen => status != RequestStatus.declined && returnedAt == null;

  /// The whole lifecycle finished: it was accepted, lent and returned.
  bool get isCompleted =>
      status == RequestStatus.accepted && returnedAt != null;

  BorrowRequest copyWith({
    String? id,
    String? bookId,
    String? bookTitle,
    Object? bookCoverUrl = _keep,
    String? borrowerId,
    String? lenderId,
    RequestStatus? status,
    int? requestedAt,
    Object? respondedAt = _keep,
    Object? expectedReturnDateMs = _keep,
    Object? borrowerContact = _keep,
    Object? lenderContact = _keep,
    Object? returnedAt = _keep,
    Object? proposedReturnDateMs = _keep,
    Object? conditionOut = _keep,
    Object? conditionIn = _keep,
    Object? borrowerNote = _keep,
  }) => BorrowRequest(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    bookTitle: bookTitle ?? this.bookTitle,
    bookCoverUrl: identical(bookCoverUrl, _keep)
        ? this.bookCoverUrl
        : bookCoverUrl as String?,
    borrowerId: borrowerId ?? this.borrowerId,
    lenderId: lenderId ?? this.lenderId,
    status: status ?? this.status,
    requestedAt: requestedAt ?? this.requestedAt,
    respondedAt: identical(respondedAt, _keep)
        ? this.respondedAt
        : respondedAt as int?,
    expectedReturnDateMs: identical(expectedReturnDateMs, _keep)
        ? this.expectedReturnDateMs
        : expectedReturnDateMs as int?,
    borrowerContact: identical(borrowerContact, _keep)
        ? this.borrowerContact
        : borrowerContact as String?,
    lenderContact: identical(lenderContact, _keep)
        ? this.lenderContact
        : lenderContact as String?,
    returnedAt: identical(returnedAt, _keep)
        ? this.returnedAt
        : returnedAt as int?,
    proposedReturnDateMs: identical(proposedReturnDateMs, _keep)
        ? this.proposedReturnDateMs
        : proposedReturnDateMs as int?,
    conditionOut: identical(conditionOut, _keep)
        ? this.conditionOut
        : conditionOut as String?,
    conditionIn: identical(conditionIn, _keep)
        ? this.conditionIn
        : conditionIn as String?,
    borrowerNote: identical(borrowerNote, _keep)
        ? this.borrowerNote
        : borrowerNote as String?,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorrowRequest &&
          id == other.id &&
          bookId == other.bookId &&
          bookTitle == other.bookTitle &&
          bookCoverUrl == other.bookCoverUrl &&
          borrowerId == other.borrowerId &&
          lenderId == other.lenderId &&
          status == other.status &&
          requestedAt == other.requestedAt &&
          respondedAt == other.respondedAt &&
          expectedReturnDateMs == other.expectedReturnDateMs &&
          borrowerContact == other.borrowerContact &&
          lenderContact == other.lenderContact &&
          returnedAt == other.returnedAt &&
          proposedReturnDateMs == other.proposedReturnDateMs &&
          conditionOut == other.conditionOut &&
          conditionIn == other.conditionIn &&
          borrowerNote == other.borrowerNote;

  @override
  int get hashCode => Object.hashAll([
    BorrowRequest,
    id,
    bookId,
    bookTitle,
    bookCoverUrl,
    borrowerId,
    lenderId,
    status,
    requestedAt,
    respondedAt,
    expectedReturnDateMs,
    borrowerContact,
    lenderContact,
    returnedAt,
    proposedReturnDateMs,
    conditionOut,
    conditionIn,
    borrowerNote,
  ]);

  @override
  String toString() => 'BorrowRequest(id: $id)';
}
