import '../../domain/entities/new_service_visit.dart';
import 'service_line_item_dto.dart';

/// Body of `POST /api/vehicles/:id/services`: dates in ISO-8601 UTC, `null` for absent optionals.
class CreateServiceRequestDto {
  const CreateServiceRequestDto(this.visit);

  final NewServiceVisit visit;

  Map<String, dynamic> toJson() => {
    'serviceDate': visit.serviceDate.toUtc().toIso8601String(),
    'odometerKm': visit.odometerKm,
    'workshop': visit.workshop,
    'notes': visit.notes,
    'lineItems': [for (final line in visit.lineItems) ServiceLineItemDto.fromEntity(line).toJson()],
  };
}
