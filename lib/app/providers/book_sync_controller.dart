import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/book_sync_service.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';

/// Triggers book sync on sign-in (fireImmediately covers "already signed in
/// on relaunch") and on a periodic timer, per SRS §3.6's "application
/// launch... and a timer" triggers. Instantiated once by being watched from
/// AppShell, so it only runs once the user has actually reached the
/// authenticated area of the app.
class _BookSyncController {
  _BookSyncController(Ref ref) {
    ref.listen(authControllerProvider, (previous, next) {
      final user = next.valueOrNull;
      if (user != null && user.isMember) {
        ref.read(bookSyncServiceProvider).sync(user.id);
      }
    }, fireImmediately: true);

    final timer = Timer.periodic(const Duration(minutes: 2), (_) {
      final user = ref.read(authControllerProvider).valueOrNull;
      if (user != null && user.isMember) {
        ref.read(bookSyncServiceProvider).sync(user.id);
      }
    });
    ref.onDispose(timer.cancel);
  }
}

final bookSyncControllerProvider = Provider<void>((ref) {
  _BookSyncController(ref);
});
