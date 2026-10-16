import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_failures.dart';
import '../models/api_error_dto.dart';
import '../models/otp_request_dto.dart';
import '../models/user_dto.dart';
import '../models/verify_otp_response_dto.dart';

/// HTTP calls for phone OTP auth. Throws a [Failure] for every non-200 response.
///
/// [client] must attach the bearer token for [fetchMe] (see `AuthenticatedClient`).
class AuthRemoteDataSource {
  const AuthRemoteDataSource({required this._client, required this._baseUrl});

  static const _json = {'Content-Type': 'application/json'};

  final http.Client _client;
  final String _baseUrl;

  Future<OtpRequestDto> requestOtp(String phone) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/otp/request'),
      headers: _json,
      body: jsonEncode({'phone': phone}),
    );
    final error = ApiErrorDto.tryParse(response.body);
    switch (response.statusCode) {
      case 200:
        return OtpRequestDto.fromJson(_decode(response));
      case 400:
        throw InvalidPhoneFailure(error?.message ?? 'Invalid phone number');
      case 429:
        throw TooManyRequestsFailure(error?.retryAfterSeconds ?? 0, codeLength: error?.codeLength);
      case 502:
        throw SmsSendFailure(error?.message ?? 'SMS provider failed');
      default:
        throw _unexpected('request a code', response);
    }
  }

  Future<VerifyOtpResponseDto> verifyOtp({required String phone, required String code}) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/otp/verify'),
      headers: _json,
      body: jsonEncode({'phone': phone, 'code': code}),
    );
    final error = ApiErrorDto.tryParse(response.body);
    switch (response.statusCode) {
      case 200:
        return VerifyOtpResponseDto.fromJson(_decode(response));
      // 400 = bad phone or a code of the wrong length: for the user it is a wrong code too.
      case 400:
      case 401:
        throw InvalidCodeFailure(error?.message ?? 'Invalid or expired code');
      case 429:
        throw TooManyRequestsFailure(error?.retryAfterSeconds ?? 0);
      default:
        throw _unexpected('verify the code', response);
    }
  }

  Future<UserDto> fetchMe() async {
    final response = await _client.get(Uri.parse('$_baseUrl/api/auth/me'));
    switch (response.statusCode) {
      case 200:
        return UserDto.fromJson(_decode(response));
      case 401:
        throw const UnauthorizedFailure();
      default:
        throw _unexpected('load the user', response);
    }
  }

  Map<String, dynamic> _decode(http.Response response) =>
      jsonDecode(response.body) as Map<String, dynamic>;

  Failure _unexpected(String action, http.Response response) =>
      Failure('Could not $action (HTTP ${response.statusCode})');
}
