import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/expense_payment_method.dart';

/// The screen title of a category (contract catalog).
String expenseCategoryTitle(ExpenseCategory category, AppLocalizations l10n) => switch (category) {
  ExpenseCategory.thirdPartyInsurance => l10n.expenseCategoryThirdPartyInsurance,
  ExpenseCategory.bodyInsurance => l10n.expenseCategoryBodyInsurance,
  ExpenseCategory.fine => l10n.expenseCategoryFine,
  ExpenseCategory.toll => l10n.expenseCategoryToll,
  ExpenseCategory.inspection => l10n.expenseCategoryInspection,
  ExpenseCategory.other => l10n.expenseCategoryOther,
};

/// The Material Symbols name of a category (contract catalog), for `materialSymbolIcon`.
String expenseCategoryIcon(ExpenseCategory category) => switch (category) {
  ExpenseCategory.thirdPartyInsurance => 'verified_user',
  ExpenseCategory.bodyInsurance => 'shield',
  ExpenseCategory.fine => 'gavel',
  ExpenseCategory.toll => 'toll',
  ExpenseCategory.inspection => 'fact_check',
  ExpenseCategory.other => 'payments',
};

/// The screen label of a payment method.
String expensePaymentLabel(ExpensePaymentMethod method, AppLocalizations l10n) => switch (method) {
  ExpensePaymentMethod.online => l10n.expensePaymentOnline,
  ExpensePaymentMethod.pos => l10n.expensePaymentPos,
};

/// A local [date] as a numeric Jalali date, e.g. `۱۴۰۳/۰۸/۲۷`.
String formatJalaliNumeric(DateTime date, String locale) {
  final jalali = Jalali.fromDateTime(date);
  String two(int n) => n.toString().padLeft(2, '0');
  return localizeDigits('${jalali.year}/${two(jalali.month)}/${two(jalali.day)}', locale);
}
