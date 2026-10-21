import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_category.dart';
import '../../domain/entities/notification_kind.dart';

/// JSON shape of a notification (the `Notification` object of every response).
class NotificationDto {
  const NotificationDto({
    required this.id,
    required this.kind,
    required this.category,
    required this.vehicleId,
    required this.refId,
    required this.subject,
    required this.dueKm,
    required this.remainingKm,
    required this.mileageKm,
    required this.expiresAt,
    required this.thresholdDays,
    required this.read,
    required this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) => NotificationDto(
    id: json['id'] as String,
    kind: json['kind'] as String,
    category: json['category'] as String,
    vehicleId: json['vehicleId'] as String,
    refId: json['refId'] as String,
    subject: json['subject'] as String,
    dueKm: (json['dueKm'] as num?)?.toInt(),
    remainingKm: (json['remainingKm'] as num?)?.toInt(),
    mileageKm: (json['mileageKm'] as num?)?.toInt(),
    expiresAt: switch (json['expiresAt']) {
      final String date => DateTime.parse(date),
      _ => null,
    },
    thresholdDays: (json['thresholdDays'] as num?)?.toInt(),
    read: json['read'] as bool,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  final String id;
  final String kind;
  final String category;
  final String vehicleId;
  final String refId;
  final String subject;
  final int? dueKm;
  final int? remainingKm;
  final int? mileageKm;
  final DateTime? expiresAt;
  final int? thresholdDays;
  final bool read;
  final DateTime createdAt;

  AppNotification toEntity() => AppNotification(
    id: id,
    kind: NotificationKind.fromWire(kind),
    category: NotificationCategory.fromWire(category),
    vehicleId: vehicleId,
    refId: refId,
    subject: subject,
    dueKm: dueKm,
    remainingKm: remainingKm,
    mileageKm: mileageKm,
    expiresAt: expiresAt,
    thresholdDays: thresholdDays,
    read: read,
    createdAt: createdAt,
  );
}
