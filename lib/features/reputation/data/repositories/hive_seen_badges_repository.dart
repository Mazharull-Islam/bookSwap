import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_service.dart';
import '../../domain/repositories/seen_badges_repository.dart';

/// Device-local only — which badges this device has already toasted for a
/// given user, so the same badge doesn't notify again every time the
/// provider recomputes. Deliberately separate from the badges themselves
/// (always recomputed live from Requests/Reading) — this is purely a
/// notification dedupe log.
class HiveSeenBadgesRepository implements SeenBadgesRepository {
  Box<List> get _box => HiveService.seenBadgesBox;

  /// False the very first time a user's badges are ever computed on this
  /// device — distinguishes "no notification history yet" (seed silently,
  /// no toast) from "history exists and is genuinely empty."
  @override
  bool hasBaseline(String userId) => _box.containsKey(userId);

  @override
  Set<String> getSeen(String userId) =>
      (_box.get(userId) ?? const []).cast<String>().toSet();

  @override
  Future<void> setSeen(String userId, Set<String> badgeNames) =>
      _box.put(userId, badgeNames.toList());
}
