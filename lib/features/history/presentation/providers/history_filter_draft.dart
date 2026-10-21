import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/history_categories.dart';
import '../../domain/entities/history_filter.dart';
import '../../domain/entities/history_period.dart';
import 'history_providers.dart';

/// The pending filter of the filter page: starts as the applied filter and is only applied on
/// "اعمال فیلتر".
class HistoryFilterDraft extends Notifier<HistoryFilter> {
  @override
  HistoryFilter build() => ref.read(historyFilterProvider);

  /// Adds or removes [vehicleId]. Choosing every vehicle one by one is the same as all of them.
  void toggleVehicle(String vehicleId, {required int garageSize}) {
    final ids = {...state.vehicleIds};
    if (!ids.remove(vehicleId)) ids.add(vehicleId);
    state = state.copyWith(vehicleIds: ids.length >= garageSize ? const {} : ids);
  }

  void selectAllVehicles() => state = state.copyWith(vehicleIds: const {});

  void toggleCategory(String category) {
    final categories = {...state.categories};
    if (!categories.remove(category)) categories.add(category);
    state = state.copyWith(categories: categories);
  }

  void selectAllCategories() => state = state.copyWith(categories: HistoryCategories.all.toSet());

  void setAttachmentsOnly(bool value) => state = state.copyWith(attachmentsOnly: value);

  void setPeriod(HistoryPeriod period, {DateTime? from, DateTime? to}) =>
      state = state.withPeriod(period, from: from, to: to);

  /// "پاک کردن": nothing filtered; the type tab is kept.
  void reset() => state = HistoryFilter.initial.copyWith(type: state.type);
}
