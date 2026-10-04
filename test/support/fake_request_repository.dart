import 'package:bookswap_login/features/books/domain/entities/book.dart';
import 'package:bookswap_login/features/borrow_requests/domain/entities/borrow_request.dart';
import 'package:bookswap_login/features/borrow_requests/domain/repositories/request_repository.dart';

/// Records the writes the Requests screen makes. Reads come from the
/// provider overrides in test_app.dart, so the watch streams stay empty.
class FakeRequestRepository implements RequestRepository {
  final declined = <String>[];
  final extensionsResolved = <String>[];

  /// requestId -> "lenderContact|conditionOut" recorded on accept.
  final accepted = <String, String>{};

  /// requestId -> the contact the borrower shared.
  final contactShared = <String, String>{};

  /// requestId -> the return date the borrower proposed.
  final extensionsRequested = <String, DateTime>{};

  /// requestId -> condition recorded on return.
  final returned = <String, String>{};

  /// requestId -> note text.
  final notes = <String, String>{};
  Object? failWith;

  @override
  Future<void> decline(String requestId) async {
    if (failWith != null) throw failWith!;
    declined.add(requestId);
  }

  @override
  Future<void> resolveExtension(
    String requestId, {
    required bool approve,
  }) async {
    extensionsResolved.add('$requestId:$approve');
  }

  @override
  Future<void> markReturned(
    String requestId, {
    required String conditionIn,
  }) async {
    if (failWith != null) throw failWith!;
    returned[requestId] = conditionIn;
  }

  @override
  Future<void> addBorrowerNote(String requestId, String note) async {
    if (failWith != null) throw failWith!;
    notes[requestId] = note;
  }

  @override
  Stream<List<BorrowRequest>> watchIncoming(String lenderId) =>
      const Stream.empty();
  @override
  Stream<List<BorrowRequest>> watchOutgoing(String borrowerId) =>
      const Stream.empty();
  @override
  Future<BorrowRequest> sendRequest({
    required Book book,
    required String borrowerId,
  }) => throw UnimplementedError();
  @override
  Future<void> accept(
    String requestId, {
    required DateTime expectedReturnDate,
    required String lenderContact,
    required String conditionOut,
  }) async {
    if (failWith != null) throw failWith!;
    accepted[requestId] = '$lenderContact|$conditionOut';
  }

  @override
  Future<void> shareBorrowerContact(String requestId, String contact) async {
    contactShared[requestId] = contact;
  }

  @override
  Future<void> requestExtension(String requestId, DateTime proposed) async {
    extensionsRequested[requestId] = proposed;
  }
}
