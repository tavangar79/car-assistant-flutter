import 'package:flutter/services.dart';

import '../../../../core/utils/latin_digits.dart';

/// Keeps the national part of an Iranian mobile number (after +98) and groups it as `912 345 6789`.
///
/// Persian/Arabic digits become ASCII; a typed or pasted `0`, `+98` or `0098` prefix is dropped.
class PhoneInputFormatter extends TextInputFormatter {
  const PhoneInputFormatter();

  /// Digits after +98.
  static const maxDigits = 10;

  static final _nonDigits = RegExp(r'\D');
  static final _leadingZeros = RegExp(r'^0+');

  /// The national digits of [text], at most [maxDigits].
  static String digitsOf(String text) {
    var digits = toLatinDigits(text).replaceAll(_nonDigits, '').replaceFirst(_leadingZeros, '');
    if (digits.length > maxDigits && digits.startsWith('98')) digits = digits.substring(2);
    return digits.length > maxDigits ? digits.substring(0, maxDigits) : digits;
  }

  /// `9123456789` → `912 345 6789`.
  static String group(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = group(digitsOf(newValue.text));
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
