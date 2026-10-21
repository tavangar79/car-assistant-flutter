import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_field.dart';
import '../../domain/entities/expense_payment_method.dart';
import '../../domain/entities/expense_rules.dart';
import 'expense_field.dart';
import 'expense_formats.dart';

/// "شیوه پرداخت" (two buttons: online / POS) and "واحد صادرکننده یا نمایندگی".
class ExpensePaymentCard extends StatelessWidget {
  const ExpensePaymentCard({
    super.key,
    required this.paymentMethod,
    required this.issuerController,
    required this.onPaymentMethodChanged,
    required this.onIssuerChanged,
    this.issuerError,
  });

  final ExpensePaymentMethod? paymentMethod;
  final TextEditingController issuerController;
  final ValueChanged<ExpensePaymentMethod> onPaymentMethodChanged;
  final ValueChanged<String> onIssuerChanged;
  final String? issuerError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return WizardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExpenseField(
            label: l10n.expensePaymentLabel,
            child: Row(
              children: [
                for (final (index, method) in ExpensePaymentMethod.values.indexed) ...[
                  if (index > 0) const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => onPaymentMethodChanged(method),
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: method == paymentMethod
                            ? scheme.primary
                            : scheme.surfaceContainerHigh,
                        foregroundColor: method == paymentMethod
                            ? scheme.onPrimary
                            : scheme.onSurface,
                        textStyle: theme.textTheme.labelMedium,
                      ),
                      icon: Icon(switch (method) {
                        ExpensePaymentMethod.online => Icons.credit_card_outlined,
                        ExpensePaymentMethod.pos => Icons.point_of_sale_outlined,
                      }, size: 18),
                      label: Text(expensePaymentLabel(method, l10n)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          ExpenseField(
            label: l10n.expenseIssuerLabel,
            child: TextField(
              controller: issuerController,
              onChanged: onIssuerChanged,
              maxLength: ExpenseRules.issuerMaxLength,
              textInputAction: TextInputAction.done,
              style: theme.textTheme.bodyMedium,
              decoration: wizardInputDecoration(
                context,
                hint: l10n.expenseIssuerHint,
                hasError: issuerError != null,
              ),
            ),
          ),
          if (issuerError case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
        ],
      ),
    );
  }
}
