import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/firebase_config.dart';
import 'features/auth/presentation/verification_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'features/auth/application/auth_controller.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/welcome_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/auth/presentation/terms_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class BookSwapApp extends StatelessWidget {
  const BookSwapApp({super.key, this.startupError});
  final String? startupError;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BookSwap',
    debugShowCheckedModeBanner: false,
    theme: buildTheme(),
    initialRoute: '/',
    routes: {
      '/': (_) => startupError != null
          ? Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(startupError!, textAlign: TextAlign.center),
                ),
              ),
            )
          : const SessionEntry(),
      '/login': (_) => const AuthGate(),
      '/register': (_) => const RegisterPage(),
      '/terms': (_) => const TermsPage(),
      '/home': (_) => const AuthGate(),
    },
  );
}

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
