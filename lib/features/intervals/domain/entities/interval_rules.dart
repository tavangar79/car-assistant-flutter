import 'interval_setting.dart';

/// The backend's interval limits, checked before sending.
abstract final class IntervalRules {
  static const minKm = 500;
  static const maxKm = 200000;
  static const minMonths = 1;
  static const maxMonths = 120;

  static bool isValidKm(int km) => km >= minKm && km <= maxKm;

  static bool isValidMonths(int months) => months >= minMonths && months <= maxMonths;

  static bool isValid(IntervalSetting setting) =>
      isValidKm(setting.km) && isValidMonths(setting.months);
}
