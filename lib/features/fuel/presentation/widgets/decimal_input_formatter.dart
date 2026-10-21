import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/latin_digits.dart';
import '../../../../core/utils/localize_digits.dart';

/// Keeps a decimal number typed in any script (`.`, `٫` or `,` as the separator), at most
/// [maxIntegerDigits] before and [maxDecimals] after it, shown with the digits and the decimal
/// separator of [locale]: `۴۸٫۵` in `fa`. Read the value back with [parse].
class DecimalInputFormatter extends TextInputFormatter {
  const DecimalInputFormatter({
    required this.locale,
    this.maxIntegerDigits = 4,
    this.maxDecimals = 2,
  });

  final String locale;
  final int maxIntegerDigits;
  final int maxDecimals;

  static final _separators = RegExp('[٫,،]');
  static final _nonNumber = RegExp(r'[^\d.]');

  /// The Latin form of [text] (`۴۸٫۵` → `48.5`), with only its first decimal point kept.
  static String normalize(String text) {
    final latin = toLatinDigits(text).replaceAll(_separators, '.').replaceAll(_nonNumber, '');
    final point = latin.indexOf('.');
    if (point < 0) return latin;
    return '${latin.substring(0, point)}.${latin.substring(point + 1).replaceAll('.', '')}';
  }

  /// The number in [text], or `null` when it is empty or not a number.
  static double? parse(String text) => double.tryParse(normalize(text));

  /// Writes a Latin decimal string the way this formatter shows it.
  String format(String latin) {
    final separator = NumberFormat.decimalPattern(locale).symbols.DECIMAL_SEP;
    return localizeDigits(latin, locale).replaceAll('.', separator);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var latin = normalize(newValue.text);
    final point = latin.indexOf('.');
    var integer = point < 0 ? latin : latin.substring(0, point);
    if (integer.length > maxIntegerDigits) integer = integer.substring(0, maxIntegerDigits);
    if (point < 0) {
      latin = integer;
    } else {
      var decimals = latin.substring(point + 1);
      if (decimals.length > maxDecimals) decimals = decimals.substring(0, maxDecimals);
      latin = '$integer.$decimals';
    }
    final text = format(latin);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
