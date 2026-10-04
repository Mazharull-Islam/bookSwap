import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../application/use_cases/block_use_cases.dart';
import '../../data/repositories/firestore_block_repository.dart';
import '../../domain/entities/blocked_user.dart';
import '../../domain/repositories/block_repository.dart';

final blockRepositoryProvider = Provider<BlockRepository>(
  (ref) => FirestoreBlockRepository(FirebaseFirestore.instance),
);

final myBlockedUsersProvider = StreamProvider<List<BlockedUser>>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  return ref.watch(blockRepositoryProvider).watchMine(myId);
});

final blockUserProvider = Provider(
  (ref) => BlockUser(ref.watch(blockRepositoryProvider)),
);
final unblockUserProvider = Provider(
  (ref) => UnblockUser(ref.watch(blockRepositoryProvider)),
);
