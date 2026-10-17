/// The backend error body: `{ "error": { "message", "details"? } }`.
class ApiErrorDto {
  const ApiErrorDto({required this.message, this.details = const {}});

  /// Parses a decoded response body; returns `null` when it is not a valid error body.
  static ApiErrorDto? tryParse(Object? data) {
    if (data case {
      'error': {'message': final String message} && final Map<String, dynamic> error,
    }) {
      final details = error['details'];
      return ApiErrorDto(
        message: message,
        details: details is Map<String, dynamic> ? details : const {},
      );
    }
    return null;
  }

  final String message;
  final Map<String, dynamic> details;

  /// `details.retryAfterSeconds` of a 429 response. Any JSON number is accepted.
  int? get retryAfterSeconds => switch (details['retryAfterSeconds']) {
    final num seconds => seconds.toInt(),
    _ => null,
  };

  /// `details.codeLength` of a 429 on request-OTP: the length of the code already sent.
  /// Any positive JSON number is accepted.
  int? get codeLength => switch (details['codeLength']) {
    final num length when length >= 1 => length.toInt(),
    _ => null,
  };
}
