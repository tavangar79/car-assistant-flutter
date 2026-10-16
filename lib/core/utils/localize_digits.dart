import 'package:intl/intl.dart';

/// Writes each ASCII digit of [text] with the digits of [locale], keeping leading zeros:
/// `09121234567` → `۰۹۱۲۱۲۳۴۵۶۷` in `fa`. Other characters are kept as they are.
String localizeDigits(String text, String locale) {
  final number = NumberFormat('0', locale);
  return text.replaceAllMapped(RegExp(r'\d'), (m) => number.format(int.parse(m[0]!)));
}
