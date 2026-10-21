import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../expenses/presentation/widgets/expense_field.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';

/// "تاریخ صدور": the chosen Jalali date (tap to pick) with a clear button, or "انتخاب تاریخ صدور".
class DocumentIssueDateCard extends StatelessWidget {
  const DocumentIssueDateCard({
    super.key,
    required this.date,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? date;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final date = this.date;
    return WizardCard(
      child: ExpenseField(
        label: l10n.documentIssuedAtLabel,
        child: Material(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onPick,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: scheme.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      date == null
                          ? l10n.documentIssuedAtPick
                          : formatJalaliDate(date.toLocal(), l10n),
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: date == null ? scheme.outline : scheme.onSurface,
                      ),
                    ),
                  ),
                  if (date != null)
                    IconButton(
                      tooltip: l10n.documentIssuedAtClear,
                      onPressed: onClear,
                      color: scheme.onSurfaceVariant,
                      icon: const Icon(Icons.close, size: 18),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
