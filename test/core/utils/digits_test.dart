import 'package:car_assistant/core/utils/format_countdown.dart';
import 'package:car_assistant/core/utils/latin_digits.dart';
import 'package:car_assistant/core/utils/localize_digits.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('toLatinDigits', () {
    test('converts Persian and Arabic digits and keeps the rest', () {
      expect(toLatinDigits('۰۹۱۲'), '0912');
      expect(toLatinDigits('٠٩١٢'), '0912');
      expect(toLatinDigits('+۹۸ 12'), '+98 12');
    });
  });

  group('localizeDigits', () {
    test('keeps leading zeros', () {
      expect(localizeDigits('09121234567', 'fa'), '۰۹۱۲۱۲۳۴۵۶۷');
      expect(localizeDigits('09121234567', 'en'), '09121234567');
    });
  });

  group('formatCountdown', () {
    test('formats m:ss with locale digits', () {
      expect(formatCountdown(45, 'en'), '0:45');
      expect(formatCountdown(65, 'en'), '1:05');
      expect(formatCountdown(45, 'fa'), '۰:۴۵');
    });
  });
}
