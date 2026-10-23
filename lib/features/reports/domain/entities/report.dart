import 'package:equatable/equatable.dart';

import '../../../history/domain/entities/history_entry.dart';
import '../../../history/domain/entities/history_summary.dart';

/// The data of an exported report: every matching record, oldest first, and their totals.
class Report extends Equatable {
  const Report({required this.entries, required this.summary});

  final List<HistoryEntry> entries;
  final HistorySummary summary;

  @override
  List<Object?> get props => [entries, summary];
}
