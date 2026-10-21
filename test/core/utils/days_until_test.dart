import 'package:car_assistant/core/utils/days_until.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 21, 18, 45);

  test('counts calendar days to a future date', () {
    expect(daysUntil(DateTime(2026, 10, 21, 1), now), 0);
    expect(daysUntil(DateTime(2026, 10, 22), now), 1);
    expect(daysUntil(DateTime(2026, 11, 8), now), 18);
  });

  test('is negative once the date is past', () {
    expect(daysUntil(DateTime(2026, 10, 20, 23), now), -1);
    expect(daysUntil(DateTime(2026, 7, 28), now), -85);
  });
}
