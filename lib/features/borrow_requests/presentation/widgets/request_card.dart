import 'package:flutter/material.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../shared/widgets/owner_label.dart';
import '../../../../shared/widgets/book_cover_image.dart';
import '../../domain/entities/borrow_request.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/status_chip.dart';

/// Active (accepted, not yet returned) and past its expected return date.
bool isOverdue(BorrowRequest request) =>
    request.status == RequestStatus.accepted &&
    request.returnedAt == null &&
    request.expectedReturnDateMs != null &&
    request.expectedReturnDateMs! < DateTime.now().millisecondsSinceEpoch;

String requestStatusLabel(BorrowRequest request) => switch (request.status) {
  RequestStatus.pending => 'Pending',
  RequestStatus.accepted =>
    request.returnedAt != null
        ? 'Returned'
        : isOverdue(request)
        ? 'Overdue'
        : 'Accepted',
  RequestStatus.declined => 'Declined',
};

Color requestStatusColor(BorrowRequest request) => switch (request.status) {
  RequestStatus.pending => StatusFills.pending,
  RequestStatus.accepted =>
    request.returnedAt != null
        ? StatusFills.returned
        : isOverdue(request)
        ? StatusFills.danger
        : StatusFills.accepted,
  RequestStatus.declined => StatusFills.returned,
};

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.otherPartyId,
    this.footer,
    this.onBlock,
  });

  final BorrowRequest request;
  final String otherPartyId;
  final Widget? footer;

  /// Shown as a small icon next to the status chip when non-null (SRS
  /// §3.1/§3.4) — omitted entirely on tabs that don't offer blocking.
  final VoidCallback? onBlock;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BookCoverImage(url: request.bookCoverUrl, width: 44, height: 60),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.bookTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    OwnerLabel(
                      ownerId: otherPartyId,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.textMuted,
                      ),
                    ),
                    Text(
                      'Requested ${formatDateMs(request.requestedAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: requestStatusLabel(request),
                color: requestStatusColor(request),
              ),
              if (onBlock != null)
                IconButton(
                  tooltip: 'Block this member',
                  icon: const Icon(Icons.block_outlined, size: 20),
                  onPressed: onBlock,
                ),
            ],
          ),
          if (footer != null) ...[const SizedBox(height: 10), footer!],
        ],
      ),
    ),
  );
}
