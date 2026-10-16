/// Route paths and names. Use these constants instead of string literals.
abstract final class AppRoutes {
  static const splashPath = '/';
  static const splashName = 'splash';
  static const vehiclesPath = '/vehicles';
  static const vehiclesName = 'vehicles';

  /// Phone entry. With [otpPath] it forms the sign-in flow.
  static const phonePath = '/login';
  static const phoneName = 'login';

  /// Code entry. Needs an `OtpArgs` as `extra`.
  static const otpPath = '/login/otp';
  static const otpName = 'otp';
}
