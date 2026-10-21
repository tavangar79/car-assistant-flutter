import 'package:equatable/equatable.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'history_entry.dart';

/// The loaded entries of one Jalali month, newest first, with their cost total.
class HistoryMonthGroup extends Equatable {
  const HistoryMonthGroup({required this.year, required this.month, required this.entries});

  final int year;
  final int month;
  final List<HistoryEntry> entries;

  /// Toman.
  int get totalCost => entries.fold(0, (sum, entry) => sum + entry.cost);

  @override
  List<Object?> get props => [year, month, entries];
}

/// Groups [entries] (newest first) by the Jalali month of their local `occurredAt`, keeping order.
List<HistoryMonthGroup> groupByJalaliMonth(List<HistoryEntry> entries) {
  final groups = <HistoryMonthGroup>[];
  for (final entry in entries) {
    final date = Jalali.fromDateTime(entry.occurredAt.toLocal());
    final last = groups.lastOrNull;
    if (last != null && last.year == date.year && last.month == date.month) {
      last.entries.add(entry);
    } else {
      groups.add(HistoryMonthGroup(year: date.year, month: date.month, entries: [entry]));
    }
  }
  return groups;
}
