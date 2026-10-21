import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/notification_repository.dart';

/// Marks every notification read; returns how many changed.
class MarkAllNotificationsRead {
  const MarkAllNotificationsRead(this._repository);

  final NotificationRepository _repository;

  Future<Either<Failure, int>> call() => _repository.markAllRead();
}
