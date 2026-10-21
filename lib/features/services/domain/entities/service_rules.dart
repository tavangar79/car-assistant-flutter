import 'package:fpdart/fpdart.dart';

import '../../../vehicles/domain/entities/vehicle_rules.dart';
import 'new_service_visit.dart';
import 'service_failures.dart';
import 'service_field.dart';
import 'service_line_item.dart';
import 'service_visit_draft.dart';

/// The backend's service-visit rules, checked before sending so the user gets instant feedback.
abstract final class ServiceRules {
  static const workshopMaxLength = 100;
  static const notesMaxLength = 1000;
  static const brandMaxLength = 100;
  static const lineNotesMaxLength = 500;
  static const maxLineItems = 30;
  static const minNextDueKm = 100;
  static const maxNextDueKm = 200000;
  static const minNextDueMonths = 1;
  static const maxNextDueMonths = 120;
  static const maxMileageKm = VehicleRules.maxMileageKm;

  static bool isValidNextDueKm(int? km) => km == null || (km >= minNextDueKm && km <= maxNextDueKm);

  static bool isValidNextDueMonths(int? months) =>
      months == null || (months >= minNextDueMonths && months <= maxNextDueMonths);

  /// Checks [draft] for a vehicle currently at [currentKm]; on success returns the visit to send.
  /// A date after [now] is rejected (`serviceDate`).
  static Either<InvalidServiceFailure, NewServiceVisit> validate(
    ServiceVisitDraft draft, {
    required int currentKm,
    required DateTime now,
  }) {
    final workshop = draft.workshop.trim();
    final odometerKm = draft.odometerKm ?? currentKm;
    final serviceDate = draft.serviceDate(now);
    final lineItems = [
      for (final itemId in draft.itemIds) _lineItem(itemId, draft, currentKm: currentKm),
    ];
    final invalid = {
      if (serviceDate.isAfter(now)) ServiceField.serviceDate,
      if (odometerKm < 0 || odometerKm > maxMileageKm) ServiceField.odometerKm,
      if (workshop.isEmpty || workshop.length > workshopMaxLength) ServiceField.workshop,
      if (lineItems.isEmpty || lineItems.length > maxLineItems || !lineItems.every(isValidLine))
        ServiceField.lineItems,
    };
    if (invalid.isNotEmpty) return Left(InvalidServiceFailure(invalid));
    return Right(
      NewServiceVisit(
        serviceDate: serviceDate,
        odometerKm: odometerKm,
        workshop: workshop,
        lineItems: lineItems,
      ),
    );
  }

  static bool isValidLine(ServiceLineItem line) =>
      line.cost >= 0 &&
      (line.brand?.length ?? 0) <= brandMaxLength &&
      (line.notes?.length ?? 0) <= lineNotesMaxLength &&
      isValidNextDueKm(line.nextDueKm) &&
      isValidNextDueMonths(line.nextDueMonths);

  static ServiceLineItem _lineItem(
    String itemId,
    ServiceVisitDraft draft, {
    required int currentKm,
  }) {
    final line = draft.lineOf(itemId, currentKm: currentKm);
    final brand = line.brand.trim();
    final notes = line.notes.trim();
    return ServiceLineItem(
      itemId: itemId,
      brand: brand.isEmpty ? null : brand,
      cost: line.cost ?? 0,
      notes: notes.isEmpty ? null : notes,
      nextDueKm: line.nextDueKm,
      nextDueMonths: line.nextDueMonths,
    );
  }
}
