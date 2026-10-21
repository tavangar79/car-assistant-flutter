import '../../domain/entities/service_line_item.dart';

/// JSON shape of a line item: `{ itemId, brand, cost, notes, nextDueKm, nextDueMonths }`.
/// Absent optionals are `null` on the wire, both ways.
class ServiceLineItemDto {
  const ServiceLineItemDto({
    required this.itemId,
    required this.brand,
    required this.cost,
    required this.notes,
    required this.nextDueKm,
    required this.nextDueMonths,
  });

  factory ServiceLineItemDto.fromJson(Map<String, dynamic> json) => ServiceLineItemDto(
    itemId: json['itemId'] as String,
    brand: json['brand'] as String?,
    cost: json['cost'] as int,
    notes: json['notes'] as String?,
    nextDueKm: json['nextDueKm'] as int?,
    nextDueMonths: json['nextDueMonths'] as int?,
  );

  factory ServiceLineItemDto.fromEntity(ServiceLineItem line) => ServiceLineItemDto(
    itemId: line.itemId,
    brand: line.brand,
    cost: line.cost,
    notes: line.notes,
    nextDueKm: line.nextDueKm,
    nextDueMonths: line.nextDueMonths,
  );

  final String itemId;
  final String? brand;
  final int cost;
  final String? notes;
  final int? nextDueKm;
  final int? nextDueMonths;

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'brand': brand,
    'cost': cost,
    'notes': notes,
    'nextDueKm': nextDueKm,
    'nextDueMonths': nextDueMonths,
  };

  ServiceLineItem toEntity() => ServiceLineItem(
    itemId: itemId,
    brand: brand,
    cost: cost,
    notes: notes,
    nextDueKm: nextDueKm,
    nextDueMonths: nextDueMonths,
  );
}
