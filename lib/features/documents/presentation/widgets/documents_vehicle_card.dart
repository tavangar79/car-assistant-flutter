import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/plate_badge.dart';

/// The vehicle at the top of the wallet: its name, "کیف مدارک و یادآورهای هوشمند تمدید", the plate,
/// and the encryption note with the [documentCount].
class DocumentsVehicleCard extends StatelessWidget {
  const DocumentsVehicleCard({super.key, required this.vehicle, required this.documentCount});

  final Vehicle vehicle;
  final int documentCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.8)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.nickname,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      l10n.documentsVehicleSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PlateBadge(plate: vehicle.plate, dense: true),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.surfaceContainer),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, size: 18, color: tones.label),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.documentsSecureInfo(documentCount),
                    style: theme.textTheme.bodySmall?.copyWith(color: tones.label),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
