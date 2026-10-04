import 'package:flutter/material.dart';
import '../../domain/entities/forum_report.dart';
import '../../../../shared/widgets/feedback.dart';

/// Asks why the member is reporting. Returns null if they cancel.
Future<ForumReportReason?> showReportDialog(
  BuildContext context, {
  required String what,
}) => showDialog<ForumReportReason>(
  context: context,
  builder: (context) => _ReportDialog(what: what),
);

class _ReportDialog extends StatefulWidget {
  const _ReportDialog({required this.what});
  final String what;

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  ForumReportReason? _reason;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('Report this ${widget.what}'),
    content: SingleChildScrollView(
      child: RadioGroup<ForumReportReason>(
        groupValue: _reason,
        onChanged: (value) => setState(() => _reason = value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reports are reviewed by moderators. It disappears for you '
              'straight away, and for everyone once several members report it.',
            ),
            const SizedBox(height: 8),
            for (final reason in ForumReportReason.values)
              RadioListTile<ForumReportReason>(
                value: reason,
                title: Text(reason.label),
                contentPadding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: _reason == null
            ? null
            : () => Navigator.of(context).pop(_reason),
        child: const Text('Report'),
      ),
    ],
  );
}

/// "Delete this post?" — returns true only if the member confirms.
Future<bool> confirmRemoval(
  BuildContext context, {
  required String what,
  bool asModerator = false,
}) => showConfirmDialog(
  context,
  title: asModerator ? 'Remove this $what?' : 'Delete this $what?',
  message: asModerator
      ? "It will be removed for everyone. This can't be undone."
      : "It will be deleted for everyone. This can't be undone.",
  confirmLabel: asModerator ? 'Remove' : 'Delete',
);
