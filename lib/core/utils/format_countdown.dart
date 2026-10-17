import 'package:intl/intl.dart';

/// Formats [seconds] as `mm:ss` with the digits of [locale]: `۰۰:۴۵` in `fa`, `00:45` in `en`.
String formatCountdown(int seconds, String locale) {
  final twoDigits = NumberFormat('00', locale);
  return '${twoDigits.format(seconds ~/ 60)}:${twoDigits.format(seconds % 60)}';
}
