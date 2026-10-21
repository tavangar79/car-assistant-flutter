import 'package:equatable/equatable.dart';

import 'service_line_item.dart';

/// A checked visit, ready to send (`POST /api/vehicles/:id/services`).
class NewServiceVisit extends Equatable {
  const NewServiceVisit({
    required this.serviceDate,
    required this.odometerKm,
    required this.workshop,
    required this.lineItems,
    this.notes,
  });

  final DateTime serviceDate;
  final int odometerKm;
  final String workshop;
  final String? notes;
  final List<ServiceLineItem> lineItems;

  @override
  List<Object?> get props => [serviceDate, odometerKm, workshop, notes, lineItems];
}
