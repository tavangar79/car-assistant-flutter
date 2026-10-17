import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Adds `Authorization: Bearer <token>` to every request when a token is stored.
///
/// When the server rejects a sent token (401), [onUnauthorized] is called so the app can sign out.
/// The OTP endpoints are excluded: a 401 there means a wrong code, not a lost session.
/// A 404 from the account endpoints (`/api/auth/me`, and changing the photo) means the account was
/// deleted, which also signs out; a 404 when loading the photo only means there is none.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this._tokenStorage, this._onUnauthorized});

  static const _header = 'Authorization';

  final TokenStorage _tokenStorage;
  final void Function()? _onUnauthorized;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _readToken();
    if (token != null && token.isNotEmpty) options.headers[_header] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    final sentToken = request.headers.containsKey(_header);
    final status = err.response?.statusCode;
    final lostSession =
        (status == 401 && !_isOtpCall(request.path)) || (status == 404 && _isAccountCall(request));
    if (sentToken && lostSession) {
      _onUnauthorized?.call();
    }
    handler.next(err);
  }

  /// A broken keystore must not block sign-in: treat it as "no token" and try to wipe it.
  Future<String?> _readToken() async {
    try {
      return await _tokenStorage.read();
    } catch (_) {
      try {
        await _tokenStorage.clear();
      } catch (_) {}
      return null;
    }
  }

  static bool _isOtpCall(String path) => path.contains('/api/auth/otp/');

  static bool _isAccountCall(RequestOptions request) {
    final path = Uri.parse(request.path).path;
    if (path.endsWith('/api/auth/me')) return true;
    return path.endsWith('/api/auth/me/avatar') && request.method.toUpperCase() != 'GET';
  }
}
