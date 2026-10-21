import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/expenses/domain/entities/create_expense_result.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_category.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_draft.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_failures.dart';
import 'package:car_assistant/features/expenses/domain/entities/new_expense.dart';
import 'package:car_assistant/features/expenses/domain/repositories/expense_repository.dart';
import 'package:car_assistant/features/expenses/presentation/providers/expense_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../expense_fixtures.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late MockExpenseRepository expenses;
  late ProviderContainer container;
  const draft = ExpenseDraft(category: ExpenseCategory.fine, amount: 1200000);

  setUpAll(() {
    registerFallbackValue(
      NewExpense(category: ExpenseCategory.other, amount: 1, paidAt: DateTime(2026)),
    );
    registerFallbackValue(pdfFile);
  });

  setUp(() {
    expenses = MockExpenseRepository();
    when(() => expenses.getExpenses('v1')).thenAnswer((_) async => const Right([]));
    container = ProviderContainer.test(
      overrides: [expenseRepositoryProvider.overrideWithValue(expenses)],
    );
    // Keep the auto-dispose providers alive for the whole test.
    container.listen(newExpenseControllerProvider, (_, _) {});
  });

  Future<CreateExpenseResult?> submit() =>
      container.read(newExpenseControllerProvider.notifier).submit('v1', draft);

  test('saves and refreshes the expenses', () async {
    container.listen(expensesProvider('v1'), (_, _) {});
    await container.read(expensesProvider('v1').future);
    when(() => expenses.createExpense('v1', any())).thenAnswer((_) async => Right(expense()));

    expect(await submit(), CreateExpenseResult(expense()));
    expect(container.read(newExpenseControllerProvider).hasError, isFalse);

    await container.read(expensesProvider('v1').future);
    verify(() => expenses.getExpenses('v1')).called(2);
  });

  test('passes the attachment to the use case', () async {
    when(() => expenses.createExpense('v1', any())).thenAnswer((_) async => Right(expense()));
    when(() => expenses.uploadAttachment('v1', 'e1', pdfFile))
        .thenAnswer((_) async => Right(expense(withAttachment: true)));

    final result = await container
        .read(newExpenseControllerProvider.notifier)
        .submit('v1', draft, attachment: pdfFile);

    expect(result, CreateExpenseResult(expense(withAttachment: true)));
  });

  test('an invalid draft ends in InvalidExpenseFailure without a request', () async {
    final result = await container
        .read(newExpenseControllerProvider.notifier)
        .submit('v1', const ExpenseDraft());

    expect(result, isNull);
    expect(container.read(newExpenseControllerProvider).error, isA<InvalidExpenseFailure>());
    verifyNever(() => expenses.createExpense(any(), any()));
  });

  test('a server failure ends in error, and clearError forgets it', () async {
    when(() => expenses.createExpense('v1', any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    expect(await submit(), isNull);
    expect(container.read(newExpenseControllerProvider).error, const NetworkFailure());

    container.read(newExpenseControllerProvider.notifier).clearError();
    expect(container.read(newExpenseControllerProvider).hasError, isFalse);
  });
}
