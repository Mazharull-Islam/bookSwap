import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme.dart';

class BookSwapApp extends ConsumerWidget {
  const BookSwapApp({super.key, this.startupError});
  final String? startupError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (startupError != null) {
      return MaterialApp(
        title: 'BookSwap',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(startupError!, textAlign: TextAlign.center),
            ),
          ),
        ),
      );
    }
    return MaterialApp.router(
      title: 'BookSwap',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
