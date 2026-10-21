import 'package:equatable/equatable.dart';

import '../../../expenses/domain/entities/expense.dart';
import '../../../fuel/domain/entities/fuel_log.dart';
import '../../../services/domain/entities/service_visit.dart';
import 'history_type.dart';

/// One record of the history: a service visit, a fill-up or an expense. Exactly the payload of
/// [type] is set.
class HistoryEntry extends Equatable {
  const HistoryEntry({
    required this.type,
    required this.id,
    required this.vehicleId,
    required this.occurredAt,
    required this.cost,
    required this.hasAttachment,
    this.service,
    this.fuelLog,
    this.expense,
  });

  final HistoryType type;
  final String id;
  final String vehicleId;

  /// `serviceDate`, `fueledAt` or `paidAt`.
  final DateTime occurredAt;

  /// Toman.
  final int cost;
  final bool hasAttachment;
  final ServiceVisit? service;
  final FuelLog? fuelLog;
  final Expense? expense;

  @override
  List<Object?> get props => [
    type,
    id,
    vehicleId,
    occurredAt,
    cost,
    hasAttachment,
    service,
    fuelLog,
    expense,
  ];
}
