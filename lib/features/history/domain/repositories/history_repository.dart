import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/history_query.dart';
import '../entities/history_result.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class HistoryRepository {
  /// One page of the caller's services, fill-ups and expenses matching [query], newest first.
  Future<Either<Failure, HistoryResult>> getHistory(HistoryQuery query);
}
