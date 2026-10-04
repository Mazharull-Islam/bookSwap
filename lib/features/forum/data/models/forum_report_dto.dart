import '../../domain/entities/forum_report.dart';

/// How a [ForumReport] is stored in Firestore. Written by hand rather than
/// generated: the post/reply link is stored as an empty string, not null, and
/// `targetKey` is stored so moderators can query by it.
abstract final class ForumReportDto {
  static ForumReport parse(Map<String, dynamic> json) {
    final reply = json['replyId'] as String? ?? '';
    return ForumReport(
      id: json['id'] as String,
      postId: json['postId'] as String,
      replyId: reply.isEmpty ? null : reply,
      reporterId: json['reporterId'] as String,
      reason: json['reason'] as String? ?? 'other',
      createdAtMs: (json['createdAtMs'] as num?)?.toInt() ?? 0,
    );
  }
}

extension ForumReportJson on ForumReport {
  Map<String, dynamic> toJson() => {
    'id': id,
    'postId': postId,
    'replyId': replyId ?? '',
    'targetKey': targetKey,
    'reporterId': reporterId,
    'reason': reason,
    'createdAtMs': createdAtMs,
  };
}
