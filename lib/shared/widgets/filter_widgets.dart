import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import 'section_heading.dart';
import 'primary_button.dart';

/// Search-row companion: a tune icon that shows how many filters are on.
class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.count, required this.onPressed});
  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: 'Filters',
    onPressed: onPressed,
    icon: Badge.count(
      count: count,
      isLabelVisible: count > 0,
      child: const Icon(Icons.tune),
    ),
  );
}

Future<void> showFilterSheet(
  BuildContext context, {
  required WidgetBuilder builder,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: builder,
);

/// Title row with a Clear action, then the sheet's filter sections.
class FilterSheetFrame extends StatelessWidget {
  const FilterSheetFrame({
    super.key,
    required this.onClear,
    required this.children,
  });
  final VoidCallback onClear;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: SectionHeading('Filters', fontSize: 18)),
            TextButton(onPressed: onClear, child: const Text('Clear all')),
          ],
        ),
        ...children,
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label: 'Done',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    ),
  );
}

class FilterSection extends StatelessWidget {
  const FilterSection({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: context.colors.textMuted)),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

/// Multi-select chips; an empty selection means "no filter".
class MultiChipGroup<T> extends StatelessWidget {
  const MultiChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });
  final List<T> options;
  final Set<T> selected;
  final String Function(T) labelOf;
  final ValueChanged<Set<T>> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 4,
    children: [
      for (final option in options)
        FilterChip(
          label: Text(labelOf(option)),
          selected: selected.contains(option),
          onSelected: (on) => onChanged(
            on ? {...selected, option} : ({...selected}..remove(option)),
          ),
        ),
    ],
  );
}

/// Single-select chips for sort order and similar.
class SingleChipGroup<T> extends StatelessWidget {
  const SingleChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 4,
    children: [
      for (final option in options)
        ChoiceChip(
          label: Text(labelOf(option)),
          selected: option == selected,
          onSelected: (_) => onChanged(option),
        ),
    ],
  );
}
