/// The quick ranges of the export page ("بازه زمانی گزارش").
enum ReportPeriod {
  /// The same Jalali day three months back, to now.
  lastThreeMonths,

  /// The same Jalali day six months back, to now.
  lastSixMonths,

  /// From the start of the current Jalali year to now.
  currentYear,

  /// No lower bound.
  allTime,

  /// Chosen "از تاریخ / تا تاریخ" days, both inclusive.
  custom,
}
