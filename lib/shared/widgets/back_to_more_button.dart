import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The back arrow for screens reached from the More menu. They are opened with
/// go(), which replaces the page rather than stacking it, so the app bar has no
/// automatic back arrow; this returns to More.
class BackToMoreButton extends StatelessWidget {
  const BackToMoreButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Back',
    icon: const Icon(Icons.arrow_back),
    onPressed: () => context.go('/more'),
  );
}
