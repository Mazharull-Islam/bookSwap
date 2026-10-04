import 'package:hive_flutter/hive_flutter.dart';

/// Bootstraps Hive and owns the app's local-first storage boxes. Call
/// [init] once in main() before runApp, same as Firebase.initializeApp.
abstract final class HiveService {
  static const booksBoxName = 'books';
  static const readingBoxName = 'reading_entries';
  static const readingGoalsBoxName = 'reading_goals';
  static const seenBadgesBoxName = 'seen_badges';
  static const settingsBoxName = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(booksBoxName);
    await Hive.openBox<Map>(readingBoxName);
    await Hive.openBox<Map>(readingGoalsBoxName);
    await Hive.openBox<List>(seenBadgesBoxName);
    await Hive.openBox<String>(settingsBoxName);
  }

  static Box<Map> get booksBox => Hive.box<Map>(booksBoxName);

  /// Personal reading list (SRS §3.8/§3.9, trimmed). Hive is the source of
  /// truth; ReadingSyncService mirrors it to Firestore in the background.
  static Box<Map> get readingBox => Hive.box<Map>(readingBoxName);

  /// Keyed by userId — one goal per user (SRS §3.9).
  static Box<Map> get readingGoalsBox => Hive.box<Map>(readingGoalsBoxName);

  /// Keyed by userId — which achievement badges this device has already
  /// shown a toast for, purely to drive the notification (not the badges
  /// display itself, which always recomputes live from Requests/Reading).
  static Box<List> get seenBadgesBox => Hive.box<List>(seenBadgesBoxName);
}
