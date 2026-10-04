import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/entities/borrow_request.dart';
import '../providers/request_providers.dart';
import 'action_pair.dart';
import 'condition_line.dart';
import 'request_actions.dart';
import 'request_card.dart';
import 'return_line.dart';

/// Requests for books I own: accept or decline new ones, and manage the loans
/// that are out (extensions, marking returned).
class IncomingRequestsTab extends ConsumerWidget {
  const IncomingRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(incomingRequestsProvider);
    return requests.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => const EmptyState(
        icon: Icons.error_outline,
        message: 'Could not load requests. Please try again.',
      ),
      data: (all) {
        final requests = all.where((r) => r.returnedAt == null).toList();
        if (requests.isEmpty) {
          return const EmptyState(
            icon: Icons.inbox_outlined,
            message: 'No one has requested your books yet.',
          );
        }
        final actions = RequestActions(context, ref);
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return RequestCard(
              request: request,
              otherPartyId: request.borrowerId,
              onBlock: () => actions.block(request),
              footer: switch (request.status) {
                RequestStatus.pending => ActionPair(
                  secondary: SecondaryButton(
                    label: 'Decline request',
                    onPressed: () => actions.confirmDecline(request),
                  ),
                  primary: PrimaryButton(
                    label: 'Accept request',
                    onPressed: () => actions.accept(request),
                  ),
                ),
                RequestStatus.accepted => _ActiveLoanFooter(
                  request: request,
                  actions: actions,
                ),
                RequestStatus.declined => null,
              },
            );
          },
        );
      },
    );
  }
}

/// A loan I've lent out: the borrower's contact, the return date, any pending
/// extension to approve, and the button that ends the loan.
class _ActiveLoanFooter extends StatelessWidget {
  const _ActiveLoanFooter({required this.request, required this.actions});
  final BorrowRequest request;
  final RequestActions actions;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        request.borrowerContact == null
            ? 'Waiting for the borrower to share their contact.'
            : 'Borrower contact: ${request.borrowerContact}',
        style: TextStyle(color: context.colors.textMuted),
      ),
      ConditionLine(request),
      if (request.expectedReturnDateMs != null) ReturnLine(request),
      if (request.proposedReturnDateMs != null) ...[
        const SizedBox(height: 8),
        Text(
          'Extension requested until ${formatDateMs(request.proposedReturnDateMs!)}',
          style: TextStyle(
            color: context.colors.pending,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ActionPair(
          secondary: SecondaryButton(
            label: 'Decline extension',
            onPressed: () => actions.resolveExtension(request, approve: false),
          ),
          primary: PrimaryButton(
            label: 'Approve extension',
            onPressed: () => actions.resolveExtension(request, approve: true),
          ),
        ),
      ],
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: SecondaryButton(
          label: 'Mark as returned',
          onPressed: () => actions.markReturned(request),
        ),
      ),
    ],
  );
}
