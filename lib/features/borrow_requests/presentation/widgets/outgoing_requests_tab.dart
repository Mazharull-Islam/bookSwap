import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/entities/borrow_request.dart';
import '../providers/request_providers.dart';
import 'condition_line.dart';
import 'request_actions.dart';
import 'request_card.dart';
import 'return_line.dart';

/// Requests I've sent: waiting, or accepted loans I'm holding (share my
/// contact, ask for more time).
class OutgoingRequestsTab extends ConsumerWidget {
  const OutgoingRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(outgoingRequestsProvider);
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
            icon: Icons.outbox_outlined,
            message: "You haven't requested any books yet.",
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
              otherPartyId: request.lenderId,
              footer: switch (request.status) {
                RequestStatus.pending => Text(
                  'Waiting for the owner to respond.',
                  style: TextStyle(color: context.colors.textMuted),
                ),
                RequestStatus.accepted => _HeldLoanFooter(
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

/// A loan I'm borrowing: the owner's contact, the return date, and the
/// buttons for sharing my contact or asking for an extension.
class _HeldLoanFooter extends StatelessWidget {
  const _HeldLoanFooter({required this.request, required this.actions});
  final BorrowRequest request;
  final RequestActions actions;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Owner contact: ${request.lenderContact ?? 'unavailable'}',
        style: TextStyle(color: context.colors.textMuted),
      ),
      ConditionLine(request),
      if (request.expectedReturnDateMs != null) ReturnLine(request),
      if (request.borrowerContact == null) ...[
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            label: 'Share my contact',
            onPressed: () => actions.shareContact(request),
          ),
        ),
      ],
      const SizedBox(height: 8),
      if (request.proposedReturnDateMs != null)
        Text(
          'Extension requested until ${formatDateMs(request.proposedReturnDateMs!)}'
          ' — awaiting approval',
          style: TextStyle(
            color: context.colors.pending,
            fontWeight: FontWeight.w600,
          ),
        )
      else
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            label: 'Request extension',
            onPressed: () => actions.requestExtension(request),
          ),
        ),
    ],
  );
}
