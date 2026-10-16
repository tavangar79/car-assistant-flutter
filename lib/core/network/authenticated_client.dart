import 'package:http/http.dart' as http;

import '../storage/token_storage.dart';

/// Adds `Authorization: Bearer <token>` to every request when a token is stored.
///
/// When the server rejects a sent token (401), [onUnauthorized] is called so the app can sign out.
/// The OTP endpoints are excluded: a 401 there means a wrong code, not a lost session.
class AuthenticatedClient extends http.BaseClient {
  AuthenticatedClient({required this._inner, required this._tokenStorage, this._onUnauthorized});

  final http.Client _inner;
  final TokenStorage _tokenStorage;
  final void Function()? _onUnauthorized;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _readToken();
    final hasToken = token != null && token.isNotEmpty;
    if (hasToken) request.headers['Authorization'] = 'Bearer $token';
    final response = await _inner.send(request);
    if (response.statusCode == 401 && hasToken && !_isOtpCall(request.url)) {
      _onUnauthorized?.call();
    }
    return response;
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

  static bool _isOtpCall(Uri url) => url.path.contains('/api/auth/otp/');

  // The inner client is owned (and closed) by its own provider.
  @override
  void close() {}
}
