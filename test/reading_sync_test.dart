import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:bookswap_login/core/database/hive_service.dart';
import 'package:bookswap_login/core/services/book_sync_service.dart';
import 'package:bookswap_login/core/services/reading_sync_service.dart';
import 'package:bookswap_login/features/books/domain/models/book.dart';
import 'package:bookswap_login/features/reading/data/repositories/hive_reading_goal_repository.dart';
import 'package:bookswap_login/features/reading/data/repositories/hive_reading_repository.dart';
import 'package:bookswap_login/features/reading/domain/models/reading_entry.dart';
import 'package:bookswap_login/features/reading/domain/models/reading_goal.dart';

ReadingEntry entry(
  String id, {
  String uid = 'u1',
  String? title,
  int at = 1000,
  int? deletedAt,
  ReadingStatus status = ReadingStatus.planToRead,
}) => ReadingEntry(
  id: id,
  userId: uid,
  title: title ?? 'Title $id',
  status: status,
  updatedAtMs: at,
  deletedAtMs: deletedAt,
);

void main() {
  late Directory dir;
  late FakeFirebaseFirestore db;
  late FirestoreReadingSyncService sync;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('bookswap_sync_test_');
    Hive.init(dir.path);
    await Hive.openBox<Map>(HiveService.booksBoxName);
    await Hive.openBox<Map>(HiveService.readingBoxName);
    await Hive.openBox<Map>(HiveService.readingGoalsBoxName);
    await Hive.openBox<String>(HiveService.settingsBoxName);
    db = FakeFirebaseFirestore();
    sync = FirestoreReadingSyncService(db);
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  Future<void> putLocal(ReadingEntry e) =>
      HiveService.readingBox.put(e.id, e.toJson());
  Future<void> putRemote(ReadingEntry e) =>
      db.collection('reading_entries').doc(e.id).set(e.toJson());
  ReadingEntry? local(String id) {
    final raw = HiveService.readingBox.get(id);
    return raw == null
        ? null
        : ReadingEntry.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<ReadingEntry?> remote(String id) async {
    final doc = await db.collection('reading_entries').doc(id).get();
    return doc.exists ? ReadingEntry.fromJson(doc.data()!) : null;
  }

  group('reading entries', () {
    test('pushes local entries that are missing remotely', () async {
      await putLocal(entry('a'));
      await sync.sync('u1');
      expect((await remote('a'))?.title, 'Title a');
    });

    test(
      'a fresh device pulls the list and leaves the server untouched',
      () async {
        await putRemote(entry('a'));
        await putRemote(entry('b'));
        await sync.sync('u1');
        expect(local('a'), isNotNull);
        expect(local('b'), isNotNull);
        expect(
          (await db.collection('reading_entries').get()).docs,
          hasLength(2),
        );
      },
    );

    test('the newer side wins in both directions', () async {
      await putLocal(entry('new-local', title: 'local', at: 5000));
      await putRemote(entry('new-local', title: 'remote', at: 2000));
      await putLocal(entry('new-remote', title: 'local', at: 2000));
      await putRemote(entry('new-remote', title: 'remote', at: 5000));
      await sync.sync('u1');
      expect((await remote('new-local'))?.title, 'local');
      expect(local('new-remote')?.title, 'remote');
    });

    test('a local removal reaches the server as a soft delete', () async {
      await putLocal(entry('a', at: 1000));
      await sync.sync('u1');
      await HiveReadingRepository().remove('a');
      await sync.sync('u1');
      expect((await remote('a'))?.deletedAtMs, isNotNull);
    });

    test('a removal on another device hides the entry here', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await putLocal(entry('a', at: now - 5000));
      await putRemote(entry('a', at: now, deletedAt: now));
      await sync.sync('u1');
      expect(local('a')?.deletedAtMs, now);
      final visible = await HiveReadingRepository().watchMine('u1').first;
      expect(visible, isEmpty);
    });

    test(
      'an entry removed elsewhere that we never had is not recreated',
      () async {
        await putRemote(entry('gone', at: 3000, deletedAt: 3000));
        await sync.sync('u1');
        expect(local('gone'), isNull);
      },
    );

    test("other members' entries are neither pulled nor pushed", () async {
      await putRemote(entry('theirs', uid: 'u2'));
      await putLocal(entry('also-theirs', uid: 'u2'));
      await sync.sync('u1');
      expect(local('theirs'), isNull);
      expect(await remote('also-theirs'), isNull);
    });

    test('long-removed entries are purged locally, recent ones kept', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      final old = now - const Duration(days: 40).inMilliseconds;
      await putLocal(entry('old', at: old, deletedAt: old));
      await putLocal(entry('recent', at: now, deletedAt: now));
      await sync.sync('u1');
      expect(local('old'), isNull);
      expect(local('recent'), isNotNull);
      expect(await remote('old'), isNotNull, reason: 'pushed before purge');
    });

    test('a removed entry does not block adding the same book again', () async {
      final repo = HiveReadingRepository();
      final added = await repo.add(entry('', title: 'Dune'));
      await repo.remove(added.id);
      await repo.add(entry('', title: 'Dune'));
      expect(await repo.watchMine('u1').first, hasLength(1));
    });
  });

  group('reading goal', () {
    ReadingGoal goal(int target, int at, {int? deletedAt}) => ReadingGoal(
      userId: 'u1',
      targetCount: target,
      startedAtMs: 1,
      periodDays: 365,
      updatedAtMs: at,
      deletedAtMs: deletedAt,
    );

    test('a fresh device pulls the goal', () async {
      await db
          .collection('reading_goals')
          .doc('u1')
          .set(goal(12, 100).toJson());
      await sync.sync('u1');
      expect(
        await HiveReadingGoalRepository().watchGoal('u1').first,
        isNotNull,
      );
    });

    test('a local change is pushed, a clear syncs as a soft delete', () async {
      final repo = HiveReadingGoalRepository();
      await repo.setGoal(goal(5, 0));
      await sync.sync('u1');
      final doc = await db.collection('reading_goals').doc('u1').get();
      expect(doc.data()!['targetCount'], 5);

      await repo.clearGoal('u1');
      await sync.sync('u1');
      final cleared = await db.collection('reading_goals').doc('u1').get();
      expect(cleared.data()!['deletedAtMs'], isNotNull);
      expect(await repo.watchGoal('u1').first, isNull);
    });
  });

  group('shelf sync', () {
    Book book(String id, String owner) => Book(
      id: id,
      ownerId: owner,
      title: 'Book $id',
      author: 'Author',
      genre: 'Fantasy',
      condition: 'Good',
      estimatedValue: 5,
      updatedAtMs: 10,
    );

    test('an empty new device cannot wipe the server shelf', () async {
      await db.collection('books').doc('b1').set(book('b1', 'u1').toJson());
      await db.collection('books').doc('b2').set(book('b2', 'u1').toJson());

      await FirestoreBookSyncService(db).sync('u1');

      expect((await db.collection('books').get()).docs, hasLength(2));
      expect(HiveService.booksBox.keys, containsAll(['b1', 'b2']));
    });

    test(
      'after the first sync, local deletions still reach the server',
      () async {
        await db.collection('books').doc('b1').set(book('b1', 'u1').toJson());
        final service = FirestoreBookSyncService(db);
        await service.sync('u1');
        await HiveService.booksBox.delete('b1');
        await service.sync('u1');
        expect((await db.collection('books').get()).docs, isEmpty);
      },
    );
  });
}
