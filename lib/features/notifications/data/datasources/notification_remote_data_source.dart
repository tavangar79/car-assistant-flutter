import 'package:dio/dio.dart';

import '../models/notification_dto.dart';
import '../models/notification_inbox_dto.dart';

/// HTTP calls for notifications. Throws [DioException] on a non-2xx response.
class NotificationRemoteDataSource {
  const NotificationRemoteDataSource(this._dio);

  final Dio _dio;

  static const _base = '/api/notifications';

  Future<NotificationInboxDto> fetchNotifications() async {
    final response = await _dio.get<Map<String, dynamic>>(_base);
    return NotificationInboxDto.fromJson(response.data!);
  }

  Future<int> fetchUnreadCount() async {
    final response = await _dio.get<Map<String, dynamic>>('$_base/unread-count');
    return (response.data!['unreadCount'] as num).toInt();
  }

  Future<NotificationDto> markRead(String id) async {
    final response = await _dio.patch<Map<String, dynamic>>('$_base/$id/read');
    return NotificationDto.fromJson(response.data!['notification'] as Map<String, dynamic>);
  }

  Future<int> markAllRead() async {
    final response = await _dio.post<Map<String, dynamic>>('$_base/read-all');
    return (response.data!['updatedCount'] as num).toInt();
  }
}
