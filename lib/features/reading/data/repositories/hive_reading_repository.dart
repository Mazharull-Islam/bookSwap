import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_service.dart';
import '../../domain/entities/reading_entry.dart';
import '../../domain/repositories/reading_repository.dart';
import '../models/reading_entry_dto.dart';

/// Local-first, like the shelf: reads and writes go to Hive, and
/// ReadingSyncService mirrors them to Firestore in the background.
class HiveReadingRepository implements ReadingRepository {
  Box<Map> get _box => HiveService.readingBox;

  ReadingEntry _decode(dynamic raw) =>
      ReadingEntryDto.parse(Map<String, dynamic>.from(raw as Map));

  List<ReadingEntry> _mineFor(String userId) => _box.values
      .map(_decode)
      .where((e) => e.userId == userId && e.deletedAtMs == null)
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
      (e) =>
          readingMatchKey(
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

  /// A soft delete: the entry stays in the box, marked, so the removal can
  /// sync to other devices. Nothing reads entries with deletedAtMs set.
  @override
  Future<void> remove(String id) async {
    final raw = _box.get(id);
    if (raw == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    await _box.put(
      id,
      _decode(raw).copyWith(deletedAtMs: now, updatedAtMs: now).toJson(),
    );
  }
}
