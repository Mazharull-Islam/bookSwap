import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../borrow_requests/domain/models/borrow_request.dart';
import '../../../borrow_requests/presentation/providers/request_providers.dart';
import '../../domain/models/reading_entry.dart';
import '../../domain/models/reading_goal.dart';
import '../../domain/reading_stats.dart';
import '../providers/reading_goal_providers.dart';
import '../providers/reading_providers.dart';
import 'reading_goal_dialog.dart';

class ReadingStatsTab extends ConsumerWidget {
  const ReadingStatsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries =
        ref.watch(myReadingProvider).valueOrNull ?? const <ReadingEntry>[];
    final goal = ref.watch(myReadingGoalProvider).valueOrNull;
    final lent =
        ref
            .watch(incomingRequestsProvider)
            .valueOrNull
            ?.where((r) => r.status == RequestStatus.accepted)
            .length ??
        0;
    final borrowed =
        ref
            .watch(outgoingRequestsProvider)
            .valueOrNull
            ?.where((r) => r.status == RequestStatus.accepted)
            .length ??
        0;
    final totalRead = totalBooksRead(entries);
    final genres = genresExplored(entries);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _GoalCard(goal: goal, entries: entries),
        const SizedBox(height: 20),
        const Text(
          'Your stats',
          style: TextStyle(fontWeight: FontWeight.w700, color: forest),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _StatTile(label: 'Books read', value: '$totalRead'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                label: 'Genres explored',
                value: '${genres.length}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(label: 'Books lent', value: '$lent'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(label: 'Books borrowed', value: '$borrowed'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.ios_share),
            label: const Text('Copy shareable summary'),
            onPressed: () => _copySummary(
              context,
              totalRead: totalRead,
              genreCount: genres.length,
              lent: lent,
              borrowed: borrowed,
              goal: goal,
              entries: entries,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _copySummary(
    BuildContext context, {
    required int totalRead,
    required int genreCount,
    required int lent,
    required int borrowed,
    required ReadingGoal? goal,
    required List<ReadingEntry> entries,
  }) async {
    final buffer = StringBuffer()
      ..writeln('My BookSwap reading recap 📚')
      ..writeln('$totalRead books read · $genreCount genres explored')
      ..writeln('$lent lent · $borrowed borrowed');
    if (goal != null) {
      final progress = countReadInGoalPeriod(entries, goal);
      final metGoal = progress >= goal.targetCount;
      buffer.writeln(
        'Goal: $progress/${goal.targetCount} books '
        '(${goalPeriodLabel(goal.periodDays)})'
        '${metGoal ? ' 🏆 met!' : ''}',
      );
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Summary copied to clipboard')),
      );
    }
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.goal, required this.entries});
  final ReadingGoal? goal;
  final List<ReadingEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (goal == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE9EEDF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'No reading goal set',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Set a target to track your progress over time.',
              style: TextStyle(color: Color(0xFF617065)),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Set a goal',
              onPressed: () => showReadingGoalDialog(context, null),
            ),
          ],
        ),
      );
    }
    final progress = countReadInGoalPeriod(entries, goal!);
    final metGoal = progress >= goal!.targetCount;
    final ratio = goal!.targetCount == 0
        ? 0.0
        : (progress / goal!.targetCount).clamp(0, 1).toDouble();
    const goldColor = Color(0xFFCB9A3B);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: metGoal ? const Color(0xFFFBF1DC) : const Color(0xFFE9EEDF),
        borderRadius: BorderRadius.circular(14),
        border: metGoal ? Border.all(color: goldColor) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Reading goal',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                goalPeriodLabel(goal!.periodDays),
                style: const TextStyle(color: Color(0xFF617065), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: Colors.white,
              color: metGoal ? goldColor : forest,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('$progress / ${goal!.targetCount} books'),
              if (metGoal) ...[
                const SizedBox(width: 8),
                const Icon(Icons.emoji_events, color: goldColor, size: 18),
                const SizedBox(width: 4),
                const Text(
                  'Goal met!',
                  style: TextStyle(
                    color: goldColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: () => showReadingGoalDialog(context, goal),
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(clearReadingGoalProvider)(goal!.userId),
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFD6DED5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: forest,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF617065), fontSize: 12),
        ),
      ],
    ),
  );
}
