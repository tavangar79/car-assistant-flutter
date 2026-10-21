import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/notification_inbox.dart';
import '../repositories/notification_repository.dart';

/// The notification inbox, newest first.
class GetNotifications {
  const GetNotifications(this._repository);

  final NotificationRepository _repository;

  Future<Either<Failure, NotificationInbox>> call() => _repository.getNotifications();
}
