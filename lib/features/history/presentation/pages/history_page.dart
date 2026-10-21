import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../services/domain/entities/service_category.dart';
import '../../../services/presentation/providers/service_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/history_filter.dart';
import '../../domain/entities/history_month_group.dart';
import '../../domain/entities/history_type.dart';
import '../providers/history_controller.dart';
import '../providers/history_providers.dart';
import '../widgets/history_app_bar.dart';
import '../widgets/history_entry_row.dart';
import '../widgets/history_footer.dart';
import '../widgets/history_formats.dart';
import '../widgets/history_month_header.dart';
import '../widgets/history_quick_filters.dart';
import '../widgets/history_summary_card.dart';
import '../widgets/history_type_tabs.dart';
import '../widgets/history_vehicle_ribbon.dart';
import '../widgets/history_vehicle_sheet.dart';

/// The History tab (Stitch "تاریخچه"): the shown vehicles, the summary of the filtered records,
/// the type tabs and quick filters, then the records grouped by Jalali month, loaded page by page
/// while scrolling. The tune button opens the filter page.
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final filter = ref.watch(historyFilterProvider);
    final garage = ref.watch(vehiclesProvider).value ?? const <Vehicle>[];
    final shown = filter.vehicleIds.isEmpty
        ? garage
        : [
            for (final vehicle in garage)
              if (filter.vehicleIds.contains(vehicle.id)) vehicle,
          ];
    final history = ref.watch(historyControllerProvider);
    final now = ref.watch(clockProvider)();
    final notifier = ref.read(historyFilterProvider.notifier);
    return Scaffold(
      appBar: HistoryAppBar(
        vehicleLabel: _vehicleLabel(filter, shown, l10n),
        onVehicleTap: () async {
          final ids = await HistoryVehicleSheet.show(
            context,
            vehicles: garage,
            selectedIds: filter.vehicleIds,
          );
          if (ids != null) notifier.setVehicles(ids);
        },
        onFilterTap: () => context.push(AppRoutes.historyFilterPath),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(historyControllerProvider.future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            if (shown.isNotEmpty) ...[
              HistoryVehicleRibbon(vehicles: shown, allVehicles: filter.vehicleIds.isEmpty),
              const SizedBox(height: 16),
            ],
            if (history.value?.summary case final summary? when !history.hasError) ...[
              HistorySummaryCard(title: summaryTitle(filter, now, l10n), summary: summary),
              const SizedBox(height: 20),
            ],
            HistoryTypeTabs(selected: filter.type, onSelected: notifier.setType),
            const SizedBox(height: 4),
            HistoryQuickFilters(
              attachmentsOnly: filter.attachmentsOnly,
              periodLabel: periodChipLabel(filter, now, l10n),
              onToggleAttachments: notifier.toggleAttachmentsOnly,
              onPeriodTap: () => context.push(AppRoutes.historyFilterPath),
            ),
            const SizedBox(height: 12),
            ..._records(context, ref, history, shown),
          ],
        ),
      ),
    );
  }

  /// The month groups, then the next-page trigger or the end-of-history footer.
  List<Widget> _records(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<HistoryState> history,
    List<Vehicle> shown,
  ) {
    final l10n = AppLocalizations.of(context);
    if (history.isLoading) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (history.hasError || history.value == null) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: LoadErrorView(
            message: l10n.historyLoadError,
            onRetry: () => ref.invalidate(historyControllerProvider),
          ),
        ),
      ];
    }
    final state = history.value!;
    if (state.entries.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Text(l10n.historyEmpty, textAlign: TextAlign.center),
        ),
      ];
    }
    final catalog = ref.watch(serviceCatalogProvider).value ?? const <ServiceCategory>[];
    final controller = ref.read(historyControllerProvider.notifier);
    return [
      for (final group in groupByJalaliMonth(state.entries)) ...[
        HistoryMonthHeader(group: group),
        const SizedBox(height: 10),
        for (final entry in group.entries) ...[
          HistoryEntryRow(
            entry: entry,
            catalog: catalog,
            onTap: entry.type == HistoryType.service
                ? () => context.push(AppRoutes.historyServicePath(entry.vehicleId, entry.id))
                : null,
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
      ],
      if (!state.hasMore)
        HistoryFooter(startedAt: _historyStart(shown))
      else if (state.loadMoreFailed)
        Column(
          children: [
            Text(l10n.historyLoadMoreError, textAlign: TextAlign.center),
            TextButton(onPressed: controller.loadMore, child: Text(l10n.retry)),
          ],
        )
      else
        _LoadMoreTrigger(onVisible: controller.loadMore),
    ];
  }

  static String _vehicleLabel(HistoryFilter filter, List<Vehicle> shown, AppLocalizations l10n) {
    if (shown.length == 1) return shown.single.nickname;
    if (filter.vehicleIds.isEmpty) return l10n.historyAllVehicles;
    return l10n.historyVehicleCount(shown.length);
  }

  /// When the earliest shown vehicle was added, or `null` when unknown.
  static DateTime? _historyStart(List<Vehicle> shown) {
    final dates = [for (final vehicle in shown) ?vehicle.createdAt]..sort();
    return dates.firstOrNull;
  }
}

/// A spinner that asks for the next page once the list builds it (it is near the viewport).
class _LoadMoreTrigger extends StatefulWidget {
  const _LoadMoreTrigger({required this.onVisible});

  final VoidCallback onVisible;

  @override
  State<_LoadMoreTrigger> createState() => _LoadMoreTriggerState();
}

class _LoadMoreTriggerState extends State<_LoadMoreTrigger> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onVisible();
    });
  }

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 24),
    child: Center(child: CircularProgressIndicator()),
  );
}
