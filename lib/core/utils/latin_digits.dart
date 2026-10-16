/// Replaces Persian (۰-۹) and Arabic-Indic (٠-٩) digits in [input] with ASCII digits.
String toLatinDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= 0x06F0 && rune <= 0x06F9) {
      buffer.writeCharCode(0x30 + rune - 0x06F0);
    } else if (rune >= 0x0660 && rune <= 0x0669) {
      buffer.writeCharCode(0x30 + rune - 0x0660);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}
