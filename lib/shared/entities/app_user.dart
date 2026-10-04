/// Minimal cross-feature user reference, so other features don't depend on the
/// auth feature's `AuthUser` directly. See `currentUserProvider`.
class AppUser {
  const AppUser({required this.id, required this.displayName});
  final String id;
  final String displayName;
}
