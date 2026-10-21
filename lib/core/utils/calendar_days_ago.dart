/// Whole calendar days from [then] to [now], in local time: 0 for the same day, 1 for yesterday.
/// A [then] after [now] counts as today (0).
int calendarDaysAgo(DateTime then, DateTime now) {
  DateTime day(DateTime t) {
    final local = t.toLocal();
    // UTC midnights, so a daylight-saving change never shortens a day.
    return DateTime.utc(local.year, local.month, local.day);
  }

  final days = day(now).difference(day(then)).inDays;
  return days < 0 ? 0 : days;
}
