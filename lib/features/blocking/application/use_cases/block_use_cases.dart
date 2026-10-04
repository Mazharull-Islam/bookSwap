import '../../domain/repositories/block_repository.dart';

class BlockUser {
  const BlockUser(this.repository);
  final BlockRepository repository;

  Future<void> call({
    required String blockerId,
    required String blockedId,
    required String blockedName,
  }) => repository.block(
    blockerId: blockerId,
    blockedId: blockedId,
    blockedName: blockedName,
  );
}

class UnblockUser {
  const UnblockUser(this.repository);
  final BlockRepository repository;

  Future<void> call(String blockerId, String blockedId) =>
      repository.unblock(blockerId, blockedId);
}
