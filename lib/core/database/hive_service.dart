import 'package:hive_flutter/hive_flutter.dart';

/// Bootstraps Hive and owns the app's local-first storage boxes. Call
/// [init] once in main() before runApp, same as Firebase.initializeApp.
abstract final class HiveService {
  static const booksBoxName = 'books';
  static const readingBoxName = 'reading_entries';
  static const readingGoalsBoxName = 'reading_goals';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(booksBoxName);
    await Hive.openBox<Map>(readingBoxName);
    await Hive.openBox<Map>(readingGoalsBoxName);
  }

  static Box<Map> get booksBox => Hive.box<Map>(booksBoxName);

  /// Personal reading list (SRS §3.8/§3.9, trimmed) — purely local, no
  /// cross-user coordination needed, so unlike requests/wanted_books this
  /// stays local-first with no Firestore sync counterpart yet.
  static Box<Map> get readingBox => Hive.box<Map>(readingBoxName);

  /// Keyed by userId — one goal per user (SRS §3.9).
  static Box<Map> get readingGoalsBox => Hive.box<Map>(readingGoalsBoxName);
}
