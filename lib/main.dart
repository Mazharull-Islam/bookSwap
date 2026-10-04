import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/database/hive_service.dart';
import 'core/firebase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  String? startupError;
  if (!FirebaseConfig.configured) {
    startupError =
        'BookSwap authentication is not configured yet. Please contact the app administrator.';
  } else {
    try {
      await Firebase.initializeApp(options: FirebaseConfig.options);
    } catch (_) {
      startupError =
          'BookSwap could not connect to its authentication service. Please restart the app and try again.';
    }
  }
  runApp(ProviderScope(child: BookSwapApp(startupError: startupError)));
}
