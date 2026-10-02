import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/theme.dart';
import '../../../../core/services/public_profile_service.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../../blocking/presentation/providers/block_providers.dart';
import '../../domain/models/borrow_request.dart';
import '../providers/request_providers.dart';
import '../widgets/request_card.dart';

String _formatDate(int ms) => DateTime.fromMillisecondsSinceEpoch(
  ms,
).toLocal().toString().split(' ').first;

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Incoming'),
            Tab(text: 'Outgoing'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [_IncomingTab(), _OutgoingTab(), _HistoryTab()],
      ),
    ),
  );
}

class _IncomingTab extends ConsumerWidget {
  const _IncomingTab();

  Future<void> _accept(
    BuildContext context,
    WidgetRef ref,
    BorrowRequest request,
  ) async {
    final myMobile = ref
        .read(authControllerProvider)
        .valueOrNull
        ?.profile
        ?.mobile;
    if (myMobile == null || myMobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Add a mobile number to your profile before accepting.',
          ),
        ),
      );
      return;
    }
    final returnDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 14)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Expected return date',
    );
    if (returnDate == null) return;
    try {
      await ref.read(acceptBorrowRequestProvider)(
        request.id,
        bookId: request.bookId,
        expectedReturnDate: returnDate,
        lenderContact: myMobile,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _decline(WidgetRef ref, BorrowRequest request) =>
      ref.read(declineBorrowRequestProvider)(request.id);

  Future<void> _markReturned(
    BuildContext context,
    WidgetRef ref,
    BorrowRequest request,
  ) async {
    try {
      await ref.read(markLoanReturnedProvider)(
        request.id,
        bookId: request.bookId,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not mark as returned: $e')),
        );
      }
    }
  }

  Future<void> _resolveExtension(
    WidgetRef ref,
    BorrowRequest request, {
    required bool approve,
  }) => ref.read(resolveLoanExtensionProvider)(request.id, approve: approve);

  Future<void> _block(
    BuildContext context,
    WidgetRef ref,
    BorrowRequest request,
  ) async {
    final name =
        ref.read(displayNameProvider(request.borrowerId)).valueOrNull ??
        'this user';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block $name?'),
        content: Text(
          "$name won't be able to send you new borrow requests. "
          'You can unblock them later from your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Block',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(blockUserProvider)(
      blockerId: ref.read(currentUserProvider).id,
      blockedId: request.borrowerId,
      blockedName: name,
    );
    // A block covers future requests, not this one — clean up the existing
    // pending one at the same time so it doesn't linger.
    if (request.status == RequestStatus.pending) {
      await _decline(ref, request);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Blocked $name.')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(incomingRequestsProvider);
    return requests.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => const _Hint(
        icon: Icons.error_outline,
        text: 'Could not load requests. Please try again.',
      ),
      data: (all) {
        final requests = all.where((r) => r.returnedAt == null).toList();
        if (requests.isEmpty) {
          return const _Hint(
            icon: Icons.inbox_outlined,
            text: 'No one has requested your books yet.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return RequestCard(
              request: request,
              otherPartyId: request.borrowerId,
              onBlock: () => _block(context, ref, request),
              footer: switch (request.status) {
                RequestStatus.pending => Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _decline(ref, request),
                        child: const Text('Decline'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Accept',
                        onPressed: () => _accept(context, ref, request),
                      ),
                    ),
                  ],
                ),
                RequestStatus.accepted => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.borrowerContact == null
                          ? 'Waiting for the borrower to share their contact.'
                          : 'Borrower contact: ${request.borrowerContact}',
                      style: const TextStyle(color: Color(0xFF617065)),
                    ),
                    if (request.expectedReturnDateMs != null)
                      Text(
                        'Return by: ${_formatDate(request.expectedReturnDateMs!)}'
                        '${isOverdue(request) ? ' (overdue)' : ''}',
                        style: TextStyle(
                          color: isOverdue(request)
                              ? const Color(0xFFB3261E)
                              : const Color(0xFF617065),
                          fontWeight: isOverdue(request)
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    if (request.proposedReturnDateMs != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Extension requested: ${_formatDate(request.proposedReturnDateMs!)}',
                        style: const TextStyle(
                          color: Color(0xFFB16C46),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _resolveExtension(
                                ref,
                                request,
                                approve: false,
                              ),
                              child: const Text('Decline'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Approve',
                              onPressed: () => _resolveExtension(
                                ref,
                                request,
                                approve: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _markReturned(context, ref, request),
                        child: const Text('Mark as returned'),
                      ),
                    ),
                  ],
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

class _OutgoingTab extends ConsumerWidget {
  const _OutgoingTab();

  Future<void> _shareContact(WidgetRef ref, BorrowRequest request) async {
    final myMobile = ref
        .read(authControllerProvider)
        .valueOrNull
        ?.profile
        ?.mobile;
    if (myMobile == null || myMobile.isEmpty) return;
    await ref.read(shareBorrowerContactProvider)(request.id, myMobile);
  }

  Future<void> _requestExtension(
    BuildContext context,
    WidgetRef ref,
    BorrowRequest request,
  ) async {
    final current = request.expectedReturnDateMs != null
        ? DateTime.fromMillisecondsSinceEpoch(request.expectedReturnDateMs!)
        : DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: current.add(const Duration(days: 7)),
      firstDate: current.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Proposed new return date',
    );
    if (newDate == null) return;
    try {
      await ref.read(requestLoanExtensionProvider)(request.id, newDate);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not request an extension: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(outgoingRequestsProvider);
    return requests.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => const _Hint(
        icon: Icons.error_outline,
        text: 'Could not load requests. Please try again.',
      ),
      data: (all) {
        final requests = all.where((r) => r.returnedAt == null).toList();
        if (requests.isEmpty) {
          return const _Hint(
            icon: Icons.outbox_outlined,
            text: "You haven't requested any books yet.",
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return RequestCard(
              request: request,
              otherPartyId: request.lenderId,
              footer: switch (request.status) {
                RequestStatus.pending => const Text(
                  'Waiting for the owner to respond.',
                  style: TextStyle(color: Color(0xFF617065)),
                ),
                RequestStatus.accepted => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Owner contact: ${request.lenderContact ?? 'unavailable'}',
                      style: const TextStyle(color: Color(0xFF617065)),
                    ),
                    if (request.expectedReturnDateMs != null)
                      Text(
                        'Return by: ${_formatDate(request.expectedReturnDateMs!)}'
                        '${isOverdue(request) ? ' (overdue)' : ''}',
                        style: TextStyle(
                          color: isOverdue(request)
                              ? const Color(0xFFB3261E)
                              : const Color(0xFF617065),
                          fontWeight: isOverdue(request)
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    if (request.borrowerContact == null) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _shareContact(ref, request),
                          child: const Text('Share my contact'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    if (request.proposedReturnDateMs != null)
                      Text(
                        'Extension requested: awaiting approval '
                        '(until ${_formatDate(request.proposedReturnDateMs!)})',
                        style: const TextStyle(
                          color: Color(0xFFB16C46),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              _requestExtension(context, ref, request),
                          child: const Text('Request extension'),
                        ),
                      ),
                  ],
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

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

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
      return const _Hint(
        icon: Icons.history,
        text: 'Past loans will show up here once a loan is marked returned.',
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
          footer: Text(
            '${loan.lent ? 'Lent' : 'Borrowed'} · Returned ${_formatDate(loan.request.returnedAt!)}',
            style: const TextStyle(color: Color(0xFF617065)),
          ),
        );
      },
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: forest),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF617065)),
          ),
        ],
      ),
    ),
  );
}
