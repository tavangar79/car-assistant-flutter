import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile_stats.dart';

abstract interface class ProfileRepository {
  /// `GET /api/profile/stats`.
  Future<Either<Failure, ProfileStats>> getStats();
}
