import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/jalali_date_picker_sheet.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../services/domain/entities/service_category.dart';
import '../../../services/presentation/providers/service_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/history_period.dart';
import '../providers/history_providers.dart';
import '../widgets/filter/filter_attachment_section.dart';
import '../widgets/filter/filter_category_section.dart';
import '../widgets/filter/filter_period_section.dart';
import '../widgets/filter/filter_result_count.dart';
import '../widgets/filter/filter_vehicle_section.dart';

/// "فیلتر سوابق" (Stitch): edits a pending copy of the history filter; "اعمال فیلتر" applies it
/// and closes, "پاک کردن" resets it. The result count follows the pending filter.
class HistoryFilterPage extends ConsumerWidget {
  const HistoryFilterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(historyFilterDraftProvider);
    final notifier = ref.read(historyFilterDraftProvider.notifier);
    final vehicles = ref.watch(vehiclesProvider).value ?? const <Vehicle>[];
    final catalog = ref.watch(serviceCatalogProvider).value ?? const <ServiceCategory>[];
    final count = ref.watch(historyMatchCountProvider);
    final now = ref.watch(clockProvider)();
    return Scaffold(
      appBar: _FilterAppBar(activeCount: draft.activeCount, onClear: notifier.reset),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          FilterVehicleSection(
            vehicles: vehicles,
            selectedIds: draft.vehicleIds,
            onToggle: (vehicle) => notifier.toggleVehicle(vehicle.id, garageSize: vehicles.length),
            onSelectAll: notifier.selectAllVehicles,
          ),
          const SizedBox(height: 24),
          FilterCategorySection(
            catalog: catalog,
            selected: draft.categories,
            onToggle: notifier.toggleCategory,
            onSelectAll: notifier.selectAllCategories,
          ),
          const SizedBox(height: 24),
          FilterAttachmentSection(
            value: draft.attachmentsOnly,
            onChanged: notifier.setAttachmentsOnly,
          ),
          const SizedBox(height: 24),
          FilterPeriodSection(
            filter: draft,
            now: now,
            onSelected: (period) => period == HistoryPeriod.custom
                ? _pickRange(context, ref, now)
                : notifier.setPeriod(period),
          ),
          const SizedBox(height: 24),
          FilterResultCount(count: count.value, loading: count.isLoading),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () {
              ref.read(historyFilterProvider.notifier).apply(ref.read(historyFilterDraftProvider));
              Navigator.of(context).pop();
            },
            child: Text(l10n.historyFilterApply),
          ),
        ),
      ),
    );
  }

  /// Asks for the first, then the last day of a custom range (Jalali wheels). Cancelling either
  /// keeps the current period.
  Future<void> _pickRange(BuildContext context, WidgetRef ref, DateTime now) async {
    final l10n = AppLocalizations.of(context);
    final draft = ref.read(historyFilterDraftProvider);
    final today = DateTime(now.year, now.month, now.day);
    final first = DateTime(1990);
    final from = await JalaliDatePickerSheet.show(
      context,
      initial: draft.customFrom ?? today,
      first: first,
      last: today,
      title: l10n.historyFilterFrom,
      confirmLabel: l10n.historyFilterPickDate,
    );
    if (from == null || !context.mounted) return;
    final to = await JalaliDatePickerSheet.show(
      context,
      initial: draft.customTo ?? today,
      first: from,
      last: today,
      title: l10n.historyFilterTo,
      confirmLabel: l10n.historyFilterPickDate,
    );
    if (to == null || !context.mounted) return;
    ref
        .read(historyFilterDraftProvider.notifier)
        .setPeriod(HistoryPeriod.custom, from: from, to: to);
  }
}

/// Close button, title with the active-filter count, and "پاک کردن".
class _FilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _FilterAppBar({required this.activeCount, required this.onClear});

  final int activeCount;
  final VoidCallback onClear;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      scrolledUnderElevation: 1,
      shadowColor: scheme.shadow.withValues(alpha: 0.04),
      title: Row(
        children: [
          IconButton(
            tooltip: l10n.historyFilterClose,
            onPressed: () => Navigator.of(context).maybePop(),
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            style: IconButton.styleFrom(backgroundColor: scheme.surfaceContainer),
            color: scheme.onSurface,
            icon: const Icon(Icons.close, size: 22),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l10n.historyFilterTitle,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
            ),
          ),
          if (activeCount > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                l10n.historyFilterActive(activeCount),
                style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurface),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: onClear,
          style: TextButton.styleFrom(
            foregroundColor: scheme.secondary,
            minimumSize: const Size(48, 48),
            textStyle: theme.textTheme.labelMedium,
          ),
          child: Text(l10n.historyFilterClear),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
