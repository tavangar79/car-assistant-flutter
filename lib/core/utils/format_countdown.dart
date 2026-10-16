import 'package:intl/intl.dart';

/// Formats [seconds] as `m:ss` with the digits of [locale]: `۰:۴۵` in `fa`, `0:45` in `en`.
String formatCountdown(int seconds, String locale) {
  final minutes = NumberFormat('0', locale).format(seconds ~/ 60);
  final rest = NumberFormat('00', locale).format(seconds % 60);
  return '$minutes:$rest';
}
