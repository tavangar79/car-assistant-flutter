/// Whole calendar days from [now] to [date], in local time: 0 when [date] is today, 1 for
/// tomorrow, negative once it is past (-1 for yesterday).
int daysUntil(DateTime date, DateTime now) {
  DateTime day(DateTime t) {
    final local = t.toLocal();
    // UTC midnights, so a daylight-saving change never shortens a day.
    return DateTime.utc(local.year, local.month, local.day);
  }

  return day(date).difference(day(now)).inDays;
}
