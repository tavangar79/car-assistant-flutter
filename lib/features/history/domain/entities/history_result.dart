import 'package:equatable/equatable.dart';

import 'history_entry.dart';
import 'history_summary.dart';

/// One page of the history, newest first.
class HistoryResult extends Equatable {
  const HistoryResult({required this.entries, this.nextCursor, this.summary});

  final List<HistoryEntry> entries;

  /// Pass it to fetch the next page; `null` on the last page.
  final String? nextCursor;

  /// Only on the first page (no cursor), `null` on later pages.
  final HistorySummary? summary;

  @override
  List<Object?> get props => [entries, nextCursor, summary];
}
