import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/utils/date_format.dart';
import '../../domain/entities/borrow_request.dart';
import 'request_card.dart';

/// "Return by Oct 17, 2026 · due in 5 days" — overdue is in the words as well
/// as the colour.
class ReturnLine extends StatelessWidget {
  const ReturnLine(this.request, {super.key});
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
