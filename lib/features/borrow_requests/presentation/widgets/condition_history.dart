import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../domain/loan_condition.dart';
import '../providers/request_providers.dart';

const _maxShown = 5;

/// A book's past loans and the condition it went out and came back in —
/// SRS §3.5's condition history, from the lender's own request records.
class ConditionHistory extends ConsumerWidget {
  const ConditionHistory({super.key, required this.bookId});
  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans =
        (ref.watch(incomingRequestsProvider).valueOrNull ?? const [])
            .where((r) => r.bookId == bookId && r.returnedAt != null)
            .toList()
          ..sort((a, b) => b.returnedAt!.compareTo(a.returnedAt!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading('Condition history'),
        const SizedBox(height: 6),
        if (loans.isEmpty)
          Text(
            'No completed loans yet.',
            style: Theme.of(context).textTheme.bodySmall,
          )
        else
          for (final loan in loans.take(_maxShown))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Semantics(
                container: true,
                label:
                    'Returned ${formatDateMs(loan.returnedAt!)}: '
                    '${loan.conditionOut ?? 'condition not recorded'}'
                    '${loan.conditionIn == null ? '' : ' to ${loan.conditionIn}'}'
                    '${loan.conditionFlagged ? '. Came back worse.' : ''}',
                excludeSemantics: true,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatDateMs(loan.returnedAt!),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    if (loan.conditionFlagged)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: context.colors.warningText,
                        ),
                      ),
                    Text(
                      loan.conditionOut == null && loan.conditionIn == null
                          ? 'Not recorded'
                          : '${loan.conditionOut ?? '?'} → '
                                '${loan.conditionIn ?? '?'}',
                      style: TextStyle(
                        color: loan.conditionFlagged
                            ? context.colors.warningText
                            : context.colors.text,
                        fontWeight: loan.conditionFlagged
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
