/// Route paths and names. Use these constants instead of string literals.
abstract final class AppRoutes {
  static const splashPath = '/';
  static const splashName = 'splash';

  /// Tabs of the signed-in shell, in dock order. Home is where a signed-in user lands.
  static const homePath = '/home';
  static const homeName = 'home';
  static const vehiclesPath = '/vehicles';
  static const vehiclesName = 'vehicles';
  static const historyPath = '/history';
  static const historyName = 'history';
  static const profilePath = '/profile';
  static const profileName = 'profile';

  /// Add a vehicle: a full page above the tabs (no dock).
  static const addVehiclePath = '/add-vehicle';
  static const addVehicleName = 'addVehicle';

  /// Phone entry. With [otpPath] it forms the sign-in flow.
  static const phonePath = '/login';
  static const phoneName = 'login';

  /// Code entry. Needs an `OtpArgs` as `extra`.
  static const otpPath = '/login/otp';
  static const otpName = 'otp';

  /// First name, last name and birth date; shown after sign-in while the profile is incomplete.
  static const completeProfilePath = '/complete-profile';
  static const completeProfileName = 'completeProfile';
}
