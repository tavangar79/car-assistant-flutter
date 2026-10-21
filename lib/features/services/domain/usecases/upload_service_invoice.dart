import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/invoice_file.dart';
import '../entities/service_failures.dart';
import '../entities/service_visit.dart';
import '../repositories/service_repository.dart';

/// Attaches an invoice photo to a visit. An empty or oversized file is rejected before upload.
class UploadServiceInvoice {
  const UploadServiceInvoice(this._repository);

  final ServiceRepository _repository;

  Future<Either<Failure, ServiceVisit>> call(
    String vehicleId,
    String serviceId,
    InvoiceFile invoice,
  ) {
    if (invoice.bytes.isEmpty) return Future.value(const Left(InvalidInvoiceFailure()));
    if (invoice.bytes.length > InvoiceFile.maxBytes) {
      return Future.value(const Left(InvoiceTooLargeFailure()));
    }
    return _repository.uploadInvoice(vehicleId, serviceId, invoice);
  }
}
