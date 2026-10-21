import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../data/datasources/history_remote_data_source.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/entities/history_filter.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/usecases/get_history.dart';
import 'history_controller.dart';
import 'history_filter_draft.dart';
import 'history_filter_notifier.dart';

// Dependency wiring for the history feature. Override [historyRepositoryProvider] in tests.

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(HistoryRemoteDataSource(ref.watch(dioProvider)));
});

final getHistoryProvider = Provider<GetHistory>((ref) {
  return GetHistory(ref.watch(historyRepositoryProvider), now: ref.watch(clockProvider));
});

/// The applied filter. Kept alive, so another page can preset it (see [HistoryFilterNotifier])
/// before switching to the history tab.
final historyFilterProvider = NotifierProvider<HistoryFilterNotifier, HistoryFilter>(
  HistoryFilterNotifier.new,
);

/// The loaded history pages for [historyFilterProvider].
final historyControllerProvider =
    AsyncNotifierProvider.autoDispose<HistoryController, HistoryState>(HistoryController.new);

/// The pending filter of the filter page.
final historyFilterDraftProvider = NotifierProvider.autoDispose<HistoryFilterDraft, HistoryFilter>(
  HistoryFilterDraft.new,
);

/// How many records match the pending filter ("تعداد نتایج"): one `limit=1` query.
final historyMatchCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final filter = ref.watch(historyFilterDraftProvider);
  final result = await ref.watch(getHistoryProvider).call(filter, limit: 1);
  final page = result.getOrElse((failure) => throw failure);
  return page.summary?.entryCount ?? page.entries.length;
});
