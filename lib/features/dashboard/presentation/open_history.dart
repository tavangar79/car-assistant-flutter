import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../history/presentation/providers/history_providers.dart';

/// The history filters the dashboard links open with.
enum HistoryPreset {
  /// "فیلتر در تاریخچه ›": the current Jalali year (its start → now).
  currentYear,

  /// "مشاهده اسناد ›": `hasAttachment=true`.
  withAttachments,
}

/// Presets the history filter to [preset] and opens the History tab.
void openHistory(BuildContext context, WidgetRef ref, HistoryPreset preset) {
  final filter = ref.read(historyFilterProvider.notifier);
  switch (preset) {
    case HistoryPreset.currentYear:
      filter.showCurrentYear();
    case HistoryPreset.withAttachments:
      filter.showWithAttachment();
  }
  context.go(AppRoutes.historyPath);
}
