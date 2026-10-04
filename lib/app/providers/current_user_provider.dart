import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../shared/models/app_user.dart';

/// Maps the real signed-in user (once auth finishes loading) onto the
/// minimal cross-feature AppUser. Falls back to a placeholder while auth is
/// loading/signed-out so features built before auth existed keep working.
final currentUserProvider = Provider<AppUser>((ref) {
  final user = ref.watch(authControllerProvider).valueOrNull;
  if (user == null) {
    return const AppUser(id: 'placeholder-user', displayName: 'You');
  }
  return AppUser(id: user.id, displayName: user.name);
});
