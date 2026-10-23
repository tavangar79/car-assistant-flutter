import '../../../../core/error/failure.dart';

/// 400 `details.phone`: not a valid Iranian mobile number.
class InvalidTransferPhoneFailure extends Failure {
  const InvalidTransferPhoneFailure() : super('Invalid buyer phone');
}

/// 422 `details.phone`: the caller's own phone.
class SelfTransferFailure extends Failure {
  const SelfTransferFailure() : super('Cannot transfer to own phone');
}

/// 409 on create: the vehicle already has a pending transfer.
class TransferAlreadyPendingFailure extends Failure {
  const TransferAlreadyPendingFailure() : super('A transfer is already pending');
}

/// 409 on accept: the vehicle is no longer the seller's, or the buyer already has its plate.
/// [serverMessage] is the backend's (Persian) message, shown as is.
class TransferConflictFailure extends Failure {
  const TransferConflictFailure(this.serverMessage) : super('Transfer conflict: $serverMessage');

  final String serverMessage;

  @override
  List<Object?> get props => [serverMessage];
}
