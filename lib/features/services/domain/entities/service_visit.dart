import 'package:equatable/equatable.dart';

import 'service_invoice.dart';
import 'service_line_item.dart';

/// One visit to a workshop: when, at what mileage, where, and the items done. [totalCost] is the
/// sum of the items' costs, computed by the server.
class ServiceVisit extends Equatable {
  const ServiceVisit({
    required this.id,
    required this.vehicleId,
    required this.serviceDate,
    required this.odometerKm,
    required this.workshop,
    required this.lineItems,
    required this.totalCost,
    required this.createdAt,
    required this.updatedAt,
    this.locked = false,
    this.notes,
    this.invoice,
    this.invoiceUrl,
  });

  final String id;
  final String vehicleId;
  final DateTime serviceDate;
  final int odometerKm;
  final String workshop;
  final String? notes;
  final List<ServiceLineItem> lineItems;
  final int totalCost;

  /// The attached invoice photo, or `null` when there is none.
  final ServiceInvoice? invoice;

  /// Relative path of the invoice photo (loading it needs the bearer token), or `null`.
  final String? invoiceUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Created before the current owner got the vehicle (ownership transfer): read-only.
  final bool locked;

  bool get hasInvoice => invoice != null;

  @override
  List<Object?> get props => [
    id,
    vehicleId,
    serviceDate,
    odometerKm,
    workshop,
    notes,
    lineItems,
    totalCost,
    invoice,
    invoiceUrl,
    createdAt,
    updatedAt,
    locked,
  ];
}
