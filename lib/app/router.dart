import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/authentication/domain/models/auth_user.dart';
import '../features/authentication/presentation/providers/auth_providers.dart';
import '../features/authentication/presentation/screens/login_page.dart';
import '../features/authentication/presentation/screens/profile_page.dart';
import '../features/authentication/presentation/screens/register_page.dart';
import '../features/authentication/presentation/screens/terms_page.dart';
import '../features/authentication/presentation/screens/verification_page.dart';
import '../features/authentication/presentation/screens/welcome_page.dart';
import '../features/blocking/presentation/screens/blocked_users_page.dart';
import '../features/book_of_month/presentation/screens/book_of_month_page.dart';
import '../features/books/domain/models/book.dart';
import '../features/books/presentation/screens/add_book_page.dart';
import '../features/books/presentation/screens/my_shelf_page.dart';
import '../features/borrow_requests/presentation/screens/requests_page.dart';
import '../features/discovery/presentation/screens/discovery_page.dart';
import '../features/forum/presentation/screens/forum_page.dart';
import '../features/reading/presentation/screens/reading_page.dart';
import '../features/wanted_books/presentation/screens/wanted_books_page.dart';
import 'providers/book_sync_controller.dart';

enum _AuthStage {
  loading,
  unauthenticated,
  needsProfile,
  needsVerification,
  authenticated,
}

_AuthStage _stageOf(AsyncValue<AuthUser?> state) {
  if (state.isLoading && !state.hasValue) return _AuthStage.loading;
  final user = state.valueOrNull;
  if (user == null) return _AuthStage.unauthenticated;
  if (user.profile == null) return _AuthStage.needsProfile;
  if (!user.emailVerified) return _AuthStage.needsVerification;
  return _AuthStage.authenticated;
}

String? _redirectFor(_AuthStage stage, String location) {
  if (location == '/terms') return null;
  switch (stage) {
    case _AuthStage.loading:
      return null;
    case _AuthStage.unauthenticated:
      return {'/', '/login', '/register'}.contains(location) ? null : '/';
    case _AuthStage.needsProfile:
      return location == '/register' ? null : '/register';
    case _AuthStage.needsVerification:
      return location == '/verify' ? null : '/verify';
    case _AuthStage.authenticated:
      return location.startsWith('/shelf') ||
              location == '/profile' ||
              location == '/discover' ||
              location == '/wishlist' ||
              location == '/reading' ||
              location == '/requests' ||
              location == '/blocked' ||
              location == '/forum' ||
              location == '/book-of-month'
          ? null
          : '/shelf';
  }
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) => _redirectFor(
      _stageOf(ref.read(authControllerProvider)),
      state.matchedLocation,
    ),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const _RootPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) => const VerificationPage(),
      ),
      GoRoute(path: '/terms', builder: (context, state) => const TermsPage()),
      GoRoute(
        path: '/shelf/add',
        builder: (context, state) =>
            AddBookPage(existing: state.extra as Book?),
      ),
      GoRoute(
        path: '/blocked',
        builder: (context, state) => const BlockedUsersPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/shelf',
            builder: (context, state) => const MyShelfPage(),
          ),
          GoRoute(
            path: '/discover',
            builder: (context, state) => const DiscoveryPage(),
          ),
          GoRoute(
            path: '/wishlist',
            builder: (context, state) => const WantedBooksPage(),
          ),
          GoRoute(
            path: '/reading',
            builder: (context, state) => const ReadingPage(),
          ),
          GoRoute(
            path: '/requests',
            builder: (context, state) => const RequestsPage(),
          ),
          GoRoute(
            path: '/forum',
            builder: (context, state) => const ForumPage(),
          ),
          GoRoute(
            path: '/book-of-month',
            builder: (context, state) => const BookOfMonthPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
});

class _RootPage extends ConsumerWidget {
  const _RootPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider);
    if (session.isLoading && session.valueOrNull == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const WelcomePage();
  }
}

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bookSyncControllerProvider);
    return child;
  }
}
