import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../application/use_cases/request_use_cases.dart';
import '../../data/repositories/firestore_request_repository.dart';
import '../../domain/models/borrow_request.dart';
import '../../domain/repositories/request_repository.dart';

final requestRepositoryProvider = Provider<RequestRepository>(
  (ref) => FirestoreRequestRepository(FirebaseFirestore.instance),
);

final incomingRequestsProvider = StreamProvider<List<BorrowRequest>>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  return ref.watch(requestRepositoryProvider).watchIncoming(myId);
});

final outgoingRequestsProvider = StreamProvider<List<BorrowRequest>>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  return ref.watch(requestRepositoryProvider).watchOutgoing(myId);
});

final sendBorrowRequestProvider = Provider(
  (ref) => SendBorrowRequest(ref.watch(requestRepositoryProvider)),
);
final acceptBorrowRequestProvider = Provider(
  (ref) => AcceptBorrowRequest(ref.watch(requestRepositoryProvider)),
);
final declineBorrowRequestProvider = Provider(
  (ref) => DeclineBorrowRequest(ref.watch(requestRepositoryProvider)),
);
final shareBorrowerContactProvider = Provider(
  (ref) => ShareBorrowerContact(ref.watch(requestRepositoryProvider)),
);
