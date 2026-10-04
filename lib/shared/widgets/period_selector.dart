import 'package:flutter/material.dart';
import '../domain/period.dart';

/// A row of month chips for looking back at earlier months ("October 2026",
/// "September 2026", ...). The selected month is highlighted.
class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.periods,
    required this.selected,
    required this.onSelected,
  });

  /// Period ids ("2026-10"), newest first.
  final List<String> periods;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 4,
    children: [
      for (final period in periods)
        ChoiceChip(
          label: Text(periodLabel(period)),
          selected: period == selected,
          onSelected: (_) => onSelected(period),
        ),
    ],
  );
}
