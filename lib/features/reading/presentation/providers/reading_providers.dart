import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../application/use_cases/reading_use_cases.dart';
import '../../data/repositories/hive_reading_repository.dart';
import '../../domain/entities/reading_entry.dart';
import '../../domain/reading_filter.dart';
import '../../domain/repositories/reading_repository.dart';

final readingRepositoryProvider = Provider<ReadingRepository>(
  (ref) => HiveReadingRepository(),
);

final myReadingProvider = StreamProvider<List<ReadingEntry>>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  return ref.watch(readingRepositoryProvider).watchMine(myId);
});

final addReadingEntryProvider = Provider(
  (ref) => AddReadingEntry(ref.watch(readingRepositoryProvider)),
);
final updateReadingEntryProvider = Provider(
  (ref) => UpdateReadingEntry(ref.watch(readingRepositoryProvider)),
);
final removeReadingEntryProvider = Provider(
  (ref) => RemoveReadingEntry(ref.watch(readingRepositoryProvider)),
);

final readingFilterProvider = StateProvider<ReadingFilter>(
  (ref) => const ReadingFilter(),
);
