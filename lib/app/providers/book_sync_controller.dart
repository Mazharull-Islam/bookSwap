import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/hive_service.dart';
import '../../core/services/book_sync_service.dart';
import '../../core/services/reading_sync_service.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';

/// Triggers sync on sign-in (fireImmediately covers "already signed in on
/// relaunch"), on a periodic timer (SRS §3.6's "application launch... and a
/// timer"), and — for the reading list — shortly after any local change so
/// new entries reach Firestore quickly. Instantiated once by being watched
/// from AppShell, so it only runs once the user has actually reached the
/// authenticated area of the app.
class _BookSyncController {
  _BookSyncController(Ref ref) {
    String? memberId() {
      final user = ref.read(authControllerProvider).valueOrNull;
      return user != null && user.isMember ? user.id : null;
    }

    void syncAll() {
      final uid = memberId();
      if (uid == null) return;
      ref.read(bookSyncServiceProvider).sync(uid);
      ref.read(readingSyncServiceProvider).sync(uid);
    }

    ref.listen(
      authControllerProvider,
      (previous, next) => syncAll(),
      fireImmediately: true,
    );

    final timer = Timer.periodic(const Duration(minutes: 2), (_) => syncAll());

    // The reading list lives on this device first. Pushing a few seconds
    // after a change (debounced) keeps the server copy close behind.
    Timer? debounce;
    void readingChanged() {
      debounce?.cancel();
      debounce = Timer(const Duration(seconds: 3), () {
        final uid = memberId();
        if (uid != null) ref.read(readingSyncServiceProvider).sync(uid);
      });
    }

    final subscriptions = [
      HiveService.readingBox.watch().listen((_) => readingChanged()),
      HiveService.readingGoalsBox.watch().listen((_) => readingChanged()),
    ];

    ref.onDispose(() {
      timer.cancel();
      debounce?.cancel();
      for (final s in subscriptions) {
        s.cancel();
      }
    });
  }
}

final bookSyncControllerProvider = Provider<void>((ref) {
  _BookSyncController(ref);
});
