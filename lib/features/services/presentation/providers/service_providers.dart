import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../data/datasources/service_remote_data_source.dart';
import '../../data/repositories/service_repository_impl.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_suggestions.dart';
import '../../domain/entities/service_visit.dart';
import '../../domain/repositories/service_repository.dart';
import '../../domain/usecases/create_service_visit.dart';
import '../../domain/usecases/delete_service_visit.dart';
import '../../domain/usecases/get_service_catalog.dart';
import '../../domain/usecases/get_service_invoice.dart';
import '../../domain/usecases/get_service_suggestions.dart';
import '../../domain/usecases/get_service_visit.dart';
import '../../domain/usecases/get_service_visits.dart';
import '../../domain/usecases/update_service_line_items.dart';
import '../../domain/usecases/upload_service_invoice.dart';
import 'invoice_picker.dart';
import 'new_service_controller.dart';
import 'service_details_controller.dart';
import 'service_wizard.dart';

// Dependency wiring for the services feature. Override [serviceRepositoryProvider] in tests.

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepositoryImpl(ServiceRemoteDataSource(ref.watch(dioProvider)));
});

final getServiceCatalogProvider = Provider<GetServiceCatalog>((ref) {
  return GetServiceCatalog(ref.watch(serviceRepositoryProvider));
});

final getServiceSuggestionsProvider = Provider<GetServiceSuggestions>((ref) {
  return GetServiceSuggestions(ref.watch(serviceRepositoryProvider));
});

final getServiceVisitsProvider = Provider<GetServiceVisits>((ref) {
  return GetServiceVisits(ref.watch(serviceRepositoryProvider));
});

final getServiceVisitProvider = Provider<GetServiceVisit>((ref) {
  return GetServiceVisit(ref.watch(serviceRepositoryProvider));
});

final createServiceVisitProvider = Provider<CreateServiceVisit>((ref) {
  return CreateServiceVisit(ref.watch(serviceRepositoryProvider), now: ref.watch(clockProvider));
});

final updateServiceLineItemsProvider = Provider<UpdateServiceLineItems>((ref) {
  return UpdateServiceLineItems(ref.watch(serviceRepositoryProvider));
});

final deleteServiceVisitProvider = Provider<DeleteServiceVisit>((ref) {
  return DeleteServiceVisit(ref.watch(serviceRepositoryProvider));
});

final uploadServiceInvoiceProvider = Provider<UploadServiceInvoice>((ref) {
  return UploadServiceInvoice(ref.watch(serviceRepositoryProvider));
});

final getServiceInvoiceProvider = Provider<GetServiceInvoice>((ref) {
  return GetServiceInvoice(ref.watch(serviceRepositoryProvider));
});

final invoicePickerProvider = Provider<InvoicePicker>((ref) => const InvoicePicker());

/// The static service catalog, in screen order.
final serviceCatalogProvider = FutureProvider.autoDispose<List<ServiceCategory>>((ref) async {
  final catalog = await ref.watch(getServiceCatalogProvider).call();
  return catalog.getOrElse((failure) => throw failure);
});

/// The workshops and brands of earlier visits, for the autocomplete fields. Invalidated after
/// a visit is created or changed.
final serviceSuggestionsProvider = FutureProvider.autoDispose<ServiceSuggestions>((ref) async {
  final suggestions = await ref.watch(getServiceSuggestionsProvider).call();
  return suggestions.getOrElse((failure) => throw failure);
});

/// The visits of a vehicle, newest first.
final serviceVisitsProvider = FutureProvider.autoDispose.family<List<ServiceVisit>, String>((
  ref,
  vehicleId,
) async {
  final visits = await ref.watch(getServiceVisitsProvider).call(vehicleId);
  return visits.getOrElse((failure) => throw failure);
});

/// Identifies one visit of one vehicle (the argument of [serviceVisitProvider]).
class ServiceRef extends Equatable {
  const ServiceRef(this.vehicleId, this.serviceId);

  final String vehicleId;
  final String serviceId;

  @override
  List<Object?> get props => [vehicleId, serviceId];
}

/// One visit, for the details page.
final serviceVisitProvider = FutureProvider.autoDispose.family<ServiceVisit, ServiceRef>((
  ref,
  visit,
) async {
  final result = await ref.watch(getServiceVisitProvider).call(visit.vehicleId, visit.serviceId);
  return result.getOrElse((failure) => throw failure);
});

/// The invoice bytes for a `ServiceVisit.invoiceUrl` (each upload gets a new URL).
final serviceInvoiceBytesProvider = FutureProvider.autoDispose.family<Uint8List, String>((
  ref,
  url,
) async {
  final bytes = await ref.watch(getServiceInvoiceProvider).call(url);
  return bytes.getOrElse((failure) => throw failure);
});

/// The draft of the wizard, one per (vehicle, preselection).
final serviceWizardProvider = NotifierProvider.autoDispose
    .family<ServiceWizard, ServiceWizardState, ServiceWizardArgs>(ServiceWizard.new);

/// State of the wizard's submit: loading while saving, and the last error.
final newServiceControllerProvider = AsyncNotifierProvider.autoDispose<NewServiceController, void>(
  NewServiceController.new,
);

/// State of the details page writes: loading while saving, and the last error.
final serviceDetailsControllerProvider =
    AsyncNotifierProvider.autoDispose<ServiceDetailsController, void>(ServiceDetailsController.new);
