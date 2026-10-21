import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/dashboard.dart';

abstract interface class DashboardRepository {
  /// `GET /api/dashboard`.
  Future<Either<Failure, Dashboard>> getDashboard();
}
