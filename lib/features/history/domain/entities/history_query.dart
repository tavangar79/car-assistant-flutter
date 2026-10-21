import 'package:equatable/equatable.dart';

import 'history_type.dart';

/// The query of one `GET /api/history` call, with resolved dates.
class HistoryQuery extends Equatable {
  const HistoryQuery({
    this.vehicleIds = const [],
    this.type = HistoryType.all,
    this.categories = const [],
    this.attachmentsOnly = false,
    this.from,
    this.to,
    this.cursor,
    this.limit = defaultLimit,
  });

  static const defaultLimit = 30;

  /// Empty means every vehicle.
  final List<String> vehicleIds;
  final HistoryType type;
  final List<String> categories;
  final bool attachmentsOnly;
  final DateTime? from;
  final DateTime? to;
  final String? cursor;
  final int limit;

  @override
  List<Object?> get props => [
    vehicleIds,
    type,
    categories,
    attachmentsOnly,
    from,
    to,
    cursor,
    limit,
  ];
}
