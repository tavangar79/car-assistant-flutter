import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../entities/vehicle_transfer.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class TransferRepository {
  /// Asks the owner of [phone] (`09xxxxxxxxx`) to take [vehicleId].
  Future<Either<Failure, VehicleTransfer>> createTransfer(String vehicleId, String phone);

  /// The caller's pending incoming and outgoing transfers.
  Future<Either<Failure, TransferList>> getTransfers();

  /// The seller withdraws a pending transfer.
  Future<Either<Failure, Unit>> cancelTransfer(String transferId);

  /// The buyer declines a pending transfer.
  Future<Either<Failure, Unit>> rejectTransfer(String transferId);

  /// The buyer takes the vehicle; answers it as it now is in their garage.
  Future<Either<Failure, Vehicle>> acceptTransfer(String transferId);
}
