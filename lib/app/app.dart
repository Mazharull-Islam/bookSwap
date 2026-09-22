import 'package:flutter/material.dart';
import 'router.dart';
import 'theme.dart';

class BookSwapApp extends StatelessWidget {
  const BookSwapApp({super.key, this.startupError});
  final String? startupError;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BookSwap',
    debugShowCheckedModeBanner: false,
    theme: buildTheme(),
    initialRoute: '/',
    routes: buildRoutes(startupError),
  );
}
