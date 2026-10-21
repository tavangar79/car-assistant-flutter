import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../domain/entities/vehicle_photo.dart';
import '../models/create_vehicle_request_dto.dart';
import '../models/vehicle_catalog_dto.dart';
import '../models/vehicle_dto.dart';

/// HTTP calls for vehicles. Throws [DioException] on a non-2xx response.
class VehicleRemoteDataSource {
  const VehicleRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<VehicleDto>> fetchVehicles() async {
    final response = await _dio.get<List<dynamic>>('/api/vehicles');
    return response.data!.map((json) => VehicleDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<VehicleDto> fetchVehicle(String vehicleId) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/vehicles/$vehicleId');
    return VehicleDto.fromJson(response.data!);
  }

  Future<VehicleCatalogDto> fetchCatalog() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/vehicle-catalog');
    return VehicleCatalogDto.fromJson(response.data!);
  }

  Future<VehicleDto> createVehicle(CreateVehicleRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>('/api/vehicles', data: request.toJson());
    return VehicleDto.fromJson(response.data!);
  }

  /// Sends every field (the same body as [createVehicle]), so the vehicle matches the form.
  Future<VehicleDto> updateVehicle(String vehicleId, CreateVehicleRequestDto request) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/api/vehicles/$vehicleId',
      data: request.toJson(),
    );
    return VehicleDto.fromJson(response.data!);
  }

  /// `multipart/form-data` with the single file field `photo`.
  Future<VehicleDto> uploadPhoto(String vehicleId, VehiclePhoto photo) async {
    final form = FormData.fromMap({
      'photo': MultipartFile.fromBytes(
        photo.bytes,
        filename: photo.fileName,
        contentType: DioMediaType.parse(photo.mimeType ?? imageMimeType(photo.fileName)),
      ),
    });
    final response = await _dio.put<Map<String, dynamic>>(
      '/api/vehicles/$vehicleId/photo',
      data: form,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return VehicleDto.fromJson(response.data!);
  }

  /// Removes the photo of vehicle [vehicleId] and returns the vehicle without it.
  Future<VehicleDto> deletePhoto(String vehicleId) async {
    final response = await _dio.delete<Map<String, dynamic>>('/api/vehicles/$vehicleId/photo');
    return VehicleDto.fromJson(response.data!);
  }

  /// [photoUrl] is the relative path from `Vehicle.photoUrl`; Dio resolves it against the base URL.
  Future<Uint8List> fetchPhoto(String photoUrl) async {
    final response = await _dio.get<List<int>>(
      photoUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  /// The image type for a file name; JPEG unless it ends in `.png`.
  static String imageMimeType(String fileName) =>
      fileName.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
}
