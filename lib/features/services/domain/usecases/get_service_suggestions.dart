import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/service_suggestions.dart';
import '../repositories/service_repository.dart';

/// The workshop and brand names used on earlier visits, for the autocomplete fields.
class GetServiceSuggestions {
  const GetServiceSuggestions(this._repository);

  final ServiceRepository _repository;

  Future<Either<Failure, ServiceSuggestions>> call() => _repository.getSuggestions();
}
