import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../entities/create_service_result.dart';
import '../entities/invoice_file.dart';
import '../entities/new_service_visit.dart';
import '../entities/service_failures.dart';
import '../entities/service_rules.dart';
import '../entities/service_visit.dart';
import '../entities/service_visit_draft.dart';
import '../repositories/service_repository.dart';

/// Records a visit for [Vehicle], then uploads its optional invoice.
///
/// The draft and the invoice are checked before anything is sent. When the visit is saved but the
/// invoice upload fails, the result is still a success, with `invoiceFailure` set.
class CreateServiceVisit {
  const CreateServiceVisit(this._repository, {required this.now});

  final ServiceRepository _repository;

  /// The current time; a visit after it is rejected.
  final DateTime Function() now;

  Future<Either<Failure, CreateServiceResult>> call(
    Vehicle vehicle,
    ServiceVisitDraft draft, {
    InvoiceFile? invoice,
  }) async {
    if (invoice != null && invoice.bytes.isEmpty) return const Left(InvalidInvoiceFailure());
    if (invoice != null && invoice.bytes.length > InvoiceFile.maxBytes) {
      return const Left(InvoiceTooLargeFailure());
    }
    final NewServiceVisit visit;
    switch (ServiceRules.validate(draft, currentKm: vehicle.mileageKm, now: now())) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final checked):
        visit = checked;
    }

    final ServiceVisit saved;
    switch (await _repository.createVisit(vehicle.id, visit)) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final created):
        saved = created;
    }
    if (invoice == null) return Right(CreateServiceResult(saved));

    // The visit is saved either way; a failed upload only loses the invoice.
    final uploaded = await _repository.uploadInvoice(vehicle.id, saved.id, invoice);
    return Right(
      uploaded.match(
        (failure) => CreateServiceResult(saved, invoiceFailure: failure),
        CreateServiceResult.new,
      ),
    );
  }
}
