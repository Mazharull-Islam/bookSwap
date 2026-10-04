import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'retry_on_timeout_interceptor.dart';

/// Single shared Dio instance for all external REST calls (Open Library,
/// Google Books). Firebase SDKs handle their own networking and don't use this.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // Generous enough for ordinary slow connections, not just fast ones.
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  dio.interceptors.add(RetryOnTimeoutInterceptor(dio));
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }
  return dio;
});
