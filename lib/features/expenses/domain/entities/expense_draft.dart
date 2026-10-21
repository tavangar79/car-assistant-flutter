import 'package:equatable/equatable.dart';

import 'expense_category.dart';
import 'expense_payment_method.dart';

/// What the "ثبت هزینه" form holds before it is checked. `ExpenseRules.validate` turns it into
/// a `NewExpense`.
class ExpenseDraft extends Equatable {
  const ExpenseDraft({
    this.category,
    this.amount,
    this.title = '',
    this.referenceNumber = '',
    this.paidDay,
    this.hasExpiry = false,
    this.expiresAt,
    this.expiryReminder = true,
    this.paymentMethod,
    this.issuer = '',
  });

  final ExpenseCategory? category;

  /// Toman; `null` until typed.
  final int? amount;
  final String title;
  final String referenceNumber;

  /// The day of payment (local midnight); `null` means today.
  final DateTime? paidDay;

  /// The expiry toggle. Only an on toggle sends [expiresAt].
  final bool hasExpiry;

  /// The expiry day (local midnight); `null` until chosen.
  final DateTime? expiresAt;
  final bool expiryReminder;
  final ExpensePaymentMethod? paymentMethod;
  final String issuer;

  /// The day of payment at local midnight, today by default.
  DateTime paidAt(DateTime now) {
    final day = paidDay ?? now;
    return DateTime(day.year, day.month, day.day);
  }

  /// The expiry the form suggests when the toggle is turned on: one year after [paidAt] for
  /// insurance and inspection, nothing otherwise.
  DateTime? suggestedExpiry(DateTime now) {
    if (!(category?.suggestsExpiry ?? false)) return null;
    final paid = paidAt(now);
    return DateTime(paid.year + 1, paid.month, paid.day);
  }

  ExpenseDraft copyWith({
    ExpenseCategory? Function()? category,
    int? Function()? amount,
    String? title,
    String? referenceNumber,
    DateTime? Function()? paidDay,
    bool? hasExpiry,
    DateTime? Function()? expiresAt,
    bool? expiryReminder,
    ExpensePaymentMethod? Function()? paymentMethod,
    String? issuer,
  }) => ExpenseDraft(
    category: category == null ? this.category : category(),
    amount: amount == null ? this.amount : amount(),
    title: title ?? this.title,
    referenceNumber: referenceNumber ?? this.referenceNumber,
    paidDay: paidDay == null ? this.paidDay : paidDay(),
    hasExpiry: hasExpiry ?? this.hasExpiry,
    expiresAt: expiresAt == null ? this.expiresAt : expiresAt(),
    expiryReminder: expiryReminder ?? this.expiryReminder,
    paymentMethod: paymentMethod == null ? this.paymentMethod : paymentMethod(),
    issuer: issuer ?? this.issuer,
  );

  @override
  List<Object?> get props => [
    category,
    amount,
    title,
    referenceNumber,
    paidDay,
    hasExpiry,
    expiresAt,
    expiryReminder,
    paymentMethod,
    issuer,
  ];
}
