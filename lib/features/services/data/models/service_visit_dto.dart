import '../../domain/entities/service_invoice.dart';
import '../../domain/entities/service_visit.dart';
import 'service_line_item_dto.dart';

/// JSON shape of a service visit (the `Service` object of every response).
class ServiceVisitDto {
  const ServiceVisitDto({
    required this.id,
    required this.vehicleId,
    required this.serviceDate,
    required this.odometerKm,
    required this.workshop,
    required this.notes,
    required this.lineItems,
    required this.totalCost,
    required this.invoice,
    required this.invoiceUrl,
    required this.createdAt,
    required this.updatedAt,
    this.locked = false,
  });

  factory ServiceVisitDto.fromJson(Map<String, dynamic> json) => ServiceVisitDto(
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    serviceDate: DateTime.parse(json['serviceDate'] as String),
    odometerKm: json['odometerKm'] as int,
    workshop: json['workshop'] as String,
    notes: json['notes'] as String?,
    lineItems: (json['lineItems'] as List<dynamic>)
        .map((line) => ServiceLineItemDto.fromJson(line as Map<String, dynamic>))
        .toList(),
    totalCost: json['totalCost'] as int,
    invoice: switch (json['invoice']) {
      final Map<String, dynamic> invoice => ServiceInvoiceDto.fromJson(invoice),
      _ => null,
    },
    invoiceUrl: json['invoiceUrl'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    // Phase 6; absent from older servers.
    locked: json['locked'] as bool? ?? false,
  );

  final String id;
  final String vehicleId;
  final DateTime serviceDate;
  final int odometerKm;
  final String workshop;
  final String? notes;
  final List<ServiceLineItemDto> lineItems;
  final int totalCost;
  final ServiceInvoiceDto? invoice;
  final String? invoiceUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool locked;

  ServiceVisit toEntity() => ServiceVisit(
    id: id,
    vehicleId: vehicleId,
    serviceDate: serviceDate,
    odometerKm: odometerKm,
    workshop: workshop,
    notes: notes,
    lineItems: lineItems.map((dto) => dto.toEntity()).toList(),
    totalCost: totalCost,
    invoice: invoice?.toEntity(),
    invoiceUrl: invoiceUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
    locked: locked,
  );
}

/// `{ fileName, contentType, sizeBytes, updatedAt }`.
class ServiceInvoiceDto {
  const ServiceInvoiceDto({
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.updatedAt,
  });

  factory ServiceInvoiceDto.fromJson(Map<String, dynamic> json) => ServiceInvoiceDto(
    fileName: json['fileName'] as String,
    contentType: json['contentType'] as String,
    sizeBytes: json['sizeBytes'] as int,
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  final String fileName;
  final String contentType;
  final int sizeBytes;
  final DateTime updatedAt;

  ServiceInvoice toEntity() => ServiceInvoice(
    fileName: fileName,
    contentType: contentType,
    sizeBytes: sizeBytes,
    updatedAt: updatedAt,
  );
}
