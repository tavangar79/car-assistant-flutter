import 'package:flutter/material.dart';

import '../../../../core/utils/calendar_days_ago.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';

/// "تعیین موعد انقضا یا تمدید بعدی": the switch; when on, the expiry row (tap to pick), the
/// days-left pill and the reminder checkbox.
class ExpenseExpiryCard extends StatelessWidget {
  const ExpenseExpiryCard({
    super.key,
    required this.enabled,
    required this.expiresAt,
    required this.paidAt,
    required this.now,
    required this.reminder,
    required this.onToggle,
    required this.onPick,
    required this.onReminderChanged,
    this.error,
  });

  final bool enabled;

  /// The chosen expiry (local midnight); `null` until chosen.
  final DateTime? expiresAt;

  /// The paid date (local midnight); "(۱ سال بعد)" is shown when the expiry is a year after it.
  final DateTime paidAt;
  final DateTime now;
  final bool reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPick;
  final ValueChanged<bool> onReminderChanged;
  final String? error;

  /// The expiry row text.
  static String expiryLabel(DateTime? expiresAt, DateTime paidAt, AppLocalizations l10n) {
    if (expiresAt == null) return l10n.expenseExpiryPick;
    final date = formatJalaliDate(expiresAt, l10n);
    final oneYear = DateTime(paidAt.year + 1, paidAt.month, paidAt.day);
    return expiresAt == oneYear ? l10n.expenseExpiryOneYear(date) : date;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final expiresAt = this.expiresAt;
    return WizardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.notifications_active_outlined, size: 18, color: scheme.secondary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.expenseExpiryTitle,
                      style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                    ),
                    Text(
                      l10n.expenseExpiryBody,
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: l10n.expenseExpiryTitle,
                child: Switch(value: enabled, onChanged: onToggle),
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 12),
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
                      Icon(Icons.event_repeat, size: 20, color: scheme.secondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          expiryLabel(expiresAt, paidAt, l10n),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: expiresAt == null ? scheme.outline : scheme.onSurface,
                          ),
                        ),
                      ),
                      if (expiresAt != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.expenseDaysLeft(calendarDaysAgo(now, expiresAt)),
                            style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (error case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
            const SizedBox(height: 4),
            InkWell(
              onTap: () => onReminderChanged(!reminder),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Checkbox(value: reminder, onChanged: (value) => onReminderChanged(value ?? true)),
                  Expanded(
                    child: Text(
                      l10n.expenseReminderCheck,
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
