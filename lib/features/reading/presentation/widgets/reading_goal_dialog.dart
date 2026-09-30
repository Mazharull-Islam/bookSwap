import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/models/reading_goal.dart';
import '../../domain/reading_stats.dart';
import '../providers/reading_goal_providers.dart';

Future<void> showReadingGoalDialog(BuildContext context, ReadingGoal? current) {
  return showDialog(
    context: context,
    builder: (context) => _ReadingGoalDialog(current: current),
  );
}

class _ReadingGoalDialog extends ConsumerStatefulWidget {
  const _ReadingGoalDialog({required this.current});
  final ReadingGoal? current;

  @override
  ConsumerState<_ReadingGoalDialog> createState() => _ReadingGoalDialogState();
}

class _ReadingGoalDialogState extends ConsumerState<_ReadingGoalDialog> {
  late final _target = TextEditingController(
    text: (widget.current?.targetCount ?? 12).toString(),
  );
  late int _periodDays = widget.current?.periodDays ?? 365;
  bool _saving = false;

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final target = int.tryParse(_target.text);
    if (target == null || target <= 0) return;
    setState(() => _saving = true);
    await ref.read(setReadingGoalProvider)(
      ReadingGoal(
        userId: ref.read(currentUserProvider).id,
        targetCount: target,
        // Editing restarts the tracking window from now, same as setting a
        // fresh goal — there's no history of past periods kept.
        startedAtMs: DateTime.now().millisecondsSinceEpoch,
        periodDays: _periodDays,
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.current == null ? 'Set a reading goal' : 'Edit goal'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _target,
          enabled: !_saving,
          keyboardType: TextInputType.number,
          label: 'Target number of books',
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: _periodDays,
          decoration: const InputDecoration(labelText: 'Over'),
          items: goalPeriodOptions
              .map(
                (days) => DropdownMenuItem(
                  value: days,
                  child: Text(goalPeriodLabel(days)),
                ),
              )
              .toList(),
          onChanged: _saving
              ? null
              : (value) => setState(() => _periodDays = value!),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      PrimaryButton(label: 'Save', onPressed: _save, loading: _saving),
    ],
  );
}
