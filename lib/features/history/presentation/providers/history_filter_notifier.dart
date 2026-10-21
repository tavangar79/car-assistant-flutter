import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/history_filter.dart';
import '../../domain/entities/history_period.dart';
import '../../domain/entities/history_type.dart';

/// The applied filter of the history page. Other pages preset it before opening the history tab:
///
/// ```dart
/// ref.read(historyFilterProvider.notifier).showCurrentYear();
/// context.go(AppRoutes.historyPath);
/// ```
class HistoryFilterNotifier extends Notifier<HistoryFilter> {
  /// Starts over when the user signs in or out, so a filter never outlives its user.
  @override
  HistoryFilter build() {
    ref.watch(authStatusProvider);
    return HistoryFilter.initial;
  }

  /// Replaces the whole filter (the filter page's "اعمال فیلتر").
  void apply(HistoryFilter filter) => state = filter;

  /// Every record of the current Jalali year, nothing else filtered.
  void showCurrentYear() => state = HistoryFilter.initial.withPeriod(HistoryPeriod.currentYear);

  /// Only records with an invoice or attachment, nothing else filtered.
  void showWithAttachment() => state = HistoryFilter.initial.copyWith(attachmentsOnly: true);

  void setType(HistoryType type) => state = state.copyWith(type: type);

  void toggleAttachmentsOnly() => state = state.copyWith(attachmentsOnly: !state.attachmentsOnly);

  /// Shows [vehicleIds] only; empty means every vehicle.
  void setVehicles(Set<String> vehicleIds) => state = state.copyWith(vehicleIds: vehicleIds);
}
