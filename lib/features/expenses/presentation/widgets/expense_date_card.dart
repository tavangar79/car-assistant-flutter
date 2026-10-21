import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../fuel/presentation/widgets/quick_chip.dart';
import '../../../services/presentation/widgets/service_formats.dart';
import '../../../services/presentation/widgets/wizard/service_date_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import 'expense_field.dart';
import 'expense_formats.dart';

/// "تاریخ پرداخت / صدور": the chosen Jalali date with its weekday and numeric form, then the
/// chips today / yesterday / last week / pick a date.
class ExpenseDateCard extends StatelessWidget {
  const ExpenseDateCard({
    super.key,
    required this.date,
    required this.now,
    required this.onChip,
    required this.onPick,
    this.error,
  });

  /// The chosen day (local).
  final DateTime date;
  final DateTime now;
  final ValueChanged<ServiceDateChip> onChip;
  final VoidCallback onPick;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final active = ServiceDateCard.chipOf(date, now);
    return WizardCard(
      child: ExpenseField(
        label: l10n.expensePaidAtLabel,
        hint: l10n.serviceDateBadge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onPick,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20, color: scheme.secondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formatServiceDate(date, l10n),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
                        ),
                      ),
                      Text(
                        formatJalaliNumeric(date, l10n.localeName),
                        style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (error case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final chip in ServiceDateChip.values) ...[
                    QuickChip(
                      label: switch (chip) {
                        ServiceDateChip.today => l10n.serviceDateToday,
                        ServiceDateChip.yesterday => l10n.serviceDateYesterday,
                        ServiceDateChip.lastWeek => l10n.serviceDateLastWeek,
                      },
                      selected: chip == active,
                      onTap: () => onChip(chip),
                    ),
                    const SizedBox(width: 6),
                  ],
                  QuickChip(
                    label: l10n.expenseDatePick,
                    icon: Icons.edit_calendar_outlined,
                    onTap: onPick,
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
