import 'package:car_assistant/core/utils/recent_jalali_months.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shamsi_date/shamsi_date.dart';

void main() {
  List<(int, int)> yearMonths(List<Jalali> months) => [for (final m in months) (m.year, m.month)];

  test('lists the last six months, oldest first, ending with the current one', () {
    // 2026-10-21 is ۲۹ مهر ۱۴۰۵.
    final months = recentJalaliMonths(DateTime(2026, 10, 21));

    expect(yearMonths(months), [(1405, 2), (1405, 3), (1405, 4), (1405, 5), (1405, 6), (1405, 7)]);
  });

  test('crosses into the previous Jalali year', () {
    // 2026-05-01 is ۱۱ اردیبهشت ۱۴۰۵.
    final months = recentJalaliMonths(DateTime(2026, 5, 1));

    expect(yearMonths(months), [
      (1404, 9),
      (1404, 10),
      (1404, 11),
      (1404, 12),
      (1405, 1),
      (1405, 2),
    ]);
  });

  test('takes another count', () {
    expect(yearMonths(recentJalaliMonths(DateTime(2026, 10, 21), count: 1)), [(1405, 7)]);
  });
}
