import 'package:car_assistant/features/notifications/domain/entities/app_notification.dart';
import 'package:car_assistant/features/notifications/domain/entities/notification_category.dart';
import 'package:car_assistant/features/notifications/domain/entities/notification_kind.dart';
import 'package:car_assistant/features/notifications/presentation/widgets/notification_formats.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../notification_fixtures.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('fa'));
  final now = DateTime(2026, 10, 21, 18, 45);
  const tara = 'تارا';

  group('formatRelativeTime', () {
    String ago(Duration elapsed) => formatRelativeTime(now.subtract(elapsed), now, l10n);

    test('under a minute is "just now"', () {
      expect(ago(const Duration(seconds: 30)), 'همین الان');
    });

    test('minutes, then hours on the same day', () {
      expect(ago(const Duration(minutes: 5)), '۵ دقیقه پیش');
      expect(ago(const Duration(hours: 2, minutes: 10)), '۲ ساعت پیش');
    });

    test('yesterday shows the clock time', () {
      expect(formatRelativeTime(DateTime(2026, 10, 20, 18, 30), now, l10n), 'دیروز، ۱۸:۳۰');
    });

    test('2 to 6 days, then last week', () {
      expect(formatRelativeTime(DateTime(2026, 10, 18, 9), now, l10n), '۳ روز پیش');
      expect(formatRelativeTime(DateTime(2026, 10, 13), now, l10n), 'هفته گذشته');
    });

    test('older shows the Jalali date', () {
      expect(formatRelativeTime(DateTime(2026, 9, 1), now, l10n), '۱۰ شهریور ۱۴۰۵');
    });
  });

  group('interval reminders', () {
    test('title is "موعد <subject> <vehicle>"', () {
      expect(notificationTitle(intervalNotification(), tara, l10n), 'موعد تعویض روغن موتور تارا');
    });

    test('due soon body gives the mileage and the km left', () {
      expect(
        notificationBody(intervalNotification(), tara, now, l10n),
        'کارکرد خودرو به ۴۱٬۸۵۰ کیلومتر رسیده است. تنها ۱۵۰ کیلومتر تا سرویس باقی مانده است.',
      );
    });

    test('overdue body gives the km past due', () {
      final overdue = AppNotification(
        id: 'n9',
        kind: NotificationKind.intervalOverdue,
        category: NotificationCategory.service,
        vehicleId: 'v1',
        refId: 'engine_oil',
        subject: 'روغن موتور',
        remainingKm: -320,
        mileageKm: 42320,
        read: false,
        createdAt: now,
      );
      expect(
        notificationBody(overdue, tara, now, l10n),
        'کارکرد خودرو به ۴۲٬۳۲۰ کیلومتر رسیده است. ۳۲۰ کیلومتر از موعد گذشته است.',
      );
    });

    test('a date-only interval gives the due date', () {
      final byDate = AppNotification(
        id: 'n9',
        kind: NotificationKind.intervalDueSoon,
        category: NotificationCategory.service,
        vehicleId: 'v1',
        refId: 'coolant',
        subject: 'ضدیخ',
        expiresAt: DateTime.utc(2026, 11, 8),
        read: false,
        createdAt: now,
      );
      expect(notificationBody(byDate, tara, now, l10n), 'موعد سرویس ۱۷ آبان ۱۴۰۵ است.');
    });
  });

  group('expiry reminders', () {
    test('title is "سررسید <subject>"', () {
      expect(notificationTitle(documentExpiryNotification(), tara, l10n), 'سررسید بیمه شخص ثالث');
    });

    test('body counts the days from now, not the snapshot threshold', () {
      expect(notificationDaysLeft(documentExpiryNotification(), now), 18);
      expect(
        notificationBody(documentExpiryNotification(), tara, now, l10n),
        'بیمه شخص ثالث خودرو تارا ۱۸ روز دیگر به اتمام می‌رسد.',
      );
    });

    test('once past, the body says it has expired', () {
      final later = DateTime(2026, 11, 9);
      expect(notificationDaysLeft(documentExpiryNotification(), later), -1);
      expect(
        notificationBody(documentExpiryNotification(), tara, later, l10n),
        'بیمه شخص ثالث خودرو تارا منقضی شده است.',
      );
    });
  });
}
