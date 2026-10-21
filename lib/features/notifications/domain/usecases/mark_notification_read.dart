import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

/// Marks one notification read.
class MarkNotificationRead {
  const MarkNotificationRead(this._repository);

  final NotificationRepository _repository;

  Future<Either<Failure, AppNotification>> call(String id) => _repository.markRead(id);
}
