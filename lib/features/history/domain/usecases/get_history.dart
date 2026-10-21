import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/history_categories.dart';
import '../entities/history_filter.dart';
import '../entities/history_query.dart';
import '../entities/history_result.dart';
import '../repositories/history_repository.dart';

/// One page of the history for a [HistoryFilter], its period resolved at `now`. Without a cursor
/// the result carries the summary of the whole filtered set.
class GetHistory {
  const GetHistory(this._repository, {required this.now});

  final HistoryRepository _repository;

  /// The clock the period is resolved with.
  final DateTime Function() now;

  Future<Either<Failure, HistoryResult>> call(
    HistoryFilter filter, {
    String? cursor,
    int limit = HistoryQuery.defaultLimit,
  }) {
    final (from, to) = filter.range(now());
    return _repository.getHistory(
      HistoryQuery(
        vehicleIds: filter.vehicleIds.toList(),
        type: filter.type,
        categories: [
          for (final category in HistoryCategories.all)
            if (filter.categories.contains(category)) category,
        ],
        attachmentsOnly: filter.attachmentsOnly,
        from: from,
        to: to,
        cursor: cursor,
        limit: limit,
      ),
    );
  }
}
