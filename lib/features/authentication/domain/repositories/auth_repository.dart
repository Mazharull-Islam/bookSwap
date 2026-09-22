import '../models/auth_user.dart';
import '../models/registration.dart';

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}

abstract interface class AuthRepository {
  Future<AuthUser?> restoreSession();
  Future<AuthUser> signIn(String email, String password);
  Future<AuthUser?> signInWithGoogle();
  Future<AuthUser> register(Registration registration);
  Future<AuthUser> refreshSession();
  Future<void> resendVerification();
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

String? validateEmail(String? input) {
  final value = input?.trim() ?? '';
  if (value.isEmpty) return 'Enter your email address.';
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? validatePassword(String? input) =>
    input == null || input.isEmpty ? 'Enter your password.' : null;
