import '../../../../core/error/failure.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_data_source.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  const VehicleRepositoryImpl(this._remote);

  final VehicleRemoteDataSource _remote;

  @override
  Future<List<Vehicle>> getVehicles() async {
    try {
      final dtos = await _remote.fetchVehicles();
      return dtos.map((dto) => dto.toEntity()).toList();
    } on Failure {
      rethrow;
    } catch (_) {
      throw const Failure('Could not reach the server');
    }
  }
}
