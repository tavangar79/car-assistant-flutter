import 'package:equatable/equatable.dart';

import 'notification_category.dart';
import 'notification_kind.dart';

/// One notification of the inbox. The screen text is composed on the client from these fields.
class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.category,
    required this.vehicleId,
    required this.refId,
    required this.subject,
    required this.read,
    required this.createdAt,
    this.dueKm,
    this.remainingKm,
    this.mileageKm,
    this.expiresAt,
    this.thresholdDays,
  });

  final String id;
  final NotificationKind kind;
  final NotificationCategory category;
  final String vehicleId;

  /// The interval id, expense id or document id.
  final String refId;

  /// Persian title snapshot: interval title, expense or document title.
  final String subject;

  /// Interval kinds only.
  final int? dueKm;

  /// Interval kinds only, at creation; negative once overdue.
  final int? remainingKm;

  /// Interval kinds only: the vehicle mileage at creation.
  final int? mileageKm;

  /// The expiry (expiry kinds) or the interval's due date (interval kinds).
  final DateTime? expiresAt;

  /// Expiry kinds only: 30, 15 or 7.
  final int? thresholdDays;
  final bool read;
  final DateTime createdAt;

  AppNotification markedRead() => AppNotification(
    id: id,
    kind: kind,
    category: category,
    vehicleId: vehicleId,
    refId: refId,
    subject: subject,
    read: true,
    createdAt: createdAt,
    dueKm: dueKm,
    remainingKm: remainingKm,
    mileageKm: mileageKm,
    expiresAt: expiresAt,
    thresholdDays: thresholdDays,
  );

  @override
  List<Object?> get props => [
    id,
    kind,
    category,
    vehicleId,
    refId,
    subject,
    dueKm,
    remainingKm,
    mileageKm,
    expiresAt,
    thresholdDays,
    read,
    createdAt,
  ];
}
