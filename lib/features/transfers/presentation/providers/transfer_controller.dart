import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import 'transfer_providers.dart';

/// The transfer writes. Each answers the [Failure] (or `null` on success) and refreshes the
/// pending transfers; accepting also refreshes the garage and what is computed from it.
class TransferController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<Failure?> create(String vehicleId, String phone) =>
      _run(() => ref.read(createTransferProvider).call(vehicleId, phone));

  Future<Failure?> cancel(String transferId) =>
      _run(() => ref.read(transferRepositoryProvider).cancelTransfer(transferId));

  Future<Failure?> reject(String transferId) =>
      _run(() => ref.read(transferRepositoryProvider).rejectTransfer(transferId));

  /// The vehicle now in the caller's garage, or the failure.
  Future<Either<Failure, Vehicle>> accept(String transferId) async {
    final repository = ref.read(transferRepositoryProvider);
    state = const AsyncLoading();
    final result = await repository.acceptTransfer(transferId);
    _settle(result);
    if (result.isRight() && ref.mounted) {
      ref.invalidate(vehiclesProvider);
      ref.invalidate(dashboardProvider);
      ref.invalidate(profileStatsProvider);
    }
    return result;
  }

  Future<Failure?> _run<T>(Future<Either<Failure, T>> Function() write) async {
    state = const AsyncLoading();
    final result = await write();
    _settle(result);
    return result.getLeft().toNullable();
  }

  /// Ends the busy state and refreshes the transfers (a 409 may have changed them too).
  void _settle<T>(Either<Failure, T> result) {
    if (!ref.mounted) return;
    ref.invalidate(transfersProvider);
    state = switch (result) {
      Right() => const AsyncData(null),
      Left(value: final failure) => AsyncError(failure, StackTrace.current),
    };
  }
}
