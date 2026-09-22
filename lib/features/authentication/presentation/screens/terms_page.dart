import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../domain/models/registration.dart';
import '../widgets/auth_widgets.dart';

const communityTerms = <(String, String)>[
  (
    '1. About BookSwap',
    'BookSwap is a community for discovering, borrowing and lending physical books nearby. These terms set out how members should use the service and care for one another’s books. BookSwap connects readers; it does not own the books or arrange the handover for you.',
  ),
  (
    '2. Your account',
    'Use an email address and mobile number you control, provide accurate profile information, and keep your password private. Do not impersonate another person or use someone else’s account. If you are under 18, involve a parent or guardian in registration and any exchange. Never publish another person’s contact details without permission.',
  ),
  (
    '3. Your profile and privacy',
    'Use your area and city in the address field; an exact home address is not needed. Gender includes a “Prefer not to say” option. Reading preferences and an optional favourite book help personalise the experience. In the planned service, only approximate distance should be shown to other readers, and contact details should be shared only after a borrowing request is accepted. Do not put sensitive information in public listings.',
  ),
  (
    '4. Honest book listings',
    'List only books you own or have permission to lend. Describe their edition, condition and any existing damage honestly, and use photos you have permission to share. Do not list stolen items, unlawful material or unauthorised digital copies. Keep availability up to date and remove listings you can no longer lend.',
  ),
  (
    '5. Requests and exchanges',
    'A request is not a confirmed loan until the owner accepts it. Before handing over a book, agree on the return date, book condition and a suitable meeting place. Lending through BookSwap is intended to be free. Do not demand unexpected fees or send advance payments to strangers. Mark exchanges and returns accurately when those features are available.',
  ),
  (
    '6. Care, returns and damage',
    'Handle borrowed books carefully. Do not write in them, pass them to someone else, sell them or keep them beyond the agreed period without the owner’s consent. Contact the owner early if you need more time. If a book is lost or damaged, discuss evidence and a fair repair or replacement arrangement. This prototype does not calculate, charge or collect penalties; any future penalty policy must be published before it applies.',
  ),
  (
    '7. Safe and respectful community',
    'Treat other readers respectfully. Harassment, threats, discrimination, scams and misleading reviews are not acceptable. Meet in a public place during reasonable hours and let someone you trust know your plans. You may decline or stop an exchange if you feel unsafe. For an immediate threat, contact local emergency services.',
  ),
  (
    '8. Disagreements and misuse',
    'Keep the agreed exchange details and relevant condition photos. Try to resolve ordinary return or condition disagreements calmly. The planned service may restrict accounts for substantiated misuse; reporting, moderation and appeals are not implemented in this prototype. Do not assume that submitting a review or message triggers a safety response.',
  ),
  (
    '9. Recommendations and availability',
    'Future recommendations, book metadata and AI-assisted condition estimates may be incomplete or inaccurate. Check important details yourself and confirm condition with the owner. Offline or delayed synchronization can leave availability out of date; confirm an exchange before travelling. BookSwap cannot promise that every listed book will be available.',
  ),
  (
    '10. Your registration data',
    'BookSwap uses Firebase Authentication to manage sign-in and Cloud Firestore to store your registration profile and terms acceptance. Email/password registration sends a confirmation link to your email. Google verifies your email when you use Google sign-up; you must still complete the registration form. Signing out does not delete your account. Book exchanges are not yet implemented.',
  ),
  (
    '11. Future changes and your choice',
    'You may stop using BookSwap at any time. Restarting the app does not delete your registered account. Before a public launch, BookSwap must publish its actual operator and contact details, a privacy notice describing storage and deletion, and updated terms for the live features. Material changes should be clearly shown and fresh acceptance requested where needed. Accepting this version records agreement to version 1.1; it does not accept unpublished future rules.',
  ),
];

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});
  @override
  Widget build(BuildContext context) => AuthPage(
    maxWidth: 760,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'A COMMUNITY BUILT ON CARE',
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: forest,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Terms & Conditions',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        const Text('Version $termsVersion · 21 September 2026'),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEDF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Text(
            'Share stories. Respect people. Care for every book.\nThese terms apply to the BookSwap academic prototype and describe the ground rules for the planned lending community.',
          ),
        ),
        const SizedBox(height: 24),
        for (final section in communityTerms)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.$1,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: forest,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section.$2,
                  style: const TextStyle(fontSize: 15, height: 1.7),
                ),
              ],
            ),
          ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back to BookSwap'),
        ),
        const SizedBox(height: 12),
        const Text(
          'Reading this page does not automatically accept the terms.\nChoose the checkbox on the registration page to agree.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
