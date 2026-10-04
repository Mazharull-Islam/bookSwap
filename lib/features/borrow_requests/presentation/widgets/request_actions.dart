import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../core/services/public_profile_service.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/utils/friendly_error.dart';
import '../../../../shared/widgets/feedback.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../../blocking/presentation/providers/block_providers.dart';
import '../../domain/entities/borrow_request.dart';
import '../../domain/repositories/request_repository.dart';
import '../providers/request_providers.dart';
import 'return_dialog.dart';

/// Everything a member can do to a request from the Requests tabs: the
/// confirmations and date pickers, the call that makes it happen, and the
/// message if it goes wrong.
class RequestActions {
  const RequestActions(this.context, this.ref);

  final BuildContext context;
  final WidgetRef ref;

  void _showError(Object error, String fallback) {
    if (!context.mounted) return;
    final message = error is RequestValidationFailure
        ? error.message
        : friendlyError(error, fallback: fallback);
    showMessage(context, message);
  }

  String? get _myMobile =>
      ref.read(authControllerProvider).valueOrNull?.profile?.mobile;

  // --- Lender side -----------------------------------------------------------

  Future<void> accept(BorrowRequest request) async {
    final myMobile = _myMobile;
    if (myMobile == null || myMobile.isEmpty) {
      showMessage(
        context,
        'Add a mobile number to your profile before accepting.',
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
      _showError(e, 'Could not accept this request.');
    }
  }

  Future<void> _decline(BorrowRequest request) =>
      ref.read(declineBorrowRequestProvider)(request.id);

  Future<void> confirmDecline(BorrowRequest request) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Decline this request?',
      message:
          'The member will be told you declined, and "${request.bookTitle}" '
          "stays on your shelf. This can't be undone.",
      confirmLabel: 'Decline request',
      destructive: true,
    );
    if (!ok) return;
    try {
      await _decline(request);
    } catch (e) {
      _showError(e, 'Could not decline this request.');
    }
  }

  Future<void> markReturned(BorrowRequest request) async {
    final condition = await showReturnDialog(context, request);
    if (condition == null) return;
    try {
      await ref.read(markLoanReturnedProvider)(
        request.id,
        bookId: request.bookId,
        conditionIn: condition,
      );
    } catch (e) {
      _showError(e, 'Could not mark this loan as returned.');
    }
  }

  Future<void> resolveExtension(
    BorrowRequest request, {
    required bool approve,
  }) async {
    if (!approve) {
      final ok = await showConfirmDialog(
        context,
        title: 'Decline this extension?',
        message:
            'The return date stays '
            '${formatDateMs(request.expectedReturnDateMs!)}. This can\'t be '
            'undone.',
        confirmLabel: 'Decline extension',
        destructive: true,
      );
      if (!ok) return;
    }
    try {
      await ref.read(resolveLoanExtensionProvider)(
        request.id,
        approve: approve,
      );
    } catch (e) {
      _showError(e, 'Could not update this extension.');
    }
  }

  Future<void> block(BorrowRequest request) async {
    final name =
        ref.read(displayNameProvider(request.borrowerId)).valueOrNull ??
        'this user';
    final confirmed = await showConfirmDialog(
      context,
      title: 'Block $name?',
      message:
          "$name won't be able to send you new borrow requests. "
          'You can unblock them later from your profile.',
      confirmLabel: 'Block',
    );
    if (!confirmed) return;
    await ref.read(blockUserProvider)(
      blockerId: ref.read(currentUserProvider).id,
      blockedId: request.borrowerId,
      blockedName: name,
    );
    // A block covers future requests, not this one — clean up the existing
    // pending one at the same time so it doesn't linger.
    if (request.status == RequestStatus.pending) {
      await _decline(request);
    }
    if (context.mounted) {
      showMessage(context, 'Blocked $name.');
    }
  }

  // --- Borrower side ---------------------------------------------------------

  Future<void> shareContact(BorrowRequest request) async {
    final myMobile = _myMobile;
    if (myMobile == null || myMobile.isEmpty) return;
    await ref.read(shareBorrowerContactProvider)(request.id, myMobile);
  }

  Future<void> requestExtension(BorrowRequest request) async {
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
        showMessage(context, 'Could not request an extension: $e');
      }
    }
  }
}
