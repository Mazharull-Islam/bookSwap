import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/authentication/presentation/providers/auth_providers.dart';
import '../features/authentication/presentation/screens/login_page.dart';
import '../features/authentication/presentation/screens/register_page.dart';
import '../features/authentication/presentation/screens/terms_page.dart';
import '../features/authentication/presentation/screens/verification_page.dart';
import '../features/authentication/presentation/screens/welcome_page.dart';
import 'theme.dart';

Map<String, WidgetBuilder> buildRoutes(String? startupError) => {
  '/': (_) => startupError != null
      ? Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(startupError, textAlign: TextAlign.center),
            ),
          ),
        )
      : const SessionEntry(),
  '/login': (_) => const AuthGate(),
  '/register': (_) => const RegisterPage(),
  '/terms': (_) => const TermsPage(),
  '/home': (_) => const AuthGate(),
};

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final user = auth.valueOrNull;
    if (user == null) return const LoginPage();
    if (user.profile == null) return const RegisterPage();
    if (!user.emailVerified) return const VerificationPage();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 72,
                    color: forest,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome, ${user.name}.',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You’re an official BookSwap member.\nYour next chapter starts here.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Book discovery and your shelf will be added in the next stage.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (context.mounted &&
                          !ref.read(authControllerProvider).hasError) {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (_) => false);
                      }
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SessionEntry extends ConsumerWidget {
  const SessionEntry({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider);
    if (session.isLoading && session.valueOrNull == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (session.valueOrNull != null) return const AuthGate();
    if (session.hasError) return const LoginPage();
    return const WelcomePage();
  }
}
