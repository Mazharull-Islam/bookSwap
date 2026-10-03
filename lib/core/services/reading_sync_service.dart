import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/reading/domain/models/reading_entry.dart';
import '../../features/reading/domain/models/reading_goal.dart';
import '../database/hive_service.dart';

abstract interface class ReadingSyncService {
  Future<void> sync(String uid);
}

/// Keeps a member's reading list and goal in step with Firestore so they
/// survive a reinstall, a cleared browser, or a second device. Hive stays the
/// source of truth the UI reads and writes instantly; a failed sync never
/// reaches the UI.
///
/// Deliberately different from the shelf sync in two ways:
///  - it pulls BEFORE it pushes, and never deletes anything remotely, so a
///    device with an empty local box can't wipe the server copy;
///  - removals are soft (`deletedAtMs`), so they propagate to other devices
///    as ordinary last-write-wins updates instead of needing delete
///    bookkeeping.
class FirestoreReadingSyncService implements ReadingSyncService {
  FirestoreReadingSyncService(this._firestore);
  final FirebaseFirestore _firestore;

  static const _purgeAfter = Duration(days: 30);
  static const _batchSize = 400;

  CollectionReference<Map<String, dynamic>> get _entries =>
      _firestore.collection('reading_entries');
  CollectionReference<Map<String, dynamic>> get _goals =>
      _firestore.collection('reading_goals');

  bool _running = false;
  bool _again = false;

  @override
  Future<void> sync(String uid) async {
    // Local edits trigger syncs; if one arrives mid-sync, run once more
    // afterwards rather than overlapping.
    if (_running) {
      _again = true;
      return;
    }
    _running = true;
    try {
      do {
        _again = false;
        try {
          await syncEntries(uid);
          await syncGoal(uid);
        } catch (e) {
          debugPrint('ReadingSync: failed for uid=$uid: $e');
        }
      } while (_again);
    } finally {
      _running = false;
    }
  }

  ReadingEntry _entry(dynamic raw) =>
      ReadingEntry.fromJson(Map<String, dynamic>.from(raw as Map));

  Future<void> syncEntries(String uid) async {
    final box = HiveService.readingBox;
    final snapshot = await _entries.where('userId', isEqualTo: uid).get();
    final remote = {
      for (final doc in snapshot.docs)
        doc.id: ReadingEntry.fromJson(doc.data()),
    };

    // Pull: take anything remote that's newer or missing here. A removed
    // entry we never had needs no local copy.
    for (final entry in remote.values) {
      final raw = box.get(entry.id);
      if (raw == null) {
        if (entry.deletedAtMs == null) await box.put(entry.id, entry.toJson());
      } else if (entry.updatedAtMs > _entry(raw).updatedAtMs) {
        await box.put(entry.id, entry.toJson());
      }
    }

    // Push: anything local that's missing remotely or newer than it.
    final mine = box.values.map(_entry).where((e) => e.userId == uid).toList();
    final changed = mine.where((e) {
      final theirs = remote[e.id];
      return theirs == null || e.updatedAtMs > theirs.updatedAtMs;
    }).toList();
    for (var i = 0; i < changed.length; i += _batchSize) {
      final batch = _firestore.batch();
      for (final entry in changed.skip(i).take(_batchSize)) {
        batch.set(_entries.doc(entry.id), entry.toJson());
      }
      await batch.commit();
    }

    // Tidy: long-removed entries (already synced above) can leave the box.
    final cutoff = DateTime.now().subtract(_purgeAfter).millisecondsSinceEpoch;
    for (final entry in mine) {
      final removedAt = entry.deletedAtMs;
      if (removedAt != null && removedAt < cutoff) await box.delete(entry.id);
    }
  }

  Future<void> syncGoal(String uid) async {
    final box = HiveService.readingGoalsBox;
    final doc = await _goals.doc(uid).get();
    final remote = doc.exists ? ReadingGoal.fromJson(doc.data()!) : null;
    final raw = box.get(uid);
    final local = raw == null
        ? null
        : ReadingGoal.fromJson(Map<String, dynamic>.from(raw));

    if (remote != null &&
        (local == null || remote.updatedAtMs > local.updatedAtMs)) {
      // A cleared goal we never had needs no local copy.
      if (local != null || remote.deletedAtMs == null) {
        await box.put(uid, remote.toJson());
      }
    } else if (local != null &&
        (remote == null || local.updatedAtMs > remote.updatedAtMs)) {
      await _goals.doc(uid).set(local.toJson());
    }
  }
}

final readingSyncServiceProvider = Provider<ReadingSyncService>(
  (ref) => FirestoreReadingSyncService(FirebaseFirestore.instance),
);
