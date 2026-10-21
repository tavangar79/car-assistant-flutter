import 'package:equatable/equatable.dart';

import 'expense_category.dart';
import 'expense_payment_method.dart';

/// A checked expense, ready to send (`POST /api/vehicles/:id/expenses`).
class NewExpense extends Equatable {
  const NewExpense({
    required this.category,
    required this.amount,
    required this.paidAt,
    this.title,
    this.referenceNumber,
    this.expiresAt,
    this.expiryReminder = true,
    this.paymentMethod,
    this.issuer,
  });

  final ExpenseCategory category;
  final int amount;
  final String? title;
  final String? referenceNumber;
  final DateTime paidAt;
  final DateTime? expiresAt;
  final bool expiryReminder;
  final ExpensePaymentMethod? paymentMethod;
  final String? issuer;

  @override
  List<Object?> get props => [
    category,
    amount,
    title,
    referenceNumber,
    paidAt,
    expiresAt,
    expiryReminder,
    paymentMethod,
    issuer,
  ];
}
