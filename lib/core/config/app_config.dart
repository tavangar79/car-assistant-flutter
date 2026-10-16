/// Build-time configuration.
///
/// Override with: flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
/// (10.0.2.2 is the host machine from the Android emulator.)
class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
