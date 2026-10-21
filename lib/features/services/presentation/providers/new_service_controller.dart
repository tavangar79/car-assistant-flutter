import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/create_service_result.dart';
import '../../domain/entities/invoice_file.dart';
import '../../domain/entities/service_visit_draft.dart';
import 'service_providers.dart';

/// Saves the visit of the wizard. The state carries loading and the last error (an
/// `InvalidServiceFailure`, `ServiceRejectedFailure`, invoice failure or any other `Failure`).
class NewServiceController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Records [draft] for [vehicle] with its optional [invoice]. Returns the result once the visit
  /// is saved (its `invoiceFailure` says whether the invoice was not), or `null` when nothing was
  /// saved. On success the vehicle (its mileage may rise) and its visits are refreshed.
  Future<CreateServiceResult?> submit(
    Vehicle vehicle,
    ServiceVisitDraft draft, {
    InvoiceFile? invoice,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(createServiceVisitProvider)
        .call(vehicle, draft, invoice: invoice);
    if (!ref.mounted) return null;
    switch (result) {
      case Right(value: final saved):
        ref.invalidate(serviceVisitsProvider(vehicle.id));
        ref.invalidate(serviceSuggestionsProvider);
        ref.invalidate(vehicleProvider(vehicle.id));
        ref.invalidate(vehiclesProvider);
        ref.invalidate(odometerReadingsProvider(vehicle.id));
        state = const AsyncData(null);
        return saved;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return null;
    }
  }

  /// Forgets the last error, e.g. once the user edits a field.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
