import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../services/presentation/widgets/service_icon_tile.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import '../../domain/entities/due_item.dart';
import '../providers/interval_providers.dart';
import 'due_item_card.dart';
import 'due_texts.dart';

/// "وضعیت و سرویس‌های پیش‌رو" of the vehicle details page: the "تنظیم" action to the intervals
/// page, then the items that are not `ok` as rows (tapping opens the due page), or the empty
/// state when every interval is fine.
class DueSection extends ConsumerWidget {
  const DueSection({
    super.key,
    required this.vehicleId,
    required this.onOpenDue,
    required this.onOpenSettings,
  });

  final String vehicleId;
  final VoidCallback onOpenDue;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final report = ref.watch(dueReportProvider(vehicleId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(Icons.pending_actions, size: 20, color: muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.vehicleDetailsDueTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
              TextButton.icon(
                onPressed: onOpenSettings,
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 40),
                  foregroundColor: scheme.secondary,
                  textStyle: theme.textTheme.labelMedium,
                ),
                icon: const Icon(Icons.tune, size: 18),
                label: Text(l10n.vehicleDetailsDueSettings),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        report.when(
          loading: () => const DetailsCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, _) => DetailsCard(
            child: Column(
              children: [
                Text(l10n.dueLoadError, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(dueReportProvider(vehicleId)),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
          data: (report) {
            final pending = report.pending;
            if (pending.isEmpty) {
              return DetailsCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Icon(Icons.event_available_outlined, size: 40, color: scheme.outline),
                      const SizedBox(height: 8),
                      Text(
                        l10n.vehicleDetailsDueEmpty,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                      ),
                    ],
                  ),
                ),
              );
            }
            return DetailsCard(
              child: Column(
                children: [
                  for (final (index, item) in pending.indexed) ...[
                    if (index > 0) Divider(height: 1, color: scheme.surfaceContainer),
                    _DueRow(item: item, onTap: onOpenDue),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

/// One pending interval: tinted icon tile, title, remaining line, status badge.
class _DueRow extends StatelessWidget {
  const _DueRow({required this.item, required this.onTap});

  final DueItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            ServiceIconTile(icon: item.icon, tone: dueStatusTone(item.status, tones)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                  ),
                  Text(
                    dueRemainingText(item, l10n),
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            DueStatusBadge(status: item.status),
          ],
        ),
      ),
    );
  }
}
