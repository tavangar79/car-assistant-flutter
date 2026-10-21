import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';

/// A local [date] with its weekday, e.g. `جمعه، ۲۵ آبان ۱۴۰۳`.
String formatServiceDate(DateTime date, AppLocalizations l10n) {
  final weekday = l10n.jalaliWeekday('${Jalali.fromDateTime(date).weekDay}');
  return l10n.serviceDateValue(weekday, formatJalaliDate(date, l10n));
}

/// A local [date] as a Jalali day and month without the year, e.g. `۲۴ آبان`.
String formatJalaliDayMonth(DateTime date, AppLocalizations l10n) {
  final jalali = Jalali.fromDateTime(date);
  return '${localizeDigits('${jalali.day}', l10n.localeName)} ${l10n.jalaliMonth('${jalali.month}')}';
}

/// The Jalali month name and year of [date] plus [months] calendar months, as `(month, year)`.
(String, String) dueMonthYear(DateTime date, int months, AppLocalizations l10n) {
  final due = Jalali.fromDateTime(DateTime(date.year, date.month + months, date.day));
  return (l10n.jalaliMonth('${due.month}'), localizeDigits('${due.year}', l10n.localeName));
}

/// Minutes since midnight as `HH:MM` in locale digits.
String formatMinutes(int minutes, String locale) {
  String two(int n) => n.toString().padLeft(2, '0');
  return localizeDigits('${two(minutes ~/ 60)}:${two(minutes % 60)}', locale);
}

/// A size in bytes as megabytes with one decimal, e.g. `۱٫۴ مگابایت`.
String formatMegabytes(int bytes, AppLocalizations l10n) =>
    l10n.megabytes(NumberFormat('0.0', l10n.localeName).format(bytes / (1024 * 1024)));
