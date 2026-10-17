import 'package:car_assistant/features/auth/presentation/widgets/phone_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String format(String input) => const PhoneInputFormatter()
      .formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: input))
      .text;

  test('groups the national digits as 912 345 6789', () {
    expect(format('9'), '9');
    expect(format('9123'), '912 3');
    expect(format('9123456'), '912 345 6');
    expect(format('9123456789'), '912 345 6789');
  });

  test('accepts Persian digits and drops 0, +98 and 0098 prefixes', () {
    expect(format('۹۱۲۳۴۵۶۷۸۹'), '912 345 6789');
    expect(format('09123456789'), '912 345 6789');
    expect(format('+98 912 345 6789'), '912 345 6789');
    expect(format('00989123456789'), '912 345 6789');
  });

  test('keeps at most 10 digits and drops anything else', () {
    expect(format('912-345-6789-99'), '912 345 6789');
    expect(format('abc'), '');
  });
}
