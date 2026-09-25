import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../books/domain/models/book.dart';
import '../../domain/models/borrow_request.dart';
import '../../domain/repositories/request_repository.dart';

class FirestoreRequestRepository implements RequestRepository {
  FirestoreRequestRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection('requests');

  BorrowRequest _decode(Map<String, dynamic> json) =>
      BorrowRequest.fromJson(json);

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
    await doc.set(request.toJson());
    return request;
  }

  @override
  Future<void> accept(
    String requestId, {
    required DateTime expectedReturnDate,
    required String lenderContact,
  }) => _requests.doc(requestId).update({
    'status': 'accepted',
    'respondedAt': DateTime.now().millisecondsSinceEpoch,
    'expectedReturnDateMs': expectedReturnDate.millisecondsSinceEpoch,
    'lenderContact': lenderContact,
  });

  @override
  Future<void> decline(String requestId) => _requests.doc(requestId).update({
    'status': 'declined',
    'respondedAt': DateTime.now().millisecondsSinceEpoch,
  });

  @override
  Future<void> shareBorrowerContact(String requestId, String contact) =>
      _requests.doc(requestId).update({'borrowerContact': contact});
}
