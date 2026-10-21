import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/invoice_file.dart';
import '../entities/new_service_visit.dart';
import '../entities/service_category.dart';
import '../entities/service_suggestions.dart';
import '../entities/service_visit.dart';
import '../entities/service_visit_update.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class ServiceRepository {
  /// The static service catalog, in screen order.
  Future<Either<Failure, List<ServiceCategory>>> getCatalog();

  /// The workshops and brands of the caller's earlier visits, most recent first.
  Future<Either<Failure, ServiceSuggestions>> getSuggestions();

  /// The visits of vehicle [vehicleId], newest first (at most 50).
  Future<Either<Failure, List<ServiceVisit>>> getVisits(String vehicleId);

  Future<Either<Failure, ServiceVisit>> getVisit(String vehicleId, String serviceId);

  /// `InvalidServiceFailure` on 400, `ServiceRejectedFailure` on 422.
  Future<Either<Failure, ServiceVisit>> createVisit(String vehicleId, NewServiceVisit visit);

  /// `InvalidServiceFailure` on 400, `ServiceRejectedFailure` on 422.
  Future<Either<Failure, ServiceVisit>> updateVisit(
    String vehicleId,
    String serviceId,
    ServiceVisitUpdate update,
  );

  Future<Either<Failure, Unit>> deleteVisit(String vehicleId, String serviceId);

  /// Attaches (or replaces) the invoice photo; returns the visit with it.
  /// `InvalidInvoiceFailure` on 400, `InvoiceTooLargeFailure` on 413.
  Future<Either<Failure, ServiceVisit>> uploadInvoice(
    String vehicleId,
    String serviceId,
    InvoiceFile invoice,
  );

  /// Removes the invoice photo; returns the visit without it.
  Future<Either<Failure, ServiceVisit>> deleteInvoice(String vehicleId, String serviceId);

  /// The bytes of the invoice at [invoiceUrl] (`ServiceVisit.invoiceUrl`).
  Future<Either<Failure, Uint8List>> fetchInvoice(String invoiceUrl);
}
