import '../../books/domain/entities/book.dart';
import 'entities/borrow_request.dart';

/// Position in [bookConditionOptions] (New, Like new, Good, Fair, Worn) —
/// higher is worse. Null for anything unrecognised.
int? conditionRank(String? condition) {
  final index = bookConditionOptions.indexOf(condition ?? '');
  return index < 0 ? null : index;
}

/// True only when both conditions are known and the return is worse. Older
/// loans with no recorded condition are never flagged.
bool conditionWorsened(String? out, String? returned) {
  final a = conditionRank(out);
  final b = conditionRank(returned);
  return a != null && b != null && b > a;
}

extension LoanCondition on BorrowRequest {
  bool get conditionFlagged => conditionWorsened(conditionOut, conditionIn);
}
