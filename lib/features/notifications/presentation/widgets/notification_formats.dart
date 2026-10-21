import 'package:intl/intl.dart';

import '../../../../core/utils/calendar_days_ago.dart';
import '../../../../core/utils/days_until.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_kind.dart';

/// When a notification arrived, relative to [now]: "همین الان", "۵ دقیقه پیش", "۲ ساعت پیش"
/// (same day), "دیروز، ۱۸:۳۰", "۳ روز پیش", "هفته گذشته" (7 to 13 days), else the Jalali date.
String formatRelativeTime(DateTime createdAt, DateTime now, AppLocalizations l10n) {
  final elapsed = now.difference(createdAt);
  if (elapsed.inMinutes < 1) return l10n.relativeJustNow;
  if (elapsed.inMinutes < 60) return l10n.relativeMinutesAgo(elapsed.inMinutes);
  final days = calendarDaysAgo(createdAt, now);
  if (days == 0) return l10n.relativeHoursAgo(elapsed.inHours);
  if (days == 1) return l10n.relativeYesterday(_clock(createdAt.toLocal(), l10n.localeName));
  if (days < 7) return l10n.relativeDaysAgo(days);
  if (days < 14) return l10n.relativeLastWeek;
  return formatJalaliDate(createdAt.toLocal(), l10n);
}

String _clock(DateTime time, String locale) {
  final two = NumberFormat('00', locale);
  return '${two.format(time.hour)}:${two.format(time.minute)}';
}

/// Days from [now] to an expiry reminder's date (negative once past); 0 without a date.
int notificationDaysLeft(AppNotification notification, DateTime now) =>
    switch (notification.expiresAt) {
      final date? => daysUntil(date, now),
      null => 0,
    };

/// The card title: "موعد `subject` `vehicle`" or "سررسید `subject`".
String notificationTitle(AppNotification notification, String vehicle, AppLocalizations l10n) =>
    notification.kind.isInterval
    ? l10n.notificationIntervalTitle(notification.subject, vehicle).trim()
    : l10n.notificationExpiryTitle(notification.subject);

/// The card body. Service reminders give the mileage and the km left (or past due); date-only
/// intervals give the due date. Expiry reminders count the days from [now].
String notificationBody(
  AppNotification notification,
  String vehicle,
  DateTime now,
  AppLocalizations l10n,
) {
  final overdue = notification.kind == NotificationKind.intervalOverdue;
  if (!notification.kind.isInterval) {
    final days = notificationDaysLeft(notification, now);
    return days > 0
        ? l10n.notificationExpiryBody(notification.subject, vehicle, days)
        : l10n.notificationExpiredBody(notification.subject, vehicle);
  }
  final mileage = notification.mileageKm;
  final remaining = notification.remainingKm;
  if (mileage != null && remaining != null) {
    final rest = overdue
        ? l10n.notificationIntervalOverdueKm(remaining.abs())
        : l10n.notificationIntervalRemaining(remaining);
    return '${l10n.notificationIntervalMileage(mileage)} $rest';
  }
  final date = switch (notification.expiresAt) {
    final date? => formatJalaliDate(date.toLocal(), l10n),
    null => '',
  };
  return overdue
      ? l10n.notificationIntervalOverdueDate(date)
      : l10n.notificationIntervalDueDate(date);
}
