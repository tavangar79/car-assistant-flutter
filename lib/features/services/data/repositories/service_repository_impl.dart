import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/network/api_error_dto.dart';
import '../../domain/entities/invoice_file.dart';
import '../../domain/entities/new_service_visit.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_failures.dart';
import '../../domain/entities/service_field.dart';
import '../../domain/entities/service_suggestions.dart';
import '../../domain/entities/service_visit.dart';
import '../../domain/entities/service_visit_update.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_remote_data_source.dart';
import '../models/create_service_request_dto.dart';
import '../models/update_service_request_dto.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  const ServiceRepositoryImpl(this._remote);

  final ServiceRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<ServiceCategory>>> getCatalog({String? vehicleId}) =>
      apiCall(() async => (await _remote.fetchCatalog(vehicleId: vehicleId)).toEntity());

  @override
  Future<Either<Failure, ServiceSuggestions>> getSuggestions() =>
      apiCall(() async => (await _remote.fetchSuggestions()).toEntity());

  @override
  Future<Either<Failure, List<ServiceVisit>>> getVisits(String vehicleId) => apiCall(
    () async => (await _remote.fetchVisits(vehicleId)).map((dto) => dto.toEntity()).toList(),
  );

  @override
  Future<Either<Failure, ServiceVisit>> getVisit(String vehicleId, String serviceId) =>
      apiCall(() async => (await _remote.fetchVisit(vehicleId, serviceId)).toEntity());

  @override
  Future<Either<Failure, ServiceVisit>> createVisit(String vehicleId, NewServiceVisit visit) =>
      apiCall(
        () async =>
            (await _remote.createVisit(vehicleId, CreateServiceRequestDto(visit))).toEntity(),
        onStatus: _visitFailure,
      );

  @override
  Future<Either<Failure, ServiceVisit>> updateVisit(
    String vehicleId,
    String serviceId,
    ServiceVisitUpdate update,
  ) => apiCall(
    () async => (await _remote.updateVisit(
      vehicleId,
      serviceId,
      UpdateServiceRequestDto(update),
    )).toEntity(),
    onStatus: _visitFailure,
  );

  /// The failure of a rejected create or update.
  static Failure? _visitFailure(int status, ApiErrorDto? error) => switch (status) {
    400 => InvalidServiceFailure(
      fieldsOf(error?.details.keys ?? const []),
      error?.message ?? 'Invalid service visit',
    ),
    422 => ServiceRejectedFailure(error?.message ?? 'Service visit rejected'),
    _ => null,
  };

  @override
  Future<Either<Failure, Unit>> deleteVisit(String vehicleId, String serviceId) =>
      apiCall(() async {
        await _remote.deleteVisit(vehicleId, serviceId);
        return unit;
      });

  @override
  Future<Either<Failure, ServiceVisit>> uploadInvoice(
    String vehicleId,
    String serviceId,
    InvoiceFile invoice,
  ) => apiCall(
    () async => (await _remote.uploadInvoice(vehicleId, serviceId, invoice)).toEntity(),
    onStatus: (status, error) => switch (status) {
      400 => InvalidInvoiceFailure(error?.message ?? 'Invalid invoice image'),
      413 => InvoiceTooLargeFailure(error?.message ?? 'Invoice image too large'),
      _ => null,
    },
  );

  @override
  Future<Either<Failure, ServiceVisit>> deleteInvoice(String vehicleId, String serviceId) =>
      apiCall(() async => (await _remote.deleteInvoice(vehicleId, serviceId)).toEntity());

  @override
  Future<Either<Failure, Uint8List>> fetchInvoice(String invoiceUrl) =>
      apiCall(() => _remote.fetchInvoice(invoiceUrl));

  /// Maps the dotted field paths of a 400 `details` body (`workshop`, `lineItems.0.cost`, …) to
  /// form fields. Unknown paths are ignored.
  static Set<ServiceField> fieldsOf(Iterable<String> paths) => {
    for (final path in paths) ?_fieldOf(path.split('.').first),
  };

  static ServiceField? _fieldOf(String key) => switch (key) {
    'serviceDate' => ServiceField.serviceDate,
    'odometerKm' => ServiceField.odometerKm,
    'workshop' => ServiceField.workshop,
    'notes' => ServiceField.notes,
    'lineItems' => ServiceField.lineItems,
    _ => null,
  };
}
