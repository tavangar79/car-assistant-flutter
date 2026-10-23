import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/tone_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/domain/entities/history_type.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';

/// "محتوای گزارش خروجی": a checkbox row per record type, the PDF images row and "انتخاب همه".
class ReportContentCard extends StatelessWidget {
  const ReportContentCard({
    super.key,
    required this.types,
    required this.includeImages,
    required this.onToggleType,
    required this.onToggleImages,
    required this.onToggleAll,
  });

  final Set<HistoryType> types;
  final bool includeImages;
  final ValueChanged<HistoryType> onToggleType;
  final VoidCallback onToggleImages;
  final VoidCallback onToggleAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    Widget type(HistoryType type, IconData icon, ToneColors tone, String title, String hint) =>
        _ContentRow(
          icon: icon,
          tone: tone,
          title: title,
          hint: hint,
          checked: types.contains(type),
          onTap: () => onToggleType(type),
        );
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.rule, size: 20, color: scheme.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.reportContentTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              TextButton(
                onPressed: onToggleAll,
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  foregroundColor: scheme.secondary,
                  textStyle: theme.textTheme.labelSmall,
                ),
                child: Text(l10n.reportSelectAll),
              ),
            ],
          ),
          type(
            HistoryType.service,
            Icons.build_outlined,
            tones.info,
            l10n.reportContentServices,
            l10n.reportContentServicesHint,
          ),
          const SizedBox(height: 4),
          type(
            HistoryType.fuel,
            Icons.local_gas_station_outlined,
            tones.amber,
            l10n.reportContentFuel,
            l10n.reportContentFuelHint,
          ),
          const SizedBox(height: 4),
          type(
            HistoryType.expense,
            Icons.receipt_long_outlined,
            tones.info,
            l10n.reportContentExpenses,
            l10n.reportContentExpensesHint,
          ),
          const SizedBox(height: 4),
          _ContentRow(
            icon: Icons.attach_file,
            tone: tones.neutral,
            title: l10n.reportContentImages,
            hint: l10n.reportContentImagesHint,
            checked: includeImages,
            onTap: onToggleImages,
          ),
        ],
      ),
    );
  }
}

/// A tappable row: a tinted icon tile, the title and hint, and a checkbox.
class _ContentRow extends StatelessWidget {
  const _ContentRow({
    required this.icon,
    required this.tone,
    required this.title,
    required this.hint,
    required this.checked,
    required this.onTap,
  });

  final IconData icon;
  final ToneColors tone;
  final String title;
  final String hint;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tone.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: tone.foreground),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      hint,
                      style: theme.textTheme.bodySmall?.copyWith(color: AppTones.of(context).muted),
                    ),
                  ],
                ),
              ),
              Checkbox(value: checked, onChanged: (_) => onTap()),
            ],
          ),
        ),
      ),
    );
  }
}
