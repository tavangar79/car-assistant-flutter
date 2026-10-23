import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/report_failures.dart';
import '../../domain/entities/report_query.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_data_source.dart';
import '../models/report_query_dto.dart';

class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl(this._remote);

  final ReportRemoteDataSource _remote;

  @override
  Future<Either<Failure, Report>> getReport(ReportQuery query) => apiCall(
    () async => (await _remote.fetchReport(ReportQueryDto(query))).toEntity(),
    onStatus: (status, _) => status == 422 ? const ReportTooLargeFailure() : null,
  );

  @override
  Future<Either<Failure, Uint8List>> getFile(String url) => apiCall(() => _remote.fetchFile(url));
}
