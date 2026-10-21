import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../services/presentation/widgets/service_formats.dart';
import 'quick_chip.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_field.dart';

/// Which quick date chip is active on the fuel page.
enum FuelDateChip { today, yesterday }

/// "تاریخ سوخت‌گیری": the chosen Jalali date with its weekday and the time (tap to change it),
/// then the chips today / yesterday / pick another date.
class FuelDateCard extends StatelessWidget {
  const FuelDateCard({
    super.key,
    required this.date,
    required this.now,
    required this.onChip,
    required this.onPickDate,
    required this.onPickTime,
  });

  /// The chosen date and time (local).
  final DateTime date;
  final DateTime now;
  final ValueChanged<FuelDateChip> onChip;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  /// The chip that matches [date] against [now], if any.
  static FuelDateChip? chipOf(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    return switch (today.difference(day).inDays) {
      0 => FuelDateChip.today,
      1 => FuelDateChip.yesterday,
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final active = chipOf(date, now);
    return WizardCard(
      child: WizardField(
        label: l10n.fuelDateLabel,
        badge: l10n.serviceDateBadge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 48,
              padding: const EdgeInsetsDirectional.only(start: 16, end: 4),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formatServiceDate(date, l10n),
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                    ),
                  ),
                  TextButton(
                    onPressed: onPickTime,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 40),
                      foregroundColor: scheme.onSurfaceVariant,
                      textStyle: theme.textTheme.labelSmall,
                    ),
                    child: Text(formatMinutes(date.hour * 60 + date.minute, l10n.localeName)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  QuickChip(
                    label: l10n.serviceDateToday,
                    selected: active == FuelDateChip.today,
                    onTap: () => onChip(FuelDateChip.today),
                  ),
                  const SizedBox(width: 4),
                  QuickChip(
                    label: l10n.serviceDateYesterday,
                    selected: active == FuelDateChip.yesterday,
                    onTap: () => onChip(FuelDateChip.yesterday),
                  ),
                  const SizedBox(width: 4),
                  QuickChip(
                    label: l10n.fuelDateOther,
                    icon: Icons.edit_calendar_outlined,
                    onTap: onPickDate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
