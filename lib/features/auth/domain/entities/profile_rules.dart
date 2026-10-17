/// Profile validation, matching the backend: names are trimmed and 1–50 characters long,
/// the birth date is not in the future and its year is at least 1900.
abstract final class ProfileRules {
  static const maxNameLength = 50;
  static const minBirthYear = 1900;

  static bool isValidName(String name) {
    final trimmed = name.trim();
    return trimmed.isNotEmpty && trimmed.length <= maxNameLength;
  }

  /// Compares calendar days only, so any time of [today] counts.
  static bool isValidBirthDate(DateTime birthDate, DateTime today) {
    final day = DateTime(birthDate.year, birthDate.month, birthDate.day);
    return birthDate.year >= minBirthYear &&
        !day.isAfter(DateTime(today.year, today.month, today.day));
  }
}
