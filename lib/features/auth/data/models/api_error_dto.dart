import 'dart:convert';

/// The backend error body: `{ "error": { "message", "details"? } }`.
class ApiErrorDto {
  const ApiErrorDto({required this.message, this.details = const {}});

  /// Parses [body]; returns `null` when it is not a valid error body.
  static ApiErrorDto? tryParse(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final error = json['error'] as Map<String, dynamic>;
      return ApiErrorDto(
        message: error['message'] as String,
        details: (error['details'] as Map<String, dynamic>?) ?? const {},
      );
    } catch (_) {
      return null;
    }
  }

  final String message;
  final Map<String, dynamic> details;

  /// `details.retryAfterSeconds` of a 429 response.
  /// Any JSON number is accepted; anything else counts as missing.
  int? get retryAfterSeconds => switch (details['retryAfterSeconds']) {
    final num seconds => seconds.toInt(),
    _ => null,
  };

  /// `details.codeLength` of a 429 on request-OTP: the length of the code already sent.
  /// Any positive JSON number is accepted; anything else counts as missing.
  int? get codeLength => switch (details['codeLength']) {
    final num length when length >= 1 => length.toInt(),
    _ => null,
  };
}
