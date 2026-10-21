import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile_stats.dart';
import '../repositories/profile_repository.dart';

/// The counts shown on the profile page.
class GetProfileStats {
  const GetProfileStats(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfileStats>> call() => _repository.getStats();
}
