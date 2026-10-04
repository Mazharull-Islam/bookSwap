import '../../domain/models/reading_entry.dart';
import '../../domain/repositories/reading_repository.dart';

class AddReadingEntry {
  const AddReadingEntry(this.repository);
  final ReadingRepository repository;

  Future<ReadingEntry> call(ReadingEntry entry) => repository.add(entry);
}

class UpdateReadingEntry {
  const UpdateReadingEntry(this.repository);
  final ReadingRepository repository;

  Future<ReadingEntry> call(ReadingEntry entry) => repository.update(entry);
}

class RemoveReadingEntry {
  const RemoveReadingEntry(this.repository);
  final ReadingRepository repository;

  Future<void> call(String id) => repository.remove(id);
}
