class BlockedUser {
  const BlockedUser({
    required this.id,
    required this.blockerId,
    required this.blockedId,
    required this.blockedName,
    required this.createdAtMs,
  });

  /// '${blockerId}_${blockedId}' — deterministic so the /requests create
  /// rule can do a targeted `exists()` check without needing read access
  /// to this collection (blocks are private to the blocker).
  final String id;

  final String blockerId;

  final String blockedId;

  final String blockedName;

  final int createdAtMs;

  BlockedUser copyWith({
    String? id,
    String? blockerId,
    String? blockedId,
    String? blockedName,
    int? createdAtMs,
  }) => BlockedUser(
    id: id ?? this.id,
    blockerId: blockerId ?? this.blockerId,
    blockedId: blockedId ?? this.blockedId,
    blockedName: blockedName ?? this.blockedName,
    createdAtMs: createdAtMs ?? this.createdAtMs,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockedUser &&
          id == other.id &&
          blockerId == other.blockerId &&
          blockedId == other.blockedId &&
          blockedName == other.blockedName &&
          createdAtMs == other.createdAtMs;

  @override
  int get hashCode => Object.hashAll([
    BlockedUser,
    id,
    blockerId,
    blockedId,
    blockedName,
    createdAtMs,
  ]);

  @override
  String toString() => 'BlockedUser(id: $id)';
}

String blockId(String blockerId, String blockedId) => '${blockerId}_$blockedId';
