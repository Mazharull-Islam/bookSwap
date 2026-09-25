import 'package:hive_flutter/hive_flutter.dart';

/// Bootstraps Hive and owns the app's local-first storage boxes. Call
/// [init] once in main() before runApp, same as Firebase.initializeApp.
abstract final class HiveService {
  static const booksBoxName = 'books';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(booksBoxName);
  }

  static Box<Map> get booksBox => Hive.box<Map>(booksBoxName);
}
