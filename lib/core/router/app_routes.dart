/// Route paths and names. Use these constants instead of string literals.
abstract final class AppRoutes {
  static const splashPath = '/';
  static const splashName = 'splash';

  /// Tabs of the signed-in shell, in dock order. Home is where a signed-in user lands.
  static const homePath = '/home';
  static const homeName = 'home';
  static const vehiclesPath = '/vehicles';
  static const vehiclesName = 'vehicles';

  /// A vehicle's details, inside the Garage tab: `/vehicles/:id`.
  static const vehicleDetailsName = 'vehicleDetails';
  static String vehicleDetailsPath(String vehicleId) => '$vehiclesPath/$vehicleId';

  /// A service visit's details, inside the Garage tab: `/vehicles/:id/services/:serviceId`.
  static const serviceDetailsName = 'serviceDetails';
  static String serviceDetailsPath(String vehicleId, String serviceId) =>
      '${vehicleDetailsPath(vehicleId)}/services/$serviceId';

  /// Record a service visit: a full page above the tabs (no dock). Optional `extra`:
  /// a `List<String>` of item ids to preselect.
  static const newServiceName = 'newService';
  static String newServicePath(String vehicleId) => '${vehicleDetailsPath(vehicleId)}/services/new';

  /// The service intervals of a vehicle, inside the Garage tab: `/vehicles/:id/intervals`.
  static const intervalsName = 'intervals';
  static String intervalsPath(String vehicleId) => '${vehicleDetailsPath(vehicleId)}/intervals';

  /// The due services of a vehicle: a full page above the tabs (no dock), also opened right after
  /// an odometer update. Optional `extra`: an `OdometerUpdateArgs` for the success header.
  static const dueName = 'due';
  static String duePath(String vehicleId) => '${vehicleDetailsPath(vehicleId)}/due';
  static const historyPath = '/history';
  static const historyName = 'history';
  static const profilePath = '/profile';
  static const profileName = 'profile';

  /// Add a vehicle: a full page above the tabs (no dock).
  static const addVehiclePath = '/add-vehicle';
  static const addVehicleName = 'addVehicle';

  /// Edit a vehicle: the add page, filled in. Needs the `Vehicle` as `extra`.
  static const editVehiclePath = '/edit-vehicle';
  static const editVehicleName = 'editVehicle';

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
