import '../../../../core/utils/latin_digits.dart';

/// Iranian mobile number rules, matching the backend: everything is normalized to `09xxxxxxxxx`.
abstract final class PhoneNumber {
  static final _valid = RegExp(r'^09\d{9}$');
  static final _separators = RegExp(r'[\s\-()]');

  /// Accepts `09…`, `+989…`, `989…`, `00989…` and Persian/Arabic digits, ignoring spaces and
  /// dashes. Returns `09xxxxxxxxx`, or `null` when [input] is not a valid Iranian mobile number.
  static String? normalize(String input) {
    var phone = toLatinDigits(input).replaceAll(_separators, '');
    if (phone.startsWith('+98')) {
      phone = '0${phone.substring(3)}';
    } else if (phone.startsWith('0098')) {
      phone = '0${phone.substring(4)}';
    } else if (phone.startsWith('98')) {
      phone = '0${phone.substring(2)}';
    }
    return _valid.hasMatch(phone) ? phone : null;
  }
}
