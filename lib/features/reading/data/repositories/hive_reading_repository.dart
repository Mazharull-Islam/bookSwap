import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_service.dart';
import '../../domain/models/reading_entry.dart';
import '../../domain/repositories/reading_repository.dart';

/// Local-first, like the shelf — a user's own reading list has no cross-user
/// coordination need, so unlike requests/wanted_books this never touches
/// Firestore.
class HiveReadingRepository implements ReadingRepository {
  Box<Map> get _box => HiveService.readingBox;

  ReadingEntry _decode(dynamic raw) =>
      ReadingEntry.fromJson(Map<String, dynamic>.from(raw as Map));

  List<ReadingEntry> _mineFor(String userId) => _box.values
      .map(_decode)
      .where((e) => e.userId == userId)
      .toList();

  @override
  Stream<List<ReadingEntry>> watchMine(String userId) async* {
    yield _mineFor(userId);
    yield* _box.watch().map((_) => _mineFor(userId));
  }

  @override
  Future<ReadingEntry> add(ReadingEntry entry) async {
    final key = readingMatchKey(
      workKey: entry.workKey,
      title: entry.title,
      author: entry.author,
    );
    final duplicate = _mineFor(entry.userId).any(
      (e) => readingMatchKey(
            workKey: e.workKey,
            title: e.title,
            author: e.author,
          ) ==
          key,
    );
    if (duplicate) {
      throw const ReadingValidationFailure('Already in your reading list.');
    }
    final id = entry.id.isNotEmpty
        ? entry.id
        : 'reading-${DateTime.now().microsecondsSinceEpoch}';
    final saved = entry.copyWith(
      id: id,
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await _box.put(id, saved.toJson());
    return saved;
  }

  @override
  Future<ReadingEntry> update(ReadingEntry entry) async {
    if (!_box.containsKey(entry.id)) {
      throw const ReadingValidationFailure('Reading entry not found.');
    }
    final saved = entry.copyWith(
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await _box.put(entry.id, saved.toJson());
    return saved;
  }

  @override
  Future<void> remove(String id) => _box.delete(id);
}
