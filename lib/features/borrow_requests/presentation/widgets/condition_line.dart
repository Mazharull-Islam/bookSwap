import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/utils/friendly_error.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../application/use_cases/request_use_cases.dart';
import '../../domain/loan_condition.dart';
import '../../domain/models/borrow_request.dart';
import '../../domain/repositories/request_repository.dart';
import '../providers/request_providers.dart';

/// "Condition when lent: Good", or once returned "Good → Fair", with the
/// worse-than-lent case spelled out in words as well as colour.
class ConditionLine extends StatelessWidget {
  const ConditionLine(this.request, {super.key});
  final BorrowRequest request;

  @override
  Widget build(BuildContext context) {
    final out = request.conditionOut;
    final returned = request.conditionIn;
    if (out == null && returned == null) return const SizedBox.shrink();
    final String text;
    if (out != null && returned != null) {
      text = 'Condition: $out → $returned';
    } else if (returned != null) {
      text = 'Returned in $returned condition';
    } else {
      text = 'Condition when lent: $out';
    }
    final flagged = request.conditionFlagged;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Semantics(
        label: flagged ? '$text. Worse than when it was lent.' : text,
        excludeSemantics: true,
        child: Row(
          children: [
            if (flagged) ...[
              Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: context.colors.warningText,
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                flagged ? '$text · came back worse' : text,
                style: TextStyle(
                  color: flagged
                      ? context.colors.warningText
                      : context.colors.textMuted,
                  fontWeight: flagged ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// On a return flagged as worse: the borrower can explain it, and both
/// sides can read the explanation. Renders nothing for unflagged loans.
class BorrowerNoteSection extends ConsumerWidget {
  const BorrowerNoteSection({
    super.key,
    required this.request,
    required this.viewerIsBorrower,
  });
  final BorrowRequest request;
  final bool viewerIsBorrower;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!request.conditionFlagged) return const SizedBox.shrink();
    final note = request.borrowerNote;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note != null)
            Text(
              viewerIsBorrower ? 'Your note: $note' : "Borrower's note: $note",
            ),
          if (viewerIsBorrower)
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                key: Key('add-note-${request.id}'),
                onPressed: () => showBorrowerNoteDialog(context, request),
                icon: const Icon(Icons.edit_note),
                label: Text(note == null ? 'Add a note' : 'Edit note'),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> showBorrowerNoteDialog(
  BuildContext context,
  BorrowRequest request,
) => showDialog<void>(
  context: context,
  builder: (_) => _NoteDialog(request: request),
);

class _NoteDialog extends ConsumerStatefulWidget {
  const _NoteDialog({required this.request});
  final BorrowRequest request;

  @override
  ConsumerState<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends ConsumerState<_NoteDialog> {
  late final _text = TextEditingController(text: widget.request.borrowerNote);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(addBorrowerNoteProvider)(widget.request.id, _text.text);
      if (mounted) Navigator.of(context).pop();
    } on RequestValidationFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = friendlyError(
            e,
            fallback: 'Could not save your note. Please try again.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      'Explain the condition',
      style: Theme.of(context).textTheme.titleLarge,
    ),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${widget.request.bookTitle}" came back as '
            '${widget.request.conditionIn} (it went out as '
            '${widget.request.conditionOut}). A short note helps the lender '
            'understand what happened.',
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('borrowerNoteField'),
            controller: _text,
            enabled: !_saving,
            maxLines: 4,
            maxLength: maxBorrowerNoteLength,
            decoration: const InputDecoration(
              labelText: 'Your note',
              alignLabelWithHint: true,
            ),
          ),
          if (_error != null)
            Semantics(
              liveRegion: true,
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    ),
    actions: [
      OverflowBar(
        alignment: MainAxisAlignment.end,
        overflowAlignment: OverflowBarAlignment.end,
        spacing: 8,
        overflowSpacing: 8,
        children: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            buttonKey: const Key('saveNote'),
            label: 'Save note',
            onPressed: _save,
            loading: _saving,
            loadingSemanticLabel: 'Saving',
          ),
        ],
      ),
    ],
  );
}
