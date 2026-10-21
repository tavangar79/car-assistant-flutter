import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/notification_repository.dart';

/// How many notifications are unread.
class GetUnreadNotificationCount {
  const GetUnreadNotificationCount(this._repository);

  final NotificationRepository _repository;

  Future<Either<Failure, int>> call() => _repository.getUnreadCount();
}
