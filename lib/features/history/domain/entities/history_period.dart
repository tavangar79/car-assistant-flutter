/// The date ranges of the filter's "بازه زمانی ثبت".
enum HistoryPeriod {
  /// From the start of the current Jalali year to now.
  currentYear,

  /// From the start of the Jalali month five months back (six months with the current one) to now.
  lastSixMonths,

  /// No date bounds.
  allTime,

  /// A chosen range of Jalali days, both inclusive.
  custom,
}
