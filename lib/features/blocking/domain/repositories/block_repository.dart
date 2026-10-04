import '../entities/blocked_user.dart';

class BlockValidationFailure implements Exception {
  const BlockValidationFailure(this.message);
  final String message;
}

abstract interface class BlockRepository {
  Stream<List<BlockedUser>> watchMine(String blockerId);

  Future<void> block({
    required String blockerId,
    required String blockedId,
    required String blockedName,
  });

  Future<void> unblock(String blockerId, String blockedId);
}
