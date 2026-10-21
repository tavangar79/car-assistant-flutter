import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/entities/due_report.dart';
import '../../domain/entities/interval_failures.dart';
import '../../domain/entities/interval_setting.dart';
import '../../domain/entities/service_interval.dart';
import '../../domain/repositories/interval_repository.dart';
import '../datasources/interval_remote_data_source.dart';
import '../models/service_interval_dto.dart';
import '../models/set_intervals_request_dto.dart';

class IntervalRepositoryImpl implements IntervalRepository {
  const IntervalRepositoryImpl(this._remote);

  final IntervalRemoteDataSource _remote;

  static List<ServiceInterval> _entities(List<ServiceIntervalDto> dtos) =>
      dtos.map((dto) => dto.toEntity()).toList();

  @override
  Future<Either<Failure, List<ServiceInterval>>> getIntervals(String vehicleId) =>
      apiCall(() async => _entities(await _remote.fetchIntervals(vehicleId)));

  @override
  Future<Either<Failure, List<ServiceInterval>>> setIntervals(
    String vehicleId,
    List<IntervalSetting> settings,
  ) => apiCall(
    () async => _entities(await _remote.setIntervals(vehicleId, SetIntervalsRequestDto(settings))),
    onStatus: (status, error) => switch (status) {
      // `details.intervals` names the bad entries (e.g. `intervals.2.km`); ids are not sent back,
      // so the page shows the message on every card.
      400 => InvalidIntervalsFailure(const {}, error?.message ?? 'Invalid intervals'),
      _ => null,
    },
  );

  @override
  Future<Either<Failure, List<ServiceInterval>>> resetIntervals(String vehicleId) =>
      apiCall(() async => _entities(await _remote.resetIntervals(vehicleId)));

  @override
  Future<Either<Failure, DueReport>> getDue(String vehicleId) =>
      apiCall(() async => (await _remote.fetchDue(vehicleId)).toEntity());
}
