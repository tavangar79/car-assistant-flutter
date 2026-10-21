import 'package:equatable/equatable.dart';

import 'service_line_item.dart';

/// The fields of a visit to change (`PATCH …/services/:serviceId`). Only the fields that are set
/// are sent; [lineItems] replaces the whole list.
class ServiceVisitUpdate extends Equatable {
  const ServiceVisitUpdate({
    this.serviceDate,
    this.odometerKm,
    this.workshop,
    this.notes,
    this.lineItems,
  });

  final DateTime? serviceDate;
  final int? odometerKm;
  final String? workshop;
  final String? notes;
  final List<ServiceLineItem>? lineItems;

  @override
  List<Object?> get props => [serviceDate, odometerKm, workshop, notes, lineItems];
}
