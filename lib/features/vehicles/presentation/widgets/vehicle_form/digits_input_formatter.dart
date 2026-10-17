import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/latin_digits.dart';
import '../../../../../core/utils/localize_digits.dart';

/// Keeps only digits (typed in any script), at most [maxDigits], and writes them with the digits
/// of [locale]: `۷۲` in `fa`. With [grouped] the number gets thousands separators: `۳۴٬۵۰۰`.
/// Read the value back with [digitsOf], which always returns Latin digits.
class DigitsInputFormatter extends TextInputFormatter {
  const DigitsInputFormatter({required this.locale, required this.maxDigits, this.grouped = false});

  final String locale;
  final int maxDigits;
  final bool grouped;

  static final _nonDigits = RegExp(r'\D');

  /// The Latin digits in [text], e.g. `۳۴٬۵۰۰` → `34500`.
  static String digitsOf(String text) => toLatinDigits(text).replaceAll(_nonDigits, '');

  /// Formats Latin [digits] the way this formatter shows them.
  String format(String digits) {
    if (digits.isEmpty) return '';
    if (grouped) return NumberFormat.decimalPattern(locale).format(int.parse(digits));
    return localizeDigits(digits, locale);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = digitsOf(newValue.text);
    if (digits.length > maxDigits) digits = digits.substring(0, maxDigits);
    final text = format(digits);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
