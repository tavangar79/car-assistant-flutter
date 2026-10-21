import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/history_entry.dart';
import '../../domain/entities/history_summary.dart';
import 'history_providers.dart';

/// The loaded pages of the history for the applied filter.
class HistoryState extends Equatable {
  const HistoryState({
    required this.entries,
    required this.summary,
    this.nextCursor,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  final List<HistoryEntry> entries;

  /// The totals of the whole filtered set (from the first page).
  final HistorySummary? summary;

  /// `null` once the last page is loaded.
  final String? nextCursor;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  bool get hasMore => nextCursor != null;

  HistoryState copyWith({
    List<HistoryEntry>? entries,
    String? nextCursor,
    bool? isLoadingMore,
    bool? loadMoreFailed,
  }) => HistoryState(
    entries: entries ?? this.entries,
    summary: summary,
    nextCursor: nextCursor ?? this.nextCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
  );

  @override
  List<Object?> get props => [entries, summary, nextCursor, isLoadingMore, loadMoreFailed];
}

/// Loads the first page whenever the filter changes, and the next page on [loadMore].
class HistoryController extends AsyncNotifier<HistoryState> {
  @override
  Future<HistoryState> build() async {
    final filter = ref.watch(historyFilterProvider);
    final result = await ref.watch(getHistoryProvider).call(filter);
    final page = result.getOrElse((failure) => throw failure);
    return HistoryState(entries: page.entries, summary: page.summary, nextCursor: page.nextCursor);
  }

  /// Appends the next page. Does nothing while loading, on the last page, or before the first
  /// page is there. A failure is kept in [HistoryState.loadMoreFailed]; call again to retry.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore || state.isLoading) return;
    state = AsyncData(current.copyWith(isLoadingMore: true, loadMoreFailed: false));
    final filter = ref.read(historyFilterProvider);
    final result = await ref.read(getHistoryProvider).call(filter, cursor: current.nextCursor);
    // The filter changed meanwhile: build() has started over, drop this page.
    if (!ref.mounted || ref.read(historyFilterProvider) != filter) return;
    state = AsyncData(switch (result) {
      Right(value: final page) => HistoryState(
        entries: [...current.entries, ...page.entries],
        summary: current.summary,
        nextCursor: page.nextCursor,
      ),
      Left() => current.copyWith(isLoadingMore: false, loadMoreFailed: true),
    });
  }
}
