import 'package:freezed_annotation/freezed_annotation.dart';

part 'borrow_request.freezed.dart';
part 'borrow_request.g.dart';

enum RequestStatus { pending, accepted, declined }

@freezed
abstract class BorrowRequest with _$BorrowRequest {
  const factory BorrowRequest({
    required String id,
    required String bookId,
    required String bookTitle,
    String? bookCoverUrl,
    required String borrowerId,
    required String lenderId,
    @Default(RequestStatus.pending) RequestStatus status,
    required int requestedAt,
    int? respondedAt,
    int? expectedReturnDateMs,
    String? borrowerContact,
    String? lenderContact,
  }) = _BorrowRequest;

  factory BorrowRequest.fromJson(Map<String, dynamic> json) =>
      _$BorrowRequestFromJson(json);
}
