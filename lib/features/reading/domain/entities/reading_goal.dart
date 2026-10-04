/// Marks "argument not passed" in [copyWith], so null can be passed on purpose.
const Object _keep = Object();

/// One active goal per user — setting a new one (or editing) replaces it
/// and restarts the tracking window from now, rather than keeping a history
/// of past goal periods.
class ReadingGoal {
  const ReadingGoal({
    required this.userId,
    required this.targetCount,
    required this.startedAtMs,
    required this.periodDays,
    this.updatedAtMs = 0,
    this.deletedAtMs,
  });

  final String userId;

  final int targetCount;

  final int startedAtMs;

  final int periodDays;

  /// Last change, for last-write-wins when syncing between devices.
  final int updatedAtMs;

  /// Set when the goal is cleared (soft delete, same reasoning as
  /// ReadingEntry.deletedAtMs).
  final int? deletedAtMs;

  ReadingGoal copyWith({
    String? userId,
    int? targetCount,
    int? startedAtMs,
    int? periodDays,
    int? updatedAtMs,
    Object? deletedAtMs = _keep,
  }) => ReadingGoal(
    userId: userId ?? this.userId,
    targetCount: targetCount ?? this.targetCount,
    startedAtMs: startedAtMs ?? this.startedAtMs,
    periodDays: periodDays ?? this.periodDays,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    deletedAtMs: identical(deletedAtMs, _keep)
        ? this.deletedAtMs
        : deletedAtMs as int?,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingGoal &&
          userId == other.userId &&
          targetCount == other.targetCount &&
          startedAtMs == other.startedAtMs &&
          periodDays == other.periodDays &&
          updatedAtMs == other.updatedAtMs &&
          deletedAtMs == other.deletedAtMs;

  @override
  int get hashCode => Object.hashAll([
    ReadingGoal,
    userId,
    targetCount,
    startedAtMs,
    periodDays,
    updatedAtMs,
    deletedAtMs,
  ]);

  @override
  String toString() => 'ReadingGoal(userId: $userId)';
}
