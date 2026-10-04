import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/filter_widgets.dart';
import '../../../books/domain/models/book.dart';
import '../../domain/loan_condition.dart';
import '../../domain/models/borrow_request.dart';

/// Asks the lender to confirm the return and record the book's condition.
/// Resolves to the chosen condition, or null if cancelled.
Future<String?> showReturnDialog(BuildContext context, BorrowRequest request) =>
    showDialog<String>(
      context: context,
      builder: (_) => _ReturnDialog(request: request),
    );

class _ReturnDialog extends StatefulWidget {
  const _ReturnDialog({required this.request});
  final BorrowRequest request;

  @override
  State<_ReturnDialog> createState() => _ReturnDialogState();
}

class _ReturnDialogState extends State<_ReturnDialog> {
  late String _condition = widget.request.conditionOut ?? 'Good';

  @override
  Widget build(BuildContext context) {
    final out = widget.request.conditionOut;
    final worse = conditionWorsened(out, _condition);
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Mark as returned?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm you have "${widget.request.bookTitle}" back, and '
              'choose the condition it came back in.',
            ),
            if (out != null) ...[
              const SizedBox(height: 8),
              Text(
                'When you lent it: $out',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            SingleChipGroup<String>(
              options: bookConditionOptions,
              selected: _condition,
              labelOf: (c) => c,
              onChanged: (c) => setState(() => _condition = c),
            ),
            const SizedBox(height: 12),
            if (worse)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.warningSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'This is worse than when it went out ($out). It will be '
                  'noted on the borrower\'s record, and they can add a note. '
                  'It can\'t be undone.',
                  style: TextStyle(color: context.colors.warningText),
                ),
              )
            else
              Text(
                'This can\'t be undone.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(_condition),
          child: const Text('Mark as returned'),
        ),
      ],
    );
  }
}
