import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../books/domain/entities/book.dart';
import '../../domain/entities/borrow_request.dart';
import '../../domain/repositories/request_repository.dart';
import '../models/borrow_request_dto.dart';

class FirestoreRequestRepository implements RequestRepository {
  FirestoreRequestRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection('requests');

  BorrowRequest _decode(Map<String, dynamic> json) =>
      BorrowRequestDto.parse(json);

  List<BorrowRequest> _sorted(List<BorrowRequest> requests) =>
      requests..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

  @override
  Stream<List<BorrowRequest>> watchIncoming(String lenderId) => _requests
      .where('lenderId', isEqualTo: lenderId)
      .snapshots()
      .map((s) => _sorted(s.docs.map((d) => _decode(d.data())).toList()));

  @override
  Stream<List<BorrowRequest>> watchOutgoing(String borrowerId) => _requests
      .where('borrowerId', isEqualTo: borrowerId)
      .snapshots()
      .map((s) => _sorted(s.docs.map((d) => _decode(d.data())).toList()));

  @override
  Future<BorrowRequest> sendRequest({
    required Book book,
    required String borrowerId,
  }) async {
    if (book.ownerId == borrowerId) {
      throw const RequestValidationFailure("You can't request your own book.");
    }
    if (book.status != BookStatus.available) {
      throw const RequestValidationFailure('This book is no longer available.');
    }
    final existingPending = await _requests
        .where('bookId', isEqualTo: book.id)
        .where('borrowerId', isEqualTo: borrowerId)
        .where('status', isEqualTo: 'pending')
        .get();
    if (existingPending.docs.isNotEmpty) {
      throw const RequestValidationFailure(
        'You already have a pending request for this book.',
      );
    }
    final doc = _requests.doc();
    final request = BorrowRequest(
      id: doc.id,
      bookId: book.id,
      bookTitle: book.title,
      bookCoverUrl: book.coverPhotoUrl,
      borrowerId: borrowerId,
      lenderId: book.ownerId,
      requestedAt: DateTime.now().millisecondsSinceEpoch,
    );
    try {
      await doc.set(request.toJson());
    } on FirebaseException catch (e) {
      // The lender may have blocked this borrower (SRS §3.4) — the rules
      // enforce that at write time via a private /blocks lookup the client
      // can't read directly, so a rejected write is the first signal of it.
      // Deliberately vague: this shouldn't confirm to the sender that they
      // were specifically blocked.
      if (e.code == 'permission-denied') {
        throw const RequestValidationFailure(
          "This user isn't accepting requests right now.",
        );
      }
      rethrow;
    }
    return request;
  }

  @override
  Future<void> accept(
    String requestId, {
    required DateTime expectedReturnDate,
    required String lenderContact,
    required String conditionOut,
  }) => _requests.doc(requestId).update({
    'status': 'accepted',
    'respondedAt': DateTime.now().millisecondsSinceEpoch,
    'expectedReturnDateMs': expectedReturnDate.millisecondsSinceEpoch,
    'lenderContact': lenderContact,
    'conditionOut': conditionOut,
  });

  @override
  Future<void> decline(String requestId) => _requests.doc(requestId).update({
    'status': 'declined',
    'respondedAt': DateTime.now().millisecondsSinceEpoch,
  });

  @override
  Future<void> shareBorrowerContact(String requestId, String contact) =>
      _requests.doc(requestId).update({'borrowerContact': contact});

  @override
  Future<void> markReturned(String requestId, {required String conditionIn}) =>
      _requests.doc(requestId).update({
        'returnedAt': DateTime.now().millisecondsSinceEpoch,
        'conditionIn': conditionIn,
      });

  @override
  Future<void> addBorrowerNote(String requestId, String note) =>
      _requests.doc(requestId).update({'borrowerNote': note});

  @override
  Future<void> requestExtension(
    String requestId,
    DateTime proposedReturnDate,
  ) => _requests.doc(requestId).update({
    'proposedReturnDateMs': proposedReturnDate.millisecondsSinceEpoch,
  });

  @override
  Future<void> resolveExtension(String requestId, {required bool approve}) =>
      _firestore.runTransaction((transaction) async {
        final ref = _requests.doc(requestId);
        final snapshot = await transaction.get(ref);
        final proposed = snapshot.data()?['proposedReturnDateMs'] as int?;
        transaction.update(ref, {
          'proposedReturnDateMs': null,
          if (approve && proposed != null) 'expectedReturnDateMs': proposed,
        });
      });
}
