import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/failure.dart';
import '../models/vehicle_dto.dart';

class VehicleRemoteDataSource {
  const VehicleRemoteDataSource({required this._client, required this._baseUrl});

  final http.Client _client;
  final String _baseUrl;

  Future<List<VehicleDto>> fetchVehicles() async {
    final response = await _client.get(Uri.parse('$_baseUrl/api/vehicles'));
    if (response.statusCode != 200) {
      throw Failure('Could not load vehicles (HTTP ${response.statusCode})');
    }
    final body = jsonDecode(response.body) as List<dynamic>;
    return body.map((json) => VehicleDto.fromJson(json as Map<String, dynamic>)).toList();
  }
}
