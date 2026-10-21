import '../../domain/entities/new_expense.dart';

/// Body of `POST /api/vehicles/:id/expenses`: dates in ISO-8601 UTC, `null` for absent optionals.
class CreateExpenseRequestDto {
  const CreateExpenseRequestDto(this.expense);

  final NewExpense expense;

  Map<String, dynamic> toJson() => {
    'category': expense.category.wire,
    'amount': expense.amount,
    'title': expense.title,
    'referenceNumber': expense.referenceNumber,
    'paidAt': expense.paidAt.toUtc().toIso8601String(),
    'expiresAt': expense.expiresAt?.toUtc().toIso8601String(),
    'expiryReminder': expense.expiryReminder,
    'paymentMethod': expense.paymentMethod?.wire,
    'issuer': expense.issuer,
  };
}
