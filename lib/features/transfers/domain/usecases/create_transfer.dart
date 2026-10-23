import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/entities/phone_number.dart';
import '../entities/transfer_failures.dart';
import '../entities/vehicle_transfer.dart';
import '../repositories/transfer_repository.dart';

/// Sends a transfer request to the buyer's phone, normalized to `09xxxxxxxxx`. An invalid phone
/// fails without a request.
class CreateTransfer {
  const CreateTransfer(this._repository);

  final TransferRepository _repository;

  Future<Either<Failure, VehicleTransfer>> call(String vehicleId, String phone) async {
    final normalized = PhoneNumber.normalize(phone);
    if (normalized == null) return const Left(InvalidTransferPhoneFailure());
    return _repository.createTransfer(vehicleId, normalized);
  }
}
