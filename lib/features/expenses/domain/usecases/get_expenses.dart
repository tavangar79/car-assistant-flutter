import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// The expenses of a vehicle, newest first.
class GetExpenses {
  const GetExpenses(this._repository);

  final ExpenseRepository _repository;

  Future<Either<Failure, List<Expense>>> call(String vehicleId) =>
      _repository.getExpenses(vehicleId);
}
