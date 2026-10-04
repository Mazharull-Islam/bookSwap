import 'dart:async';

import 'package:bookswap_login/core/utils/cached_image.dart';

/// Runs before every test file. The on-disk image cache needs real platform
/// storage, which flutter_test doesn't provide, so tests use plain network
/// images (tests that exercise the cache switch it back on themselves).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  diskImageCacheEnabled = false;
  await testMain();
}
