import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_field.dart';
import '../../domain/entities/expense_rules.dart';
import 'expense_field.dart';

/// "عنوان هزینه" and "شماره بیمه‌نامه یا کد یکتا / ارجاع".
class ExpenseTextCard extends StatelessWidget {
  const ExpenseTextCard({
    super.key,
    required this.titleController,
    required this.referenceController,
    required this.onTitleChanged,
    required this.onReferenceChanged,
    this.titleError,
    this.referenceError,
  });

  final TextEditingController titleController;
  final TextEditingController referenceController;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onReferenceChanged;
  final String? titleError;
  final String? referenceError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return WizardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExpenseField(
            label: l10n.expenseTitleLabel,
            child: TextField(
              controller: titleController,
              onChanged: onTitleChanged,
              maxLength: ExpenseRules.titleMaxLength,
              textInputAction: TextInputAction.next,
              style: theme.textTheme.bodyMedium,
              decoration: wizardInputDecoration(
                context,
                hint: l10n.expenseTitleHint,
                hasError: titleError != null,
              ),
            ),
          ),
          if (titleError case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
          const SizedBox(height: 16),
          ExpenseField(
            label: l10n.expenseReferenceLabel,
            child: TextField(
              controller: referenceController,
              onChanged: onReferenceChanged,
              maxLength: ExpenseRules.referenceMaxLength,
              textInputAction: TextInputAction.next,
              style: theme.textTheme.bodyMedium,
              decoration: wizardInputDecoration(
                context,
                hint: l10n.expenseReferenceHint,
                hasError: referenceError != null,
              ),
            ),
          ),
          if (referenceError case final error?) ...[
            const SizedBox(height: 6),
            AuthErrorText(error),
          ],
        ],
      ),
    );
  }
}
