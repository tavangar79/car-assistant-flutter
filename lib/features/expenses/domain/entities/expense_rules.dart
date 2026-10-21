import 'package:fpdart/fpdart.dart';

import 'expense_draft.dart';
import 'expense_failures.dart';
import 'expense_field.dart';
import 'new_expense.dart';

/// The backend's expense rules, checked before sending so the user gets instant feedback.
abstract final class ExpenseRules {
  static const titleMaxLength = 100;
  static const referenceMaxLength = 60;
  static const issuerMaxLength = 100;

  /// Quick-add steps of the amount, in screen order (toman).
  static const amountSteps = [100000, 500000, 1000000];

  /// "رند کردن": the amount rounded to the nearest multiple of this.
  static const roundingStep = 50000;

  static int roundAmount(int amount) => (amount / roundingStep).round() * roundingStep;

  /// Checks [draft]; on success returns the expense to send. A paid date after [now] is rejected
  /// (`paidAt`); an expiry that is missing or not after the paid date too (`expiresAt`).
  static Either<InvalidExpenseFailure, NewExpense> validate(
    ExpenseDraft draft, {
    required DateTime now,
  }) {
    final category = draft.category;
    final amount = draft.amount;
    final title = draft.title.trim();
    final reference = draft.referenceNumber.trim();
    final issuer = draft.issuer.trim();
    final paidAt = draft.paidAt(now);
    final expiresAt = draft.hasExpiry ? draft.expiresAt : null;
    final invalid = {
      if (category == null) ExpenseField.category,
      if (amount == null || amount < 1) ExpenseField.amount,
      if (title.length > titleMaxLength) ExpenseField.title,
      if (reference.length > referenceMaxLength) ExpenseField.referenceNumber,
      if (paidAt.isAfter(now)) ExpenseField.paidAt,
      if (draft.hasExpiry && (expiresAt == null || !expiresAt.isAfter(paidAt)))
        ExpenseField.expiresAt,
      if (issuer.length > issuerMaxLength) ExpenseField.issuer,
    };
    if (invalid.isNotEmpty) return Left(InvalidExpenseFailure(invalid));
    return Right(
      NewExpense(
        category: category!,
        amount: amount!,
        title: title.isEmpty ? null : title,
        referenceNumber: reference.isEmpty ? null : reference,
        paidAt: paidAt,
        expiresAt: expiresAt,
        expiryReminder: draft.expiryReminder,
        paymentMethod: draft.paymentMethod,
        issuer: issuer.isEmpty ? null : issuer,
      ),
    );
  }
}
