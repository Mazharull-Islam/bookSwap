enum ForumReportReason {
  spam('Spam'),
  abuse('Abuse or harassment'),
  offTopic('Off-topic'),
  other('Something else');

  const ForumReportReason(this.label);
  final String label;

  static ForumReportReason? fromName(String? name) {
    for (final r in values) {
      if (r.name == name) return r;
    }
    return null;
  }
}

/// One member's report of a post or reply. Kept in its own collection so
/// moderators can list everything reported without scanning every thread.
class ForumReport {
  const ForumReport({
    required this.id,
    required this.postId,
    this.replyId,
    required this.reporterId,
    required this.reason,
    required this.createdAtMs,
  });

  final String id;
  final String postId;

  /// Null when the report is about the post itself.
  final String? replyId;
  final String reporterId;
  final String reason;
  final int createdAtMs;

  bool get isReply => replyId != null;

  /// Groups reports about the same thing.
  String get targetKey => forumTargetKey(postId, replyId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForumReport &&
          id == other.id &&
          postId == other.postId &&
          replyId == other.replyId &&
          reporterId == other.reporterId &&
          reason == other.reason &&
          createdAtMs == other.createdAtMs;

  @override
  int get hashCode =>
      Object.hash(id, postId, replyId, reporterId, reason, createdAtMs);

  /// Deterministic, so a member can't report the same thing twice.
  static String idFor(String postId, String? replyId, String reporterId) =>
      '${forumTargetKey(postId, replyId)}_$reporterId';
}

String forumTargetKey(String postId, String? replyId) =>
    replyId == null || replyId.isEmpty ? postId : '${postId}_$replyId';

/// A reported post or reply, with every report about it.
class ReportedTarget {
  const ReportedTarget(this.reports);
  final List<ForumReport> reports;

  /// Same item with the same number of reports — lets a queue row keep its
  /// loaded content instead of refetching on every rebuild.
  @override
  bool operator ==(Object other) =>
      other is ReportedTarget &&
      other.key == key &&
      other.reports.length == reports.length;

  @override
  int get hashCode => Object.hash(key, reports.length);

  ForumReport get first => reports.first;
  String get postId => first.postId;
  String? get replyId => first.replyId;
  bool get isReply => first.isReply;
  String get key => first.targetKey;

  /// "Spam ×2, Abuse or harassment" — for the queue row.
  String get reasonSummary {
    final counts = <String, int>{};
    for (final r in reports) {
      final label = ForumReportReason.fromName(r.reason)?.label ?? r.reason;
      counts[label] = (counts[label] ?? 0) + 1;
    }
    return counts.entries
        .map((e) => e.value > 1 ? '${e.key} ×${e.value}' : e.key)
        .join(', ');
  }
}

/// Groups reports by what they are about, most-reported first.
List<ReportedTarget> groupReports(List<ForumReport> reports) {
  final byKey = <String, List<ForumReport>>{};
  for (final r in reports) {
    byKey.putIfAbsent(r.targetKey, () => []).add(r);
  }
  return byKey.values.map(ReportedTarget.new).toList()..sort((a, b) {
    final byCount = b.reports.length.compareTo(a.reports.length);
    return byCount != 0
        ? byCount
        : b.first.createdAtMs.compareTo(a.first.createdAtMs);
  });
}
