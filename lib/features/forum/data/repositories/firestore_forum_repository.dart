import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/forum_post.dart';
import '../../domain/entities/forum_reply.dart';
import '../../domain/entities/forum_report.dart';
import '../../domain/repositories/forum_repository.dart';
import '../models/forum_post_dto.dart';
import '../models/forum_reply_dto.dart';
import '../models/forum_report_dto.dart';

/// Live, cross-user data, so it bypasses Hive.
class FirestoreForumRepository implements ForumRepository {
  FirestoreForumRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection('forum_posts');

  CollectionReference<Map<String, dynamic>> _replies(String postId) =>
      _posts.doc(postId).collection('replies');

  @override
  Stream<List<ForumPost>> watchPosts() => _posts.snapshots().map(
    (s) =>
        (s.docs.map((d) => ForumPostDto.parse(d.data())).toList()
          ..sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs))),
  );

  @override
  Stream<ForumPost?> watchPost(String postId) => _posts
      .doc(postId)
      .snapshots()
      .map((d) => d.data() == null ? null : ForumPostDto.parse(d.data()!));

  @override
  Stream<List<ForumReply>> watchReplies(String postId) =>
      _replies(postId).snapshots().map(
        (s) =>
            (s.docs.map((d) => ForumReplyDto.parse(d.data())).toList()
              ..sort((a, b) => a.createdAtMs.compareTo(b.createdAtMs))),
      );

  @override
  Future<ForumPost> createPost({
    required String authorId,
    required String authorName,
    required String title,
    required String body,
    String? genre,
  }) async {
    final doc = _posts.doc();
    final post = ForumPost(
      id: doc.id,
      authorId: authorId,
      authorName: authorName,
      title: title,
      body: body,
      genre: genre,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await doc.set(post.toJson());
    return post;
  }

  @override
  Future<ForumReply> createReply({
    required String postId,
    required String authorId,
    required String authorName,
    required String body,
  }) async {
    final doc = _replies(postId).doc();
    final reply = ForumReply(
      id: doc.id,
      postId: postId,
      authorId: authorId,
      authorName: authorName,
      body: body,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    try {
      final batch = _firestore.batch();
      batch.set(doc, reply.toJson());
      batch.update(_posts.doc(postId), {'replyCount': FieldValue.increment(1)});
      await batch.commit();
    } on FirebaseException catch (e) {
      // Most likely cause: the post's author has blocked this replier (SRS
      // §3.7, reusing /blocks) — vague on purpose, same as request-sending.
      if (e.code == 'permission-denied') {
        throw const ForumValidationFailure("You can't reply to this post.");
      }
      rethrow;
    }
    return reply;
  }

  @override
  Future<void> setPostLiked(String postId, String userId, bool liked) =>
      _posts.doc(postId).update({
        'likedBy': liked
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId]),
      });

  @override
  Future<void> setReplyLiked(
    String postId,
    String replyId,
    String userId,
    bool liked,
  ) => _replies(postId).doc(replyId).update({
    'likedBy': liked
        ? FieldValue.arrayUnion([userId])
        : FieldValue.arrayRemove([userId]),
  });

  CollectionReference<Map<String, dynamic>> get _reports =>
      _firestore.collection('forum_reports');

  Future<void> _report(
    DocumentReference<Map<String, dynamic>> target,
    String postId,
    String? replyId,
    String userId,
    ForumReportReason reason,
  ) async {
    final id = ForumReport.idFor(postId, replyId, userId);
    final report = ForumReport(
      id: id,
      postId: postId,
      replyId: replyId,
      reporterId: userId,
      reason: reason.name,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    try {
      final batch = _firestore.batch();
      batch.update(target, {
        'reportedBy': FieldValue.arrayUnion([userId]),
      });
      batch.set(_reports.doc(id), report.toJson());
      await batch.commit();
    } on FirebaseException catch (e) {
      // A second report by the same member fails the rules' add-self check.
      if (e.code == 'permission-denied') {
        throw const ForumValidationFailure(
          "You can't report this (you may have already).",
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> reportPost(
    String postId,
    String userId,
    ForumReportReason reason,
  ) => _report(_posts.doc(postId), postId, null, userId, reason);

  @override
  Future<void> reportReply(
    String postId,
    String replyId,
    String userId,
    ForumReportReason reason,
  ) => _report(_replies(postId).doc(replyId), postId, replyId, userId, reason);

  @override
  Future<void> deletePost(String postId) => _posts.doc(postId).delete();

  @override
  Future<void> deleteReply(String postId, String replyId) async {
    final batch = _firestore.batch();
    batch.delete(_replies(postId).doc(replyId));
    batch.update(_posts.doc(postId), {'replyCount': FieldValue.increment(-1)});
    await batch.commit();
  }

  @override
  Stream<bool> watchIsModerator(String userId) => _firestore
      .collection('moderators')
      .doc(userId)
      .snapshots()
      .map((d) => d.exists)
      .handleError((_) {});

  @override
  Stream<List<ForumReport>> watchReports() => _reports.snapshots().map(
    (s) => s.docs.map((d) => ForumReportDto.parse(d.data())).toList(),
  );

  @override
  Future<ForumPost?> fetchPost(String postId) async {
    final d = await _posts.doc(postId).get();
    return d.data() == null ? null : ForumPostDto.parse(d.data()!);
  }

  @override
  Future<ForumReply?> fetchReply(String postId, String replyId) async {
    final d = await _replies(postId).doc(replyId).get();
    return d.data() == null ? null : ForumReplyDto.parse(d.data()!);
  }

  DocumentReference<Map<String, dynamic>> _targetRef(ReportedTarget t) =>
      t.isReply ? _replies(t.postId).doc(t.replyId) : _posts.doc(t.postId);

  Future<void> _deleteReports(WriteBatch batch, ReportedTarget t) async {
    final docs = await _reports.where('targetKey', isEqualTo: t.key).get();
    for (final d in docs.docs) {
      batch.delete(d.reference);
    }
  }

  @override
  Future<void> dismissReports(ReportedTarget target) async {
    final batch = _firestore.batch();
    final ref = _targetRef(target);
    // The item may already be gone (deleted by its author).
    if ((await ref.get()).exists) {
      batch.update(ref, {'reportedBy': <String>[]});
    }
    await _deleteReports(batch, target);
    await batch.commit();
  }

  @override
  Future<void> removeReported(ReportedTarget target) async {
    final batch = _firestore.batch();
    final ref = _targetRef(target);
    if ((await ref.get()).exists) {
      batch.delete(ref);
      if (target.isReply) {
        batch.update(_posts.doc(target.postId), {
          'replyCount': FieldValue.increment(-1),
        });
      }
    }
    await _deleteReports(batch, target);
    await batch.commit();
  }
}
