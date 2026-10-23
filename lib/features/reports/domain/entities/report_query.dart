import 'package:equatable/equatable.dart';

import '../../../history/domain/entities/history_type.dart';

/// The filter of `GET /api/reports`. Empty [vehicleIds] means every vehicle of the caller.
class ReportQuery extends Equatable {
  const ReportQuery({
    this.vehicleIds = const [],
    this.types = const [HistoryType.service, HistoryType.fuel, HistoryType.expense],
    this.from,
    this.to,
  });

  final List<String> vehicleIds;

  /// A non-empty subset of service, fuel and expense ([HistoryType.all] is never sent).
  final List<HistoryType> types;

  /// Inclusive bounds on the record date; `null` means unbounded.
  final DateTime? from;
  final DateTime? to;

  @override
  List<Object?> get props => [vehicleIds, types, from, to];
}
