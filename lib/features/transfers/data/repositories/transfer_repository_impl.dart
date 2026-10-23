import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/entities/transfer_failures.dart';
import '../../domain/entities/vehicle_transfer.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../datasources/transfer_remote_data_source.dart';

class TransferRepositoryImpl implements TransferRepository {
  const TransferRepositoryImpl(this._remote);

  final TransferRemoteDataSource _remote;

  @override
  Future<Either<Failure, VehicleTransfer>> createTransfer(String vehicleId, String phone) =>
      apiCall(
        () async => (await _remote.createTransfer(vehicleId, phone)).toEntity(),
        onStatus: (status, _) => switch (status) {
          400 => const InvalidTransferPhoneFailure(),
          422 => const SelfTransferFailure(),
          409 => const TransferAlreadyPendingFailure(),
          _ => null,
        },
      );

  @override
  Future<Either<Failure, TransferList>> getTransfers() => apiCall(() async {
    final (incoming, outgoing) = await _remote.fetchTransfers();
    return TransferList(
      incoming: incoming.map((dto) => dto.toEntity()).toList(),
      outgoing: outgoing.map((dto) => dto.toEntity()).toList(),
    );
  });

  @override
  Future<Either<Failure, Unit>> cancelTransfer(String transferId) =>
      apiCall(() async => _remote.cancelTransfer(transferId).then((_) => unit));

  @override
  Future<Either<Failure, Unit>> rejectTransfer(String transferId) =>
      apiCall(() async => _remote.rejectTransfer(transferId).then((_) => unit));

  @override
  Future<Either<Failure, Vehicle>> acceptTransfer(String transferId) => apiCall(
    () async => (await _remote.acceptTransfer(transferId)).toEntity(),
    onStatus: (status, error) => switch ((status, error)) {
      (409, final error?) => TransferConflictFailure(error.message),
      _ => null,
    },
  );
}
