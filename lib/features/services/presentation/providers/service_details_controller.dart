import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/invoice_file.dart';
import '../../domain/entities/service_line_item.dart';
import 'service_providers.dart';

/// Writes of the service details page: items, invoice and the visit itself. The state carries
/// loading and the last error. After every write the visit, the vehicle's visits and the vehicle
/// (its mileage may change) are refreshed.
class ServiceDetailsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> saveLineItems(ServiceRef ref_, List<ServiceLineItem> lineItems) => _run(
    () => ref.read(updateServiceLineItemsProvider).call(ref_.vehicleId, ref_.serviceId, lineItems),
    ref_,
  );

  Future<bool> uploadInvoice(ServiceRef ref_, InvoiceFile invoice) => _run(
    () => ref.read(uploadServiceInvoiceProvider).call(ref_.vehicleId, ref_.serviceId, invoice),
    ref_,
  );

  Future<bool> deleteVisit(ServiceRef ref_) =>
      _run(() => ref.read(deleteServiceVisitProvider).call(ref_.vehicleId, ref_.serviceId), ref_);

  Future<bool> _run<T>(Future<Either<Failure, T>> Function() write, ServiceRef visit) async {
    state = const AsyncLoading();
    final result = await write();
    if (!ref.mounted) return false;
    switch (result) {
      case Right():
        ref.invalidate(serviceVisitProvider(visit));
        ref.invalidate(serviceVisitsProvider(visit.vehicleId));
        ref.invalidate(serviceSuggestionsProvider);
        ref.invalidate(vehicleProvider(visit.vehicleId));
        ref.invalidate(vehiclesProvider);
        ref.invalidate(odometerReadingsProvider(visit.vehicleId));
        state = const AsyncData(null);
        return true;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return false;
    }
  }
}
