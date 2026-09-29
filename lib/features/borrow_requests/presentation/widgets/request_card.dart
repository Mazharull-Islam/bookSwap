import 'package:flutter/material.dart';
import '../../../../shared/widgets/owner_label.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../domain/models/borrow_request.dart';

String requestStatusLabel(BorrowRequest request) => switch (request.status) {
  RequestStatus.pending => 'Pending',
  RequestStatus.accepted =>
    request.returnedAt == null ? 'Accepted' : 'Returned',
  RequestStatus.declined => 'Declined',
};

Color requestStatusColor(BorrowRequest request) => switch (request.status) {
  RequestStatus.pending => const Color(0xFFB16C46),
  RequestStatus.accepted =>
    request.returnedAt == null ? const Color(0xFF254E3B) : const Color(0xFF7A7A7A),
  RequestStatus.declined => const Color(0xFF7A7A7A),
};

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.otherPartyId,
    this.footer,
  });

  final BorrowRequest request;
  final String otherPartyId;
  final Widget? footer;

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
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF617065),
                      ),
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(
                  requestStatusLabel(request),
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
                backgroundColor: requestStatusColor(request),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          if (footer != null) ...[const SizedBox(height: 10), footer!],
        ],
      ),
    ),
  );
}
