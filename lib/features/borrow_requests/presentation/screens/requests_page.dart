import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/services/public_profile_service.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/utils/friendly_error.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../../blocking/presentation/providers/block_providers.dart';
import '../../domain/models/borrow_request.dart';
import '../../domain/repositories/request_repository.dart';
import '../providers/request_providers.dart';
import '../widgets/request_card.dart';
import '../../../reviews/presentation/widgets/review_loan_action.dart';

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final scheme = Theme.of(context).colorScheme;
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: scheme.error,
                foregroundColor: scheme.onError,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        ),
      ) ??
      false;
}

void _showError(BuildContext context, Object error, String fallback) {
  if (!context.mounted) return;
  final message = error is RequestValidationFailure
      ? error.message
      : friendlyError(error, fallback: fallback);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// "Return by Oct 17, 2026 · due in 5 days" — overdue is in the words as well
/// as the colour.
class _ReturnLine extends StatelessWidget {
  const _ReturnLine(this.request);
  final BorrowRequest request;

  @override
  Widget build(BuildContext context) {
    final ms = request.expectedReturnDateMs!;
    final overdue = isOverdue(request);
    return Text(
      'Return by ${formatDateMs(ms)} · '
      '${dueText(DateTime.fromMillisecondsSinceEpoch(ms).toLocal())}',
      style: TextStyle(
        color: overdue ? context.colors.danger : context.colors.textMuted,
        fontWeight: overdue ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

/// Side by side when they fit, stacked full-width when they don't (large
/// text, narrow screens).
class _ActionPair extends StatelessWidget {
  const _ActionPair({required this.secondary, required this.primary});
  final Widget secondary;
  final Widget primary;

  @override
  Widget build(BuildContext context) => OverflowBar(
    alignment: MainAxisAlignment.end,
    overflowAlignment: OverflowBarAlignment.end,
    spacing: 8,
    overflowSpacing: 8,
    children: [secondary, primary],
  );
}

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
        _showError(context, e, 'Could not accept this request.');
      }
    }
  }

  Future<void> _decline(WidgetRef ref, BorrowRequest request) =>
      ref.read(declineBorrowRequestProvider)(request.id);

  Future<void> _confirmDecline(
    BuildContext context,
    WidgetRef ref,
    BorrowRequest request,
  ) async {
    final ok = await _confirm(
      context,
      title: 'Decline this request?',
      message:
          'The member will be told you declined, and "${request.bookTitle}" '
          "stays on your shelf. This can't be undone.",
      confirmLabel: 'Decline request',
    );
    if (!ok) return;
    try {
      await _decline(ref, request);
    } catch (e) {
      if (context.mounted) {
        _showError(context, e, 'Could not decline this request.');
      }
    }
  }

  Future<void> _markReturned(
    BuildContext context,
    WidgetRef ref,
    BorrowRequest request,
  ) async {
    final ok = await _confirm(
      context,
      title: 'Mark as returned?',
      message:
          'Confirm you have "${request.bookTitle}" back. It becomes available '
          "again and the loan moves to History. This can't be undone.",
      confirmLabel: 'Mark as returned',
    );
    if (!ok) return;
    try {
      await ref.read(markLoanReturnedProvider)(
        request.id,
        bookId: request.bookId,
      );
    } catch (e) {
      if (context.mounted) {
        _showError(context, e, 'Could not mark this loan as returned.');
      }
    }
  }

  Future<void> _resolveExtension(
    BuildContext context,
    WidgetRef ref,
    BorrowRequest request, {
    required bool approve,
  }) async {
    if (!approve) {
      final ok = await _confirm(
        context,
        title: 'Decline this extension?',
        message:
            'The return date stays '
            '${formatDateMs(request.expectedReturnDateMs!)}. This can\'t be '
            'undone.',
        confirmLabel: 'Decline extension',
      );
      if (!ok) return;
    }
    try {
      await ref.read(resolveLoanExtensionProvider)(
        request.id,
        approve: approve,
      );
    } catch (e) {
      if (context.mounted) {
        _showError(context, e, 'Could not update this extension.');
      }
    }
  }

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
                RequestStatus.pending => _ActionPair(
                  secondary: OutlinedButton(
                    onPressed: () => _confirmDecline(context, ref, request),
                    child: const Text('Decline request'),
                  ),
                  primary: PrimaryButton(
                    label: 'Accept request',
                    onPressed: () => _accept(context, ref, request),
                  ),
                ),
                RequestStatus.accepted => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.borrowerContact == null
                          ? 'Waiting for the borrower to share their contact.'
                          : 'Borrower contact: ${request.borrowerContact}',
                      style: TextStyle(color: context.colors.textMuted),
                    ),
                    if (request.expectedReturnDateMs != null)
                      _ReturnLine(request),
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
                      _ActionPair(
                        secondary: OutlinedButton(
                          onPressed: () => _resolveExtension(
                            context,
                            ref,
                            request,
                            approve: false,
                          ),
                          child: const Text('Decline extension'),
                        ),
                        primary: PrimaryButton(
                          label: 'Approve extension',
                          onPressed: () => _resolveExtension(
                            context,
                            ref,
                            request,
                            approve: true,
                          ),
                        ),
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
                RequestStatus.pending => Text(
                  'Waiting for the owner to respond.',
                  style: TextStyle(color: context.colors.textMuted),
                ),
                RequestStatus.accepted => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Owner contact: ${request.lenderContact ?? 'unavailable'}',
                      style: TextStyle(color: context.colors.textMuted),
                    ),
                    if (request.expectedReturnDateMs != null)
                      _ReturnLine(request),
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
          footer: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${loan.lent ? 'Lent' : 'Borrowed'} · Returned ${formatDateMs(loan.request.returnedAt!)}',
                style: TextStyle(color: context.colors.textMuted),
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
          Icon(icon, size: 56, color: context.colors.brand),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textMuted),
          ),
        ],
      ),
    ),
  );
}
