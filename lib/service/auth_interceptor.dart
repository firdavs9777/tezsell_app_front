import 'package:app/config/app_config.dart';
import 'package:app/service/session_manager.dart';
import 'package:app/service/token_store.dart';
import 'package:app/utils/app_logger.dart';
import 'package:dio/dio.dart';

/// Attaches `Authorization: Token <token>` to outgoing requests and, on a
/// 401 response, attempts one single-flighted silent refresh via
/// [SessionManager.tryRefresh] before retrying the original request exactly
/// once with the refreshed token. If refresh fails, forces
/// [SessionManager.onSessionExpired] (clear + redirect to /login) and
/// forwards the original error.
///
/// The refresh endpoint itself (and login/register, in case a Dio instance
/// is ever pointed at them) are exempt from both header injection and the
/// retry loop — retrying a failed refresh call through this same interceptor
/// would recurse forever.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;

  static const _retriedKey = '_auth_interceptor_retried';

  bool _isAuthExempt(String path) {
    return path.contains(AppConfig.refreshTokenPath) ||
        path.contains(AppConfig.loginPath) ||
        path.contains(AppConfig.registerPath);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthExempt(options.path)) {
      final token = TokenStore.instance.accessTokenCached ??
          await TokenStore.instance.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Token $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final alreadyRetried = options.extra[_retriedKey] == true;

    if (err.response?.statusCode != 401 ||
        alreadyRetried ||
        _isAuthExempt(options.path)) {
      handler.next(err);
      return;
    }

    final retried = await _retryWithFreshToken(options);
    if (retried != null) {
      handler.resolve(retried);
    } else {
      handler.next(err);
    }
  }

  // Several services in this codebase configure Dio with
  // `validateStatus: (status) => status! < 500`, which means a 401 arrives
  // as an ordinary [Response] (via [onResponse]) rather than throwing a
  // [DioException] (which would go through [onError] above). Both paths
  // funnel through [_retryWithFreshToken] so the refresh-retry behaves the
  // same regardless of a given service's `validateStatus`.
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final options = response.requestOptions;
    final alreadyRetried = options.extra[_retriedKey] == true;

    if (response.statusCode != 401 ||
        alreadyRetried ||
        _isAuthExempt(options.path)) {
      handler.next(response);
      return;
    }

    final retried = await _retryWithFreshToken(options);
    handler.next(retried ?? response);
  }

  /// Attempts a silent refresh and, on success, replays [options] once with
  /// the refreshed token. Returns the retried [Response], or `null` if
  /// refresh failed (in which case [SessionManager.onSessionExpired] has
  /// already been triggered) or the retry itself errored.
  Future<Response?> _retryWithFreshToken(RequestOptions options) async {
    final refreshed = await SessionManager.instance.tryRefresh();
    if (!refreshed) {
      SessionManager.instance.onSessionExpired();
      return null;
    }

    try {
      final newToken = await TokenStore.instance.getAccessToken();
      final retryOptions = options.copyWith(
        extra: {...options.extra, _retriedKey: true},
        headers: {
          ...options.headers,
          if (newToken != null && newToken.isNotEmpty)
            'Authorization': 'Token $newToken',
        },
      );
      return await _dio.fetch(retryOptions);
    } catch (e) {
      AppLogger.error('AuthInterceptor: retry after refresh failed: $e');
      return null;
    }
  }
}

/// Builds a [Dio] instance wired with [AuthInterceptor]. Pass [options] to
/// preserve a service's existing `BaseOptions` (timeouts, default headers,
/// etc.) — only [baseUrl] is otherwise applied.
Dio buildAuthedDio(String baseUrl, {BaseOptions? options}) {
  final dio = Dio(options ?? BaseOptions(baseUrl: baseUrl));
  dio.interceptors.add(AuthInterceptor(dio));
  return dio;
}
