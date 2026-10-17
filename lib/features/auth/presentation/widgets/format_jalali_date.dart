import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';

/// A Gregorian [date] as a Jalali date in words, e.g. `۲۱ آبان ۱۳۷۰` in `fa`.
String formatJalaliDate(DateTime date, AppLocalizations l10n) {
  final jalali = Jalali.fromDateTime(date);
  return l10n.profileBirthDateValue(
    localizeDigits('${jalali.day}', l10n.localeName),
    l10n.jalaliMonth('${jalali.month}'),
    localizeDigits('${jalali.year}', l10n.localeName),
  );
}
