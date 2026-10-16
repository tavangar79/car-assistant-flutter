import 'package:intl/intl.dart';

/// Formats a dotted version (e.g. `1.2.30`) with the digits and decimal separator
/// of [locale]: `۱٫۲٫۳۰` in `fa`, `1.2.30` in `en`.
String formatVersion(String version, String locale) {
  final number = NumberFormat('0', locale);
  final parts = version.split('.').map((part) {
    final value = int.tryParse(part);
    return value == null ? part : number.format(value);
  });
  return parts.join(number.symbols.DECIMAL_SEP);
}
