import 'package:car_assistant/core/utils/calendar_days_ago.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 21, 9, 30);

  test('is 0 for earlier the same day', () {
    expect(calendarDaysAgo(DateTime(2026, 10, 21, 0, 5), now), 0);
  });

  test('is 1 for yesterday, even less than 24 hours ago', () {
    expect(calendarDaysAgo(DateTime(2026, 10, 20, 23, 59), now), 1);
  });

  test('counts calendar days across a month', () {
    expect(calendarDaysAgo(DateTime(2026, 9, 30, 12), now), 21);
  });

  test('a future date counts as today', () {
    expect(calendarDaysAgo(DateTime(2026, 10, 22), now), 0);
  });
}
