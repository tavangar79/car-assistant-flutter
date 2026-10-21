import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entities/history_query.dart';
import '../../domain/entities/history_result.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';
import '../models/history_query_dto.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl(this._remote);

  final HistoryRemoteDataSource _remote;

  @override
  Future<Either<Failure, HistoryResult>> getHistory(HistoryQuery query) =>
      apiCall(() async => (await _remote.fetchHistory(HistoryQueryDto(query))).toEntity());
}
