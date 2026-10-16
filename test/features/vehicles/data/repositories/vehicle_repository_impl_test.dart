import 'dart:convert';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/vehicles/data/datasources/vehicle_remote_data_source.dart';
import 'package:car_assistant/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

VehicleRepositoryImpl buildRepository(MockClientHandler handler) {
  final remote = VehicleRemoteDataSource(client: MockClient(handler), baseUrl: 'http://api.test');
  return VehicleRepositoryImpl(remote);
}

void main() {
  test('maps API JSON to Vehicle entities', () async {
    final repository = buildRepository((request) async {
      expect(request.url.toString(), 'http://api.test/api/vehicles');
      return http.Response(
        jsonEncode([
          {'id': 'a1', 'make': 'Kia', 'model': 'Rio', 'year': 2021, 'mileageKm': 500},
        ]),
        200,
      );
    });

    final vehicles = await repository.getVehicles();

    expect(vehicles, [
      const Vehicle(id: 'a1', make: 'Kia', model: 'Rio', year: 2021, mileageKm: 500),
    ]);
  });

  test('throws Failure on a non-200 response', () async {
    final repository = buildRepository((_) async => http.Response('oops', 500));

    expect(repository.getVehicles(), throwsA(isA<Failure>()));
  });

  test('throws Failure when the server is unreachable', () async {
    final repository = buildRepository((_) async => throw http.ClientException('offline'));

    expect(repository.getVehicles(), throwsA(const Failure('Could not reach the server')));
  });
}
