import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../services/presentation/widgets/service_icon_tile.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/empty_section.dart';
import '../../domain/entities/fuel_log.dart';
import '../providers/fuel_providers.dart';
import 'fuel_formats.dart';

/// "آخرین سوخت‌گیری‌ها" of the vehicle details page: the last [maxLogs] fill-ups as rows (fuel
/// tile, type and volume, date, odometer and cost, the economy badge), the empty state when
/// there are none.
class FuelSection extends ConsumerWidget {
  const FuelSection({super.key, required this.vehicleId});

  static const maxLogs = 5;

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final logs = ref.watch(fuelLogsProvider(vehicleId));
    if (logs.value case final list? when list.isEmpty) {
      return EmptySection(
        icon: Icons.local_gas_station_outlined,
        title: l10n.fuelSectionTitle,
        emptyIcon: Icons.local_gas_station_outlined,
        message: l10n.fuelSectionEmpty,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(Icons.local_gas_station_outlined, size: 20, color: muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.fuelSectionTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        logs.when(
          loading: () => const DetailsCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, _) => DetailsCard(
            child: Column(
              children: [
                Text(l10n.fuelSectionLoadError, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(fuelLogsProvider(vehicleId)),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
          data: (list) => DetailsCard(
            child: Column(
              children: [
                for (final (index, log) in list.take(maxLogs).indexed) ...[
                  if (index > 0) Divider(height: 1, color: scheme.surfaceContainer),
                  _FuelRow(log: log),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// One fill-up: fuel tile, type and volume, date • odometer • cost, the economy when computed.
class _FuelRow extends StatelessWidget {
  const _FuelRow({required this.log});

  final FuelLog log;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final unit = fuelUnitLabel(log.fuelType, l10n);
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          ServiceIconTile(icon: 'local_gas_station', tone: tones.neutral),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.fuelRowTitle(
                    fuelTypeLabel(log.fuelType, l10n),
                    formatDecimal(log.volume, l10n.localeName),
                    unit,
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                ),
                Text(
                  '${formatJalaliDate(log.fueledAt.toLocal(), l10n)} • '
                  '${l10n.serviceKmValue(log.odometerKm)} • '
                  '${l10n.serviceHistoryAmount(log.totalCost)}',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
                ),
              ],
            ),
          ),
          if (log.economy case final economy?) ...[
            const SizedBox(width: 8),
            WizardBadge(l10n.fuelRowEconomy(formatDecimal(economy, l10n.localeName), unit)),
          ],
        ],
      ),
    );
  }
}
