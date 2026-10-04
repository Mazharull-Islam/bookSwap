import 'package:bookswap_login/features/blocking/domain/entities/blocked_user.dart';
import 'package:bookswap_login/features/blocking/domain/repositories/block_repository.dart';

/// Records blocks instead of writing to Firestore.
class FakeBlockRepository implements BlockRepository {
  /// "blockerId>blockedId:name" for each block made.
  final blocked = <String>[];

  @override
  Future<void> block({
    required String blockerId,
    required String blockedId,
    required String blockedName,
  }) async => blocked.add('$blockerId>$blockedId:$blockedName');

  @override
  Future<void> unblock(String blockerId, String blockedId) async {}

  @override
  Stream<List<BlockedUser>> watchMine(String blockerId) => const Stream.empty();
}
