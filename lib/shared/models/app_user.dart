/// Minimal cross-feature user reference. Other features depend on this
/// instead of the auth feature's `AuthUser` directly, so they can be built
/// and tested before real authentication lands — see
/// `shared/providers/current_user_provider.dart` for the wiring seam.
class AppUser {
  const AppUser({required this.id, required this.displayName});
  final String id;
  final String displayName;
}
