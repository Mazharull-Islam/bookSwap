import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/blocked_user.dart';
import '../../domain/repositories/block_repository.dart';
import '../models/blocked_user_dto.dart';

/// Live data, so it bypasses Hive. Deliberately NOT member-readable: only the
/// blocker can read their own block records (see firestore.rules). The
/// /requests create rule still enforces the block via a targeted
/// `exists()` check on the deterministic doc id, which needs no read grant.
class FirestoreBlockRepository implements BlockRepository {
  FirestoreBlockRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _blocks =>
      _firestore.collection('blocks');

  @override
  Stream<List<BlockedUser>> watchMine(String blockerId) => _blocks
      .where('blockerId', isEqualTo: blockerId)
      .snapshots()
      .map(
        (s) =>
            (s.docs.map((d) => BlockedUserDto.parse(d.data())).toList()
              ..sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs))),
      );

  @override
  Future<void> block({
    required String blockerId,
    required String blockedId,
    required String blockedName,
  }) async {
    if (blockerId == blockedId) {
      throw const BlockValidationFailure("You can't block yourself.");
    }
    final id = blockId(blockerId, blockedId);
    final entry = BlockedUser(
      id: id,
      blockerId: blockerId,
      blockedId: blockedId,
      blockedName: blockedName,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await _blocks.doc(id).set(entry.toJson());
  }

  @override
  Future<void> unblock(String blockerId, String blockedId) =>
      _blocks.doc(blockId(blockerId, blockedId)).delete();
}
