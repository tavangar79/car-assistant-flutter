import 'package:car_assistant/features/auth/domain/entities/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneNumber.normalize', () {
    const expected = '09121234567';

    for (final input in [
      '09121234567',
      '+989121234567',
      '989121234567',
      '00989121234567',
      '۰۹۱۲۱۲۳۴۵۶۷',
      '٠٩١٢١٢٣٤٥٦٧',
      '+۹۸۹۱۲۱۲۳۴۵۶۷',
      ' 0912 123 4567 ',
      '0912-123-4567',
    ]) {
      test('normalizes "$input"', () => expect(PhoneNumber.normalize(input), expected));
    }

    for (final input in [
      '',
      '0912123456', // too short
      '091212345678', // too long
      '08121234567', // not a mobile prefix
      '9121234567', // missing leading 0
      '+19121234567',
      'abc',
    ]) {
      test('rejects "$input"', () => expect(PhoneNumber.normalize(input), isNull));
    }
  });
}
