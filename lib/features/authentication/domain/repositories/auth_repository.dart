import '../entities/auth_user.dart';
import '../entities/registration.dart';

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}

/// Raised when a saved session couldn't be restored at launch. Distinct from
/// a failed sign-in so the landing page can say what happened and offer a
/// retry, rather than silently looking like a sign-out.
class SessionRestoreFailure extends AuthFailure {
  const SessionRestoreFailure(super.message);
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

  /// Null clears the preference (no distance limit).
  Future<void> updateMaxDistance(double? km);

  /// Validates, then saves the editable profile fields (and the public
  /// display name other members see).
  Future<void> updateProfile(ProfileUpdate update);
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
