import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/service_failures.dart';
import '../entities/service_field.dart';
import '../entities/service_line_item.dart';
import '../entities/service_rules.dart';
import '../entities/service_visit.dart';
import '../entities/service_visit_update.dart';
import '../repositories/service_repository.dart';

/// Replaces the items of a visit (edit, add or remove one). A visit keeps at least one item and
/// every item id is unique; otherwise `InvalidServiceFailure` before anything is sent.
class UpdateServiceLineItems {
  const UpdateServiceLineItems(this._repository);

  final ServiceRepository _repository;

  Future<Either<Failure, ServiceVisit>> call(
    String vehicleId,
    String serviceId,
    List<ServiceLineItem> lineItems,
  ) {
    final ids = lineItems.map((line) => line.itemId).toSet();
    if (lineItems.isEmpty ||
        lineItems.length > ServiceRules.maxLineItems ||
        ids.length != lineItems.length ||
        !lineItems.every(ServiceRules.isValidLine)) {
      return Future.value(const Left(InvalidServiceFailure({ServiceField.lineItems})));
    }
    return _repository.updateVisit(vehicleId, serviceId, ServiceVisitUpdate(lineItems: lineItems));
  }
}
