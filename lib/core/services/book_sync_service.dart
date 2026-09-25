import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/books/domain/models/book.dart';
import '../database/hive_service.dart';

abstract interface class BookSyncService {
  Future<void> sync(String uid);
}

/// Pushes local Hive changes up to Firestore and pulls remote changes down,
/// per the local-first sync design in SRS §5.3: Hive stays the source of
/// truth the UI reads/writes instantly; this only reconciles it with the
/// shared backend in the background. A sync failure (offline, denied rules,
/// etc.) never surfaces to the UI — the app stays fully usable regardless.
class FirestoreBookSyncService implements BookSyncService {
  FirestoreBookSyncService(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _remote =>
      _firestore.collection('books');

  Book _decode(Map<String, dynamic> json) => Book.fromJson(json);

  @override
  Future<void> sync(String uid) async {
    debugPrint('BookSync: starting sync for uid=$uid');
    try {
      await _push(uid);
      await _pull();
      debugPrint('BookSync: sync completed for uid=$uid');
    } catch (e, st) {
      // Background convenience only — local Hive remains authoritative.
      debugPrint('BookSync: sync FAILED for uid=$uid: $e\n$st');
    }
  }

  /// Upserts every locally-owned book and deletes remote copies of books
  /// that were removed locally, so deletions don't get resurrected by pull.
  Future<void> _push(String uid) async {
    final box = HiveService.booksBox;
    final allLocal = box.values
        .map((raw) => _decode(Map<String, dynamic>.from(raw)))
        .toList();
    debugPrint(
      'BookSync: ${allLocal.length} book(s) in local storage, '
      'ownerIds=${allLocal.map((b) => b.ownerId).toList()}',
    );
    final owned = allLocal.where((book) => book.ownerId == uid).toList();
    debugPrint('BookSync: ${owned.length} of those belong to uid=$uid');

    final remoteOwned = await _remote.where('ownerId', isEqualTo: uid).get();
    final ownedIds = owned.map((b) => b.id).toSet();

    final toDelete = remoteOwned.docs
        .where((doc) => !ownedIds.contains(doc.id))
        .toList();
    final batch = _firestore.batch();
    for (final book in owned) {
      batch.set(_remote.doc(book.id), book.toJson());
    }
    for (final doc in toDelete) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    debugPrint(
      'BookSync: pushed ${owned.length} book(s), '
      'deleted ${toDelete.length} remote-only doc(s)',
    );
  }

  /// Pulls every remote book and merges it into Hive, keeping whichever
  /// copy (local or remote) has the newer [Book.updatedAtMs].
  Future<void> _pull() async {
    final snapshot = await _remote.get();
    final box = HiveService.booksBox;
    for (final doc in snapshot.docs) {
      final remote = _decode(doc.data());
      final localRaw = box.get(remote.id);
      if (localRaw == null) {
        await box.put(remote.id, remote.toJson());
        continue;
      }
      final local = _decode(Map<String, dynamic>.from(localRaw));
      if (remote.updatedAtMs > local.updatedAtMs) {
        await box.put(remote.id, remote.toJson());
      }
    }
  }
}

final bookSyncServiceProvider = Provider<BookSyncService>(
  (ref) => FirestoreBookSyncService(FirebaseFirestore.instance),
);
