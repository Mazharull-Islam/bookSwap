import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocked_user.freezed.dart';
part 'blocked_user.g.dart';

@freezed
abstract class BlockedUser with _$BlockedUser {
  const factory BlockedUser({
    /// '${blockerId}_${blockedId}' — deterministic so the /requests create
    /// rule can do a targeted `exists()` check without needing read access
    /// to this collection (blocks are private to the blocker).
    required String id,
    required String blockerId,
    required String blockedId,
    required String blockedName,
    required int createdAtMs,
  }) = _BlockedUser;

  factory BlockedUser.fromJson(Map<String, dynamic> json) =>
      _$BlockedUserFromJson(json);
}

String blockId(String blockerId, String blockedId) => '${blockerId}_$blockedId';
