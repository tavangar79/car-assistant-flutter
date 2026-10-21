import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../fuel/presentation/widgets/quick_chip.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_field.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../domain/entities/expense_rules.dart';
import 'expense_field.dart';

/// "مبلغ هزینه پرداخت‌شده": the amount in odometer digits with "تومان" at its start, then the
/// quick-add chips (+۱۰۰٬۰۰۰ / +۵۰۰٬۰۰۰ / +۱٬۰۰۰٬۰۰۰ / رند کردن).
class ExpenseAmountCard extends StatelessWidget {
  const ExpenseAmountCard({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onAdd,
    required this.onRound,
    this.error,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<int> onAdd;
  final VoidCallback onRound;
  final String? error;

  /// Largest number of digits of an amount (999,999,999 toman has 9).
  static const maxDigits = 9;

  static DigitsInputFormatter formatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: maxDigits, grouped: true);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final format = NumberFormat.decimalPattern(l10n.localeName);
    final inputFormatter = formatter(l10n.localeName);
    return WizardCard(
      child: ExpenseField(
        label: l10n.expenseAmountLabel,
        hint: l10n.expenseRequired,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [inputFormatter],
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: AppTextStyles.metricOdometer.copyWith(color: scheme.onSurface),
              decoration: wizardInputDecoration(
                context,
                hint: inputFormatter.format('0'),
                hasError: error != null,
                prefixIcon: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
                  child: Text(
                    l10n.currencyToman,
                    style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
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
                  for (final step in ExpenseRules.amountSteps) ...[
                    QuickChip(label: '+${format.format(step)}', onTap: () => onAdd(step)),
                    const SizedBox(width: 6),
                  ],
                  QuickChip(label: l10n.expenseRoundAmount, onTap: onRound),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
