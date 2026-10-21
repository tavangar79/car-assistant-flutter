import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_inbox.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._remote);

  final NotificationRemoteDataSource _remote;

  @override
  Future<Either<Failure, NotificationInbox>> getNotifications() =>
      apiCall(() async => (await _remote.fetchNotifications()).toEntity());

  @override
  Future<Either<Failure, int>> getUnreadCount() => apiCall(_remote.fetchUnreadCount);

  @override
  Future<Either<Failure, AppNotification>> markRead(String id) =>
      apiCall(() async => (await _remote.markRead(id)).toEntity());

  @override
  Future<Either<Failure, int>> markAllRead() => apiCall(_remote.markAllRead);
}
