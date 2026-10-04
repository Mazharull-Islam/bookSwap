import '../models/reading_entry.dart';

class ReadingValidationFailure implements Exception {
  const ReadingValidationFailure(this.message);
  final String message;
}

abstract interface class ReadingRepository {
  Stream<List<ReadingEntry>> watchMine(String userId);
  Future<ReadingEntry> add(ReadingEntry entry);
  Future<ReadingEntry> update(ReadingEntry entry);
  Future<void> remove(String id);
}
