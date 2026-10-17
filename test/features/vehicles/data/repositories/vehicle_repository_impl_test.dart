import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/vehicles/data/datasources/vehicle_remote_data_source.dart';
import 'package:car_assistant/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:car_assistant/features/vehicles/domain/entities/new_vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_failures.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_field.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_photo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicle_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late VehicleRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(Options()));

  setUp(() {
    dio = MockDio();
    repository = VehicleRepositoryImpl(VehicleRemoteDataSource(dio));
  });

  Response<T> ok<T>(T data, [int status = 200]) =>
      Response(requestOptions: RequestOptions(), statusCode: status, data: data);

  Future<Response<T>> httpError<T>(int status, Map<String, dynamic> body) => Future.error(
    DioException.badResponse(
      statusCode: status,
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: status, data: body),
    ),
  );

  Future<Response<T>> offline<T>() => Future.error(
    DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
  );

  const newVehicle = NewVehicle(
    nickname: 'تارا',
    plate: plate,
    makeId: 'iran-khodro',
    modelId: 'tara',
    yearJalali: 1402,
    mileageKm: 34500,
  );
  final photo = VehiclePhoto(bytes: Uint8List.fromList([1, 2, 3]), fileName: 'car.png');

  group('getVehicles', () {
    void stubGet(Future<Response<List<dynamic>>> Function() answer) {
      when(() => dio.get<List<dynamic>>('/api/vehicles')).thenAnswer((_) => answer());
    }

    test('maps API JSON to Vehicle entities', () async {
      stubGet(() async => ok<List<dynamic>>([vehicleJson()]));

      final result = await repository.getVehicles();

      expect(result.getOrElse((f) => throw f), [tara]);
    });

    test('returns a Failure with the server message on a non-2xx response', () async {
      stubGet(
        () => httpError(500, {
          'error': {'message': 'boom'},
        }),
      );

      expect(
        await repository.getVehicles(),
        const Left<Failure, List<Vehicle>>(Failure('HTTP 500: boom')),
      );
    });

    test('returns NetworkFailure when the server is unreachable', () async {
      stubGet(offline);

      expect(await repository.getVehicles(), const Left<Failure, List<Vehicle>>(NetworkFailure()));
    });
  });

  test('getCatalog maps the catalog', () async {
    when(() => dio.get<Map<String, dynamic>>('/api/vehicle-catalog'))
        .thenAnswer((_) async => ok<Map<String, dynamic>>(catalogJson));

    expect((await repository.getCatalog()).getOrElse((f) => throw f), catalog);
  });

  group('createVehicle', () {
    void stubPost(Future<Response<Map<String, dynamic>>> Function() answer) {
      when(() => dio.post<Map<String, dynamic>>('/api/vehicles', data: any(named: 'data')))
          .thenAnswer((_) => answer());
    }

    test('posts the JSON body and returns the saved vehicle', () async {
      stubPost(() async => ok<Map<String, dynamic>>(vehicleJson(), 201));

      final result = await repository.createVehicle(newVehicle);

      expect(result.getOrElse((f) => throw f), tara);
      final body =
          verify(
                () => dio.post<Map<String, dynamic>>(
                  '/api/vehicles',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body['nickname'], 'تارا');
      expect(body['plate'], {
        'twoDigits': '72',
        'letter': 'ب',
        'threeDigits': '345',
        'provinceCode': '68',
      });
      expect(body['makeId'], 'iran-khodro');
    });

    test('maps the dotted 400 details to form fields', () async {
      stubPost(
        () => httpError(400, {
          'error': {
            'message': 'Validation failed',
            'details': {
              'plate.letter': ['Invalid letter'],
              'makeId': ['Unknown make'],
              'yearJalali': ['Too new'],
              'somethingElse': ['ignored'],
            },
          },
        }),
      );

      final result = await repository.createVehicle(newVehicle);

      expect(
        result,
        const Left<Failure, Vehicle>(
          InvalidVehicleFailure({
            VehicleField.plate,
            VehicleField.make,
            VehicleField.year,
          }, 'Validation failed'),
        ),
      );
    });

    test('maps 409 to PlateTakenFailure', () async {
      stubPost(
        () => httpError(409, {
          'error': {'message': 'Plate already registered'},
        }),
      );

      expect(
        await repository.createVehicle(newVehicle),
        const Left<Failure, Vehicle>(PlateTakenFailure()),
      );
    });

    test('returns NetworkFailure when offline', () async {
      stubPost(offline);

      expect(
        await repository.createVehicle(newVehicle),
        const Left<Failure, Vehicle>(NetworkFailure()),
      );
    });
  });

  group('uploadPhoto', () {
    void stubPut(Future<Response<Map<String, dynamic>>> Function() answer) {
      when(
        () => dio.put<Map<String, dynamic>>(
          '/api/vehicles/v1/photo',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) => answer());
    }

    test('PUTs a multipart form with the photo field', () async {
      stubPut(() async => ok<Map<String, dynamic>>(vehicleJson(photoUrl: '/p?v=1')));

      final result = await repository.uploadPhoto('v1', photo);

      expect(result.getOrElse((f) => throw f).photoUrl, '/p?v=1');
      final form =
          verify(
                () => dio.put<Map<String, dynamic>>(
                  '/api/vehicles/v1/photo',
                  data: captureAny(named: 'data'),
                  options: any(named: 'options'),
                ),
              ).captured.single
              as FormData;
      expect(form.files.single.key, 'photo');
      expect(form.files.single.value.filename, 'car.png');
      expect(form.files.single.value.contentType.toString(), 'image/png');
    });

    test('maps 400 to InvalidVehiclePhotoFailure', () async {
      stubPut(
        () => httpError(400, {
          'error': {
            'message': 'Bad type',
            'details': {
              'photo': ['Must be JPEG or PNG'],
            },
          },
        }),
      );

      expect(
        await repository.uploadPhoto('v1', photo),
        const Left<Failure, Vehicle>(InvalidVehiclePhotoFailure('Bad type')),
      );
    });

    test('maps 413 to VehiclePhotoTooLargeFailure', () async {
      stubPut(
        () => httpError(413, {
          'error': {'message': 'File too large'},
        }),
      );

      expect(
        await repository.uploadPhoto('v1', photo),
        const Left<Failure, Vehicle>(VehiclePhotoTooLargeFailure('File too large')),
      );
    });
  });

  test('fetchPhoto returns the image bytes', () async {
    when(() => dio.get<List<int>>('/api/vehicles/v1/photo?v=1', options: any(named: 'options')))
        .thenAnswer((_) async => ok<List<int>>([9, 8, 7]));

    final result = await repository.fetchPhoto('/api/vehicles/v1/photo?v=1');

    expect(result.getOrElse((f) => throw f), Uint8List.fromList([9, 8, 7]));
  });
}
