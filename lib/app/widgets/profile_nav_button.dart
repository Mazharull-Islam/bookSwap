import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Leftmost app-bar control on every shell page — jumps straight to Profile
/// without going through the expanding menu.
class ProfileNavButton extends StatelessWidget {
  const ProfileNavButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Profile',
    icon: const Icon(Icons.person_outline),
    onPressed: () => context.go('/profile'),
  );
}
