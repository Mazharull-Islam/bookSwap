import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/database/hive_service.dart';

const _key = 'themeMode';

/// Light / dark / follow-the-system, remembered on this device. Falls back to
/// "system" and skips persisting when the settings box isn't open (tests).
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    if (!Hive.isBoxOpen(HiveService.settingsBoxName)) return ThemeMode.system;
    final saved = Hive.box<String>(HiveService.settingsBoxName).get(_key);
    return ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    if (Hive.isBoxOpen(HiveService.settingsBoxName)) {
      await Hive.box<String>(HiveService.settingsBoxName).put(_key, mode.name);
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
