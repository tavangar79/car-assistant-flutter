import 'package:car_assistant/core/utils/format_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses Persian digits and decimal separator in fa', () {
    expect(formatVersion('1.2.30', 'fa'), '۱٫۲٫۳۰');
  });

  test('keeps Latin digits and dots in en', () {
    expect(formatVersion('1.2.30', 'en'), '1.2.30');
  });

  test('keeps non-numeric parts as they are', () {
    expect(formatVersion('1.0.0-beta', 'en'), '1.0.0-beta');
  });
}
