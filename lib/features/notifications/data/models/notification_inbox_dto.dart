import '../../domain/entities/notification_inbox.dart';
import 'notification_dto.dart';

/// `GET /api/notifications` → `{ "notifications": [Notification], "unreadCount": 2 }`.
class NotificationInboxDto {
  const NotificationInboxDto({required this.notifications, required this.unreadCount});

  factory NotificationInboxDto.fromJson(Map<String, dynamic> json) => NotificationInboxDto(
    notifications: (json['notifications'] as List<dynamic>)
        .map((item) => NotificationDto.fromJson(item as Map<String, dynamic>))
        .toList(),
    unreadCount: (json['unreadCount'] as num).toInt(),
  );

  final List<NotificationDto> notifications;
  final int unreadCount;

  NotificationInbox toEntity() => NotificationInbox(
    notifications: notifications.map((dto) => dto.toEntity()).toList(),
    unreadCount: unreadCount,
  );
}
