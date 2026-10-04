import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../reviews/presentation/widgets/review_loan_action.dart';
import '../providers/request_providers.dart';
import 'condition_line.dart';
import 'request_card.dart';

/// Loans that have come back, newest first, from both sides: books I lent and
/// books I borrowed.
class RequestHistoryTab extends ConsumerWidget {
  const RequestHistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incoming =
        ref.watch(incomingRequestsProvider).valueOrNull ?? const [];
    final outgoing =
        ref.watch(outgoingRequestsProvider).valueOrNull ?? const [];
    final lent = incoming
        .where((r) => r.returnedAt != null)
        .map((r) => (request: r, lent: true));
    final borrowed = outgoing
        .where((r) => r.returnedAt != null)
        .map((r) => (request: r, lent: false));
    final loans = [...lent, ...borrowed]
      ..sort((a, b) => b.request.returnedAt!.compareTo(a.request.returnedAt!));
    if (loans.isEmpty) {
      return const EmptyState(
        icon: Icons.history,
        message: 'Past loans will show up here once a loan is marked returned.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return RequestCard(
          request: loan.request,
          otherPartyId: loan.lent
              ? loan.request.borrowerId
              : loan.request.lenderId,
          footer: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${loan.lent ? 'Lent' : 'Borrowed'} · Returned ${formatDateMs(loan.request.returnedAt!)}',
                style: TextStyle(color: context.colors.textMuted),
              ),
              ConditionLine(loan.request),
              BorrowerNoteSection(
                request: loan.request,
                viewerIsBorrower: !loan.lent,
              ),
              // Only the borrower reviews a book, and only once it's back.
              if (!loan.lent) ...[
                const SizedBox(height: 8),
                ReviewLoanAction(request: loan.request),
              ],
            ],
          ),
        );
      },
    );
  }
}
