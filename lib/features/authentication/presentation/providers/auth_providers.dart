import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/use_cases/auth_use_cases.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../domain/models/auth_user.dart';
import '../../domain/models/registration.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);
final signInProvider = Provider(
  (ref) => SignIn(ref.watch(authRepositoryProvider)),
);
final authControllerProvider = AsyncNotifierProvider<AuthController, AuthUser?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() =>
      ref.watch(authRepositoryProvider).restoreSession();

  Future<void> _run(Future<AuthUser?> Function() operation) async {
    if (state.isLoading) return;
    final previous = state;
    state = const AsyncLoading<AuthUser?>().copyWithPrevious(previous);
    try {
      state = AsyncData(await operation());
    } catch (error, stack) {
      state = AsyncError<AuthUser?>(error, stack).copyWithPrevious(previous);
    }
  }

  Future<void> signIn(String email, String password) =>
      _run(() => ref.read(signInProvider)(email, password));

  Future<void> signInWithGoogle() {
    final previous = state.valueOrNull;
    return _run(
      () async =>
          await ref.read(authRepositoryProvider).signInWithGoogle() ?? previous,
    );
  }

  void clearError() {
    if (state.hasError) state = AsyncData(state.valueOrNull);
  }

  Future<void> register(Registration data) => _run(
    () => Register(ref.read(authRepositoryProvider))(
      data,
      requirePassword: !(state.valueOrNull?.usesGoogle ?? false),
    ),
  );

  Future<void> refreshSession() =>
      _run(() => ref.read(authRepositoryProvider).refreshSession());

  Future<void> resendVerification() {
    final previous = state.valueOrNull;
    return _run(() async {
      await ref.read(authRepositoryProvider).resendVerification();
      return previous;
    });
  }

  Future<void> resetPassword(String email) {
    final previous = state.valueOrNull;
    return _run(() async {
      final error = validateEmail(email);
      if (error != null) throw AuthFailure(error);
      await ref.read(authRepositoryProvider).resetPassword(email);
      return previous;
    });
  }

  Future<void> signOut() => _run(() async {
    await ref.read(authRepositoryProvider).signOut();
    return null;
  });
}
