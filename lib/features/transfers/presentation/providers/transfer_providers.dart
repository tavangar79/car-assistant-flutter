import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/transfer_remote_data_source.dart';
import '../../data/repositories/transfer_repository_impl.dart';
import '../../domain/entities/vehicle_transfer.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../../domain/usecases/create_transfer.dart';
import 'transfer_controller.dart';

// Dependency wiring for ownership transfers. Override [transferRepositoryProvider] in tests.

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepositoryImpl(TransferRemoteDataSource(ref.watch(dioProvider)));
});

final createTransferProvider = Provider<CreateTransfer>((ref) {
  return CreateTransfer(ref.watch(transferRepositoryProvider));
});

/// The caller's pending incoming and outgoing transfers.
final transfersProvider = FutureProvider.autoDispose<TransferList>((ref) async {
  final result = await ref.watch(transferRepositoryProvider).getTransfers();
  return result.getOrElse((failure) => throw failure);
});

/// Sends, cancels, accepts and rejects transfers. Kept alive, so a write started from a sheet
/// that closes still refreshes what it changed.
final transferControllerProvider = AsyncNotifierProvider<TransferController, void>(
  TransferController.new,
);
