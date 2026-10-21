import 'package:car_assistant/features/notifications/domain/entities/app_notification.dart';
import 'package:car_assistant/features/notifications/domain/entities/notification_category.dart';
import 'package:car_assistant/features/notifications/domain/entities/notification_kind.dart';

/// Shared notification test data, for vehicle `v1` (`tara` in the vehicle fixtures).

/// The Notification JSON sample of API-PHASE5.md T5.1.
Map<String, dynamic> intervalJson({bool read = false}) => {
  'id': 'n1',
  'kind': 'interval_due_soon',
  'category': 'service',
  'vehicleId': 'v1',
  'refId': 'engine_oil',
  'subject': 'تعویض روغن موتور',
  'dueKm': 42000,
  'remainingKm': 150,
  'mileageKm': 41850,
  'expiresAt': '2024-12-01T00:00:00.000Z',
  'thresholdDays': null,
  'read': read,
  'createdAt': '2026-10-21T16:45:00.000Z',
};

AppNotification intervalNotification({bool read = false}) => AppNotification(
  id: 'n1',
  kind: NotificationKind.intervalDueSoon,
  category: NotificationCategory.service,
  vehicleId: 'v1',
  refId: 'engine_oil',
  subject: 'تعویض روغن موتور',
  dueKm: 42000,
  remainingKm: 150,
  mileageKm: 41850,
  expiresAt: DateTime.utc(2024, 12),
  read: read,
  createdAt: DateTime.utc(2026, 10, 21, 16, 45),
);

/// A document expiry reminder: third-party insurance expiring on 8 Nov 2026.
Map<String, dynamic> documentExpiryJson({bool read = false}) => {
  'id': 'n2',
  'kind': 'document_expiry',
  'category': 'documents',
  'vehicleId': 'v1',
  'refId': 'd1',
  'subject': 'بیمه شخص ثالث',
  'dueKm': null,
  'remainingKm': null,
  'mileageKm': null,
  'expiresAt': '2026-11-08T00:00:00.000Z',
  'thresholdDays': 30,
  'read': read,
  'createdAt': '2026-10-20T15:00:00.000Z',
};

AppNotification documentExpiryNotification({bool read = false}) => AppNotification(
  id: 'n2',
  kind: NotificationKind.documentExpiry,
  category: NotificationCategory.documents,
  vehicleId: 'v1',
  refId: 'd1',
  subject: 'بیمه شخص ثالث',
  expiresAt: DateTime.utc(2026, 11, 8),
  thresholdDays: 30,
  read: read,
  createdAt: DateTime.utc(2026, 10, 20, 15),
);

/// An expense expiry reminder, already read.
AppNotification expenseExpiryNotification() => AppNotification(
  id: 'n3',
  kind: NotificationKind.expenseExpiry,
  category: NotificationCategory.documents,
  vehicleId: 'v1',
  refId: 'e1',
  subject: 'بیمه بدنه',
  expiresAt: DateTime.utc(2026, 11, 1),
  thresholdDays: 15,
  read: true,
  createdAt: DateTime.utc(2026, 10, 18, 9),
);
