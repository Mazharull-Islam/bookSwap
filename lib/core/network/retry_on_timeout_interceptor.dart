import 'package:dio/dio.dart';

/// Retries a request once (by default) when it fails for a transient,
/// connectivity-shaped reason — a timeout or a dropped connection — rather
/// than surfacing failure on the first hiccup. Does not retry on 4xx/5xx
/// HTTP responses or other error types, since those won't be fixed by
/// trying again immediately.
class RetryOnTimeoutInterceptor extends Interceptor {
  RetryOnTimeoutInterceptor(this._dio, {this.maxRetries = 1});

  final Dio _dio;
  final int maxRetries;

  static const _retryableTypes = {
    DioExceptionType.connectionTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.connectionError,
  };

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra['retryAttempt'] as int?) ?? 0;
    if (!_retryableTypes.contains(err.type) || attempt >= maxRetries) {
      return handler.next(err);
    }
    final options = err.requestOptions
      ..extra = {...err.requestOptions.extra, 'retryAttempt': attempt + 1};
    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
