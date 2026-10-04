import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

/// The title block at the top of the registration page, with a note on what
/// happens after registering.
class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({super.key, required this.google});

  /// The member is signing up with a Google account (email already verified).
  final bool google;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'MAKE ROOM FOR MORE STORIES',
        style: TextStyle(
          letterSpacing: 2,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: context.colors.brand,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        'Join the neighbourhood.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 10),
      const Text('A few details, a shared love of books, and a new chapter.'),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surfaceSoft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          google
              ? 'Google has verified your email. Complete this form to become a BookSwap member.'
              : 'After registration, we will email you a confirmation link. Verify your email to activate your membership.',
        ),
      ),
    ],
  );
}
