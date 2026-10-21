import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/localize_digits.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../vehicles/domain/entities/vehicle.dart';
import '../../../domain/entities/service_visit.dart';
import '../service_formats.dart';

/// The read-only header of a visit: the vehicle, the date and odometer, the workshop (and notes
/// when there are any), then the note that only the rows below can be edited.
class ServiceHeaderCard extends StatelessWidget {
  const ServiceHeaderCard({super.key, required this.visit, required this.vehicle});

  final ServiceVisit visit;

  /// `null` while the vehicle is still loading.
  final Vehicle? vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final vehicle = this.vehicle;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (vehicle != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.surfaceContainerHigh),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.2)),
                    ),
                    child: Icon(Icons.directions_car, size: 20, color: scheme.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.nickname,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                        Text(
                          [
                            l10n.vehicleDetailsModelYear(
                              localizeDigits('${vehicle.yearJalali}', l10n.localeName),
                            ),
                            vehicle.make.name,
                            vehicle.model.name,
                          ].join(' • '),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today, size: 18, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.serviceDetailsDateLabel,
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                    ),
                    Text(
                      formatServiceDate(visit.serviceDate.toLocal(), l10n),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.speed, size: 20, color: scheme.secondary),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.serviceDetailsOdometerLabel,
                          style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                        ),
                        Text(
                          NumberFormat.decimalPattern(l10n.localeName).format(visit.odometerKm),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 24, color: scheme.surfaceContainer),
          _InfoRow(
            icon: Icons.garage_outlined,
            label: l10n.serviceDetailsWorkshopLabel,
            value: visit.workshop,
          ),
          if (visit.notes case final notes?) ...[
            const SizedBox(height: 10),
            _InfoRow(icon: Icons.notes, label: l10n.serviceDetailsNotesLabel, value: notes),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: scheme.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.serviceDetailsHeaderNote,
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 19, color: scheme.secondary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary)),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
