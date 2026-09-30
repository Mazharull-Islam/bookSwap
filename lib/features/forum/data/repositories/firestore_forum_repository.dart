import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/forum_post.dart';
import '../../domain/models/forum_reply.dart';
import '../../domain/repositories/forum_repository.dart';

/// Live, cross-user data like requests/wanted_books/blocks — bypasses Hive.
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
        (s.docs.map((d) => ForumPost.fromJson(d.data())).toList()
          ..sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs))),
  );

  @override
  Stream<ForumPost?> watchPost(String postId) => _posts
      .doc(postId)
      .snapshots()
      .map((d) => d.data() == null ? null : ForumPost.fromJson(d.data()!));

  @override
  Stream<List<ForumReply>> watchReplies(String postId) =>
      _replies(postId).snapshots().map(
        (s) =>
            (s.docs.map((d) => ForumReply.fromJson(d.data())).toList()
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

  @override
  Future<void> reportPost(String postId, String userId) =>
      _posts.doc(postId).update({
        'reportedBy': FieldValue.arrayUnion([userId]),
      });

  @override
  Future<void> reportReply(String postId, String replyId, String userId) =>
      _replies(postId).doc(replyId).update({
        'reportedBy': FieldValue.arrayUnion([userId]),
      });
}
