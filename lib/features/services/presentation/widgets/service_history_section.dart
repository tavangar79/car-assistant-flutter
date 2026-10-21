import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/empty_section.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_visit.dart';
import '../providers/service_providers.dart';
import 'service_icon_tile.dart';

/// "تاریخچه آخرین خدمات و سرویس‌ها" of the vehicle details page: the last [maxVisits] visits as
/// rows (icon tile, items, Jalali date, total), the empty state when there are none.
class ServiceHistorySection extends ConsumerWidget {
  const ServiceHistorySection({super.key, required this.vehicleId, required this.onOpen});

  static const maxVisits = 10;

  final String vehicleId;
  final ValueChanged<ServiceVisit> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final visits = ref.watch(serviceVisitsProvider(vehicleId));
    final catalog = ref.watch(serviceCatalogProvider).value ?? const <ServiceCategory>[];
    if (visits.value case final list? when list.isEmpty) {
      return EmptySection(
        icon: Icons.history_edu,
        title: l10n.vehicleDetailsHistoryTitle,
        emptyIcon: Icons.build_circle_outlined,
        message: l10n.vehicleDetailsHistoryEmpty,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(Icons.history_edu, size: 20, color: muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.vehicleDetailsHistoryTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        visits.when(
          loading: () => const DetailsCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, _) => DetailsCard(
            child: Column(
              children: [
                Text(l10n.serviceHistoryLoadError, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(serviceVisitsProvider(vehicleId)),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
          data: (list) => DetailsCard(
            child: Column(
              children: [
                for (final (index, visit) in list.take(maxVisits).indexed) ...[
                  if (index > 0) Divider(height: 1, color: scheme.surfaceContainer),
                  _VisitRow(visit: visit, catalog: catalog, onTap: () => onOpen(visit)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// One visit: the first item's icon tile, its title (and how many more), the date, the total.
class _VisitRow extends StatelessWidget {
  const _VisitRow({required this.visit, required this.catalog, required this.onTap});

  final ServiceVisit visit;
  final List<ServiceCategory> catalog;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final first = visit.lineItems.first;
    final item = findServiceItem(catalog, first.itemId);
    final more = visit.lineItems.length - 1;
    final title = [
      item?.title ?? first.itemId,
      if (more > 0) l10n.serviceHistoryMore(more),
    ].join(' ');
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            ServiceIconTile(icon: item?.icon ?? '', tone: tones.neutral),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                  ),
                  Text(
                    '${formatJalaliDate(visit.serviceDate.toLocal(), l10n)} • '
                    '${l10n.serviceHistoryAmount(visit.totalCost)}',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
                  ),
                ],
              ),
            ),
            if (visit.hasInvoice)
              Icon(Icons.receipt_long_outlined, size: 18, color: scheme.onSurfaceVariant),
            // chevron_right mirrors to point left (forward) in RTL.
            Icon(Icons.chevron_right, size: 20, color: scheme.outline),
          ],
        ),
      ),
    );
  }
}
