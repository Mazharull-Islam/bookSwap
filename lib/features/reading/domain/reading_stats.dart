import '../../books/domain/book_genres.dart';
import 'entities/reading_entry.dart';
import 'entities/reading_goal.dart';

/// Books marked Read whose last update falls inside the goal's window. An
/// approximation, not an exact "finished on" date — [ReadingEntry] doesn't
/// track a separate completion timestamp, so editing an old Read entry's
/// rating/review during a new goal period would (re-)count it. Acceptable
/// for a personal, single-user stat with no cross-user consequence.
int countReadInGoalPeriod(List<ReadingEntry> entries, ReadingGoal goal) {
  final periodEnd =
      goal.startedAtMs + goal.periodDays * Duration.millisecondsPerDay;
  return entries
      .where(
        (e) =>
            e.status == ReadingStatus.read &&
            e.updatedAtMs >= goal.startedAtMs &&
            e.updatedAtMs <= periodEnd,
      )
      .length;
}

int totalBooksRead(List<ReadingEntry> entries) =>
    entries.where((e) => e.status == ReadingStatus.read).length;

Set<String> genresExplored(List<ReadingEntry> entries) => entries
    .where((e) => e.status == ReadingStatus.read)
    .expand((e) => bookGenreList(e.genre))
    .toSet();

const goalPeriodOptions = [30, 90, 180, 365];

String goalPeriodLabel(int days) => switch (days) {
  30 => '1 month',
  90 => '3 months',
  180 => '6 months',
  365 => '1 year',
  _ => '$days days',
};
