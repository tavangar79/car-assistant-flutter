import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/dashboard.dart';
import '../repositories/dashboard_repository.dart';

/// The garage dashboard for the Home tab.
class GetDashboard {
  const GetDashboard(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, Dashboard>> call() => _repository.getDashboard();
}
