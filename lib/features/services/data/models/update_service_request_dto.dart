import '../../domain/entities/service_visit_update.dart';
import 'service_line_item_dto.dart';

/// Body of `PATCH …/services/:serviceId`: only the fields that are set.
class UpdateServiceRequestDto {
  const UpdateServiceRequestDto(this.update);

  final ServiceVisitUpdate update;

  Map<String, dynamic> toJson() => {
    'serviceDate': ?update.serviceDate?.toUtc().toIso8601String(),
    'odometerKm': ?update.odometerKm,
    'workshop': ?update.workshop,
    'notes': ?update.notes,
    'lineItems': ?update.lineItems
        ?.map((line) => ServiceLineItemDto.fromEntity(line).toJson())
        .toList(),
  };
}
