import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../data/datasources/expense_remote_data_source.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/usecases/create_expense.dart';
import '../../domain/usecases/get_expenses.dart';
import 'attachment_picker.dart';
import 'new_expense_controller.dart';

// Dependency wiring for the expenses feature. Override [expenseRepositoryProvider] in tests.

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ExpenseRemoteDataSource(ref.watch(dioProvider)));
});

final getExpensesProvider = Provider<GetExpenses>((ref) {
  return GetExpenses(ref.watch(expenseRepositoryProvider));
});

final createExpenseProvider = Provider<CreateExpense>((ref) {
  return CreateExpense(ref.watch(expenseRepositoryProvider), now: ref.watch(clockProvider));
});

final attachmentPickerProvider = Provider<AttachmentPicker>((ref) => const AttachmentPicker());

/// The expenses of a vehicle, newest first.
final expensesProvider = FutureProvider.autoDispose.family<List<Expense>, String>((
  ref,
  vehicleId,
) async {
  final expenses = await ref.watch(getExpensesProvider).call(vehicleId);
  return expenses.getOrElse((failure) => throw failure);
});

/// State of the expense form's submit: loading while saving, and the last error.
final newExpenseControllerProvider = AsyncNotifierProvider.autoDispose<NewExpenseController, void>(
  NewExpenseController.new,
);
