import '../../borrow_requests/domain/loan_condition.dart';
import '../../borrow_requests/domain/entities/borrow_request.dart';
import 'entities/achievement_badge.dart';

bool _isCompleted(BorrowRequest r) =>
    r.status == RequestStatus.accepted && r.returnedAt != null;

bool _wasOnTime(BorrowRequest r) =>
    r.expectedReturnDateMs == null || r.returnedAt! <= r.expectedReturnDateMs!;

/// Reflects "successful lending and returning behaviour" (SRS §3.1) as one
/// combined on-time rate across every completed loan, whichever side of it
/// you were on — simpler and more explainable than separately weighting
/// lending vs. borrowing, and avoids rewarding/penalizing a lender for a
/// borrower's return promptness, which isn't something the lender controls.
class ReliabilityStats {
  const ReliabilityStats({required this.completed, required this.onTime});
  final int completed;
  final int onTime;

  /// Null (rather than 0) when there's no history yet, so the UI can show
  /// "not enough history" instead of a misleading 0%.
  double? get percent => completed == 0 ? null : onTime / completed * 100;
}

ReliabilityStats computeReliability({
  required List<BorrowRequest> incoming,
  required List<BorrowRequest> outgoing,
}) {
  final completedLoans = [
    ...incoming,
    ...outgoing,
  ].where(_isCompleted).toList();
  final onTime = completedLoans.where(_wasOnTime).length;
  return ReliabilityStats(completed: completedLoans.length, onTime: onTime);
}

List<AchievementBadge> computeEarnedBadges({
  required List<BorrowRequest> incoming,
  required List<BorrowRequest> outgoing,
  required int booksRead,
}) {
  final completedAsLender = incoming.where(_isCompleted).toList();
  final completedAsBorrower = outgoing.where(_isCompleted).toList();
  final onTimeAsBorrower = completedAsBorrower.where(_wasOnTime).length;

  final badges = <AchievementBadge>[];
  if (completedAsLender.length + completedAsBorrower.length >= 1) {
    badges.add(AchievementBadge.firstLoan);
  }
  if (completedAsBorrower.length >= 5 &&
      onTimeAsBorrower == completedAsBorrower.length) {
    badges.add(AchievementBadge.trustedBorrower);
  }
  if (completedAsLender.length >= 10) {
    badges.add(AchievementBadge.superLender);
  }
  if (completedAsBorrower.length >= 5) {
    badges.add(AchievementBadge.avidBorrower);
  }
  if (booksRead >= 10) {
    badges.add(AchievementBadge.bookworm);
  }
  return badges;
}

/// How the books you borrowed came back, from the lender's recorded
/// conditions. Informational only — it never changes a score or a badge.
class ConditionRecord {
  const ConditionRecord({required this.recorded, required this.flagged});

  /// Returned loans where both conditions were recorded.
  final int recorded;

  /// Of those, how many came back worse than they went out.
  final int flagged;
}

ConditionRecord computeConditionRecord(List<BorrowRequest> outgoing) {
  final recorded = outgoing
      .where(
        (r) =>
            _isCompleted(r) && r.conditionOut != null && r.conditionIn != null,
      )
      .toList();
  return ConditionRecord(
    recorded: recorded.length,
    flagged: recorded.where((r) => r.conditionFlagged).length,
  );
}
