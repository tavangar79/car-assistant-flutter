import 'package:car_assistant/features/expenses/data/models/create_expense_request_dto.dart';
import 'package:car_assistant/features/expenses/data/models/expense_dto.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_category.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_payment_method.dart';
import 'package:car_assistant/features/expenses/domain/entities/new_expense.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../expense_fixtures.dart';

void main() {
  test('ExpenseDto parses the contract payload without an attachment', () {
    expect(ExpenseDto.fromJson(expenseJson()).toEntity(), expense());
  });

  test('ExpenseDto parses the contract payload with an attachment', () {
    expect(
      ExpenseDto.fromJson(expenseJson(withAttachment: true)).toEntity(),
      expense(withAttachment: true),
    );
  });

  test('ExpenseDto accepts absent optionals', () {
    final json = expenseJson()
      ..['title'] = null
      ..['referenceNumber'] = null
      ..['expiresAt'] = null
      ..['paymentMethod'] = null
      ..['issuer'] = null;

    final parsed = ExpenseDto.fromJson(json).toEntity();

    expect(parsed.title, isNull);
    expect(parsed.referenceNumber, isNull);
    expect(parsed.expiresAt, isNull);
    expect(parsed.paymentMethod, isNull);
    expect(parsed.issuer, isNull);
    expect(parsed.hasAttachment, isFalse);
  });

  test('CreateExpenseRequestDto sends the contract body with UTC dates and nulls', () {
    final dto = CreateExpenseRequestDto(
      NewExpense(
        category: ExpenseCategory.thirdPartyInsurance,
        amount: 5850000,
        title: 'تمدید بیمه‌نامه شخص ثالث ۱۲ ماهه ایران',
        paidAt: DateTime.utc(2024, 11, 17).toLocal(),
        expiresAt: DateTime.utc(2025, 11, 17).toLocal(),
        paymentMethod: ExpensePaymentMethod.online,
      ),
    );

    expect(dto.toJson(), {
      'category': 'third_party_insurance',
      'amount': 5850000,
      'title': 'تمدید بیمه‌نامه شخص ثالث ۱۲ ماهه ایران',
      'referenceNumber': null,
      'paidAt': '2024-11-17T00:00:00.000Z',
      'expiresAt': '2025-11-17T00:00:00.000Z',
      'expiryReminder': true,
      'paymentMethod': 'online',
      'issuer': null,
    });
  });

  test('the enums round-trip their wire values', () {
    for (final category in ExpenseCategory.values) {
      expect(ExpenseCategory.fromWire(category.wire), category);
    }
    for (final method in ExpensePaymentMethod.values) {
      expect(ExpensePaymentMethod.fromWire(method.wire), method);
    }
    expect(ExpenseCategory.thirdPartyInsurance.suggestsExpiry, isTrue);
    expect(ExpenseCategory.inspection.suggestsExpiry, isTrue);
    expect(ExpenseCategory.fine.suggestsExpiry, isFalse);
  });
}
