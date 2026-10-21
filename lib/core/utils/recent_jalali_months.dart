import 'package:shamsi_date/shamsi_date.dart';

/// The last [count] Jalali months up to and including the month of [now], oldest first, each as
/// the first day of that month: on ۲۹ مهر ۱۴۰۵ and a count of 6 it is اردیبهشت … مهر ۱۴۰۵.
List<Jalali> recentJalaliMonths(DateTime now, {int count = 6}) {
  final current = Jalali.fromDateTime(now.toLocal());
  return [
    for (var back = count - 1; back >= 0; back--) _monthsBefore(current.year, current.month, back),
  ];
}

Jalali _monthsBefore(int year, int month, int back) {
  final index = year * 12 + (month - 1) - back;
  return Jalali(index ~/ 12, index % 12 + 1);
}
