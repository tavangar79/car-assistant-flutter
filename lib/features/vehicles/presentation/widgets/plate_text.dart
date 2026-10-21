import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/plate.dart';

/// The plate on one line with the locale's digits: `۷۲ ب ۳۴۵ ایران ۶۸`.
String plateText(Plate plate, AppLocalizations l10n) {
  String digits(String value) => localizeDigits(value, l10n.localeName);
  return l10n.vehiclePlateText(
    digits(plate.twoDigits),
    plate.letter,
    digits(plate.threeDigits),
    digits(plate.provinceCode),
  );
}
