import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/network/api_error_dto.dart';
import '../../domain/entities/attachment_file.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_failures.dart';
import '../../domain/entities/expense_field.dart';
import '../../domain/entities/new_expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_data_source.dart';
import '../models/create_expense_request_dto.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this._remote);

  final ExpenseRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<Expense>>> getExpenses(String vehicleId) => apiCall(
    () async => (await _remote.fetchExpenses(vehicleId)).map((dto) => dto.toEntity()).toList(),
  );

  @override
  Future<Either<Failure, Expense>> createExpense(String vehicleId, NewExpense expense) => apiCall(
    () async =>
        (await _remote.createExpense(vehicleId, CreateExpenseRequestDto(expense))).toEntity(),
    onStatus: _expenseFailure,
  );

  static Failure? _expenseFailure(int status, ApiErrorDto? error) => switch (status) {
    400 => InvalidExpenseFailure(
      fieldsOf(error?.details.keys ?? const []),
      error?.message ?? 'Invalid expense',
    ),
    422 => ExpenseRejectedFailure(error?.message ?? 'Expense rejected'),
    _ => null,
  };

  @override
  Future<Either<Failure, Expense>> uploadAttachment(
    String vehicleId,
    String expenseId,
    AttachmentFile file,
  ) => apiCall(
    () async => (await _remote.uploadAttachment(vehicleId, expenseId, file)).toEntity(),
    onStatus: (status, error) => switch (status) {
      400 => InvalidAttachmentFailure(error?.message ?? 'Invalid attachment'),
      413 => AttachmentTooLargeFailure(error?.message ?? 'Attachment too large'),
      _ => null,
    },
  );

  /// Maps the field names of a 400 `details` body to form fields. Unknown names are ignored.
  static Set<ExpenseField> fieldsOf(Iterable<String> paths) => {
    for (final path in paths) ?_fieldOf(path.split('.').first),
  };

  static ExpenseField? _fieldOf(String key) => switch (key) {
    'category' => ExpenseField.category,
    'amount' => ExpenseField.amount,
    'title' => ExpenseField.title,
    'referenceNumber' => ExpenseField.referenceNumber,
    'paidAt' => ExpenseField.paidAt,
    'expiresAt' => ExpenseField.expiresAt,
    'expiryReminder' => ExpenseField.expiryReminder,
    'paymentMethod' => ExpenseField.paymentMethod,
    'issuer' => ExpenseField.issuer,
    _ => null,
  };
}
