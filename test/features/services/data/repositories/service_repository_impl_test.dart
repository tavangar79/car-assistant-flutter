import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/services/data/datasources/service_remote_data_source.dart';
import 'package:car_assistant/features/services/data/repositories/service_repository_impl.dart';
import 'package:car_assistant/features/services/domain/entities/invoice_file.dart';
import 'package:car_assistant/features/services/domain/entities/new_service_visit.dart';
import 'package:car_assistant/features/services/domain/entities/service_failures.dart';
import 'package:car_assistant/features/services/domain/entities/service_field.dart';
import 'package:car_assistant/features/services/domain/entities/service_suggestions.dart';
import 'package:car_assistant/features/services/domain/entities/service_visit.dart';
import 'package:car_assistant/features/services/domain/entities/service_visit_update.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../service_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late ServiceRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(RequestOptions()));

  setUp(() {
    dio = MockDio();
    repository = ServiceRepositoryImpl(ServiceRemoteDataSource(dio));
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

  final newVisit = NewServiceVisit(
    serviceDate: DateTime.utc(2026, 10, 20, 10, 30),
    odometerKm: 34850,
    workshop: 'اتوسرویس البرز',
    lineItems: const [oilLine, filterLine],
  );

  test('getSuggestions maps the workshops and the brands per item', () async {
    when(() => dio.get<Map<String, dynamic>>('/api/service-suggestions')).thenAnswer(
      (_) async => ok({
        'workshops': ['اتوسرویس البرز', 'تعمیرگاه مرکزی'],
        'brands': {
          'engine_oil': ['بهران رانا 5W-40', 'الف'],
          'oil_filter': ['سرکان'],
        },
      }),
    );

    expect(
      (await repository.getSuggestions()).getOrElse((f) => throw f),
      const ServiceSuggestions(
        workshops: ['اتوسرویس البرز', 'تعمیرگاه مرکزی'],
        brands: {
          'engine_oil': ['بهران رانا 5W-40', 'الف'],
          'oil_filter': ['سرکان'],
        },
      ),
    );
  });

  test('getCatalog maps the categories', () async {
    when(() => dio.get<Map<String, dynamic>>('/api/service-items'))
        .thenAnswer((_) async => ok(catalogJson));

    expect((await repository.getCatalog()).getOrElse((f) => throw f), serviceCatalog);
  });

  test('getCatalog for a vehicle sends ?vehicleId= and maps disabled items', () async {
    when(
      () =>
          dio.get<Map<String, dynamic>>('/api/service-items', queryParameters: {'vehicleId': 'v1'}),
    ).thenAnswer(
      (_) async => ok({
        'categories': [
          {
            'id': 'fluids',
            'title': 'روغن و مایعات مصرفی',
            'items': [
              {
                'id': 'engine_oil',
                'title': 'روغن موتور',
                'subtitle': 'تعویض و فلاش',
                'icon': 'oil_barrel',
                'disabled': true,
              },
            ],
          },
        ],
      }),
    );

    final catalog = (await repository.getCatalog(vehicleId: 'v1')).getOrElse((f) => throw f);

    expect(catalog.single.items.single.disabled, isTrue);
  });

  test('getCatalog maps a 404 for a foreign vehicle to a failure', () async {
    when(
      () =>
          dio.get<Map<String, dynamic>>('/api/service-items', queryParameters: {'vehicleId': 'v9'}),
    ).thenAnswer(
      (_) => httpError(404, {
        'error': {'message': 'not found'},
      }),
    );

    expect((await repository.getCatalog(vehicleId: 'v9')).isLeft(), isTrue);
  });

  test('getVisits maps the services envelope', () async {
    when(() => dio.get<Map<String, dynamic>>('/api/vehicles/v1/services')).thenAnswer(
      (_) async => ok({
        'services': [visitJson()],
      }),
    );

    expect((await repository.getVisits('v1')).getOrElse((f) => throw f), [visit()]);
  });

  test('getVisit maps the service envelope and 404 to a generic Failure', () async {
    when(() => dio.get<Map<String, dynamic>>('/api/vehicles/v1/services/s1'))
        .thenAnswer((_) async => ok({'service': visitJson(withInvoice: true)}));
    expect(
      (await repository.getVisit('v1', 's1')).getOrElse((f) => throw f),
      visit(withInvoice: true),
    );

    when(() => dio.get<Map<String, dynamic>>('/api/vehicles/v1/services/s1')).thenAnswer(
      (_) => httpError(404, {
        'error': {'message': 'Not found'},
      }),
    );
    expect(
      await repository.getVisit('v1', 's1'),
      const Left<Failure, ServiceVisit>(Failure('HTTP 404: Not found')),
    );
  });

  group('createVisit', () {
    const path = '/api/vehicles/v1/services';

    void stubPost(Future<Response<Map<String, dynamic>>> Function() answer) {
      when(() => dio.post<Map<String, dynamic>>(path, data: any(named: 'data')))
          .thenAnswer((_) => answer());
    }

    test('posts the contract body and maps the 201 envelope', () async {
      stubPost(() async => ok({'service': visitJson()}, 201));

      final result = await repository.createVisit('v1', newVisit);

      expect(result, Right<Failure, ServiceVisit>(visit()));
      verify(
        () => dio.post<Map<String, dynamic>>(
          path,
          data: {
            'serviceDate': '2026-10-20T10:30:00.000Z',
            'odometerKm': 34850,
            'workshop': 'اتوسرویس البرز',
            'notes': null,
            'lineItems': [oilLineJson, filterLineJson],
          },
        ),
      ).called(1);
    });

    test('maps 400 details to InvalidServiceFailure fields', () async {
      stubPost(
        () => httpError(400, {
          'error': {
            'message': 'Validation failed',
            'details': {
              'workshop': ['Required'],
              'lineItems.0.cost': ['Must be >= 0'],
            },
          },
        }),
      );

      expect(
        await repository.createVisit('v1', newVisit),
        const Left<Failure, ServiceVisit>(
          InvalidServiceFailure({
            ServiceField.workshop,
            ServiceField.lineItems,
          }, 'Validation failed'),
        ),
      );
    });

    test('maps 422 to ServiceRejectedFailure with the server message', () async {
      stubPost(
        () => httpError(422, {
          'error': {'message': 'serviceDate is in the future'},
        }),
      );

      expect(
        await repository.createVisit('v1', newVisit),
        const Left<Failure, ServiceVisit>(ServiceRejectedFailure('serviceDate is in the future')),
      );
    });

    test('maps a connection error to NetworkFailure', () async {
      stubPost(
        () => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
        ),
      );

      expect(
        await repository.createVisit('v1', newVisit),
        const Left<Failure, ServiceVisit>(NetworkFailure()),
      );
    });
  });

  test('updateVisit patches only the given fields', () async {
    when(
      () =>
          dio.patch<Map<String, dynamic>>('/api/vehicles/v1/services/s1', data: any(named: 'data')),
    ).thenAnswer(
      (_) async => ok({
        'service': visitJson(lines: [filterLineJson]),
      }),
    );

    final result = await repository.updateVisit(
      'v1',
      's1',
      const ServiceVisitUpdate(lineItems: [filterLine]),
    );

    expect(result, Right<Failure, ServiceVisit>(visit(lines: const [filterLine])));
    verify(
      () => dio.patch<Map<String, dynamic>>(
        '/api/vehicles/v1/services/s1',
        data: {
          'lineItems': [filterLineJson],
        },
      ),
    ).called(1);
  });

  test('deleteVisit returns unit on 204', () async {
    when(() => dio.delete<void>('/api/vehicles/v1/services/s1'))
        .thenAnswer((_) async => ok(null, 204));

    expect(await repository.deleteVisit('v1', 's1'), const Right<Failure, Unit>(unit));
  });

  group('uploadInvoice', () {
    const path = '/api/vehicles/v1/services/s1/invoice';
    final file = InvoiceFile(bytes: Uint8List.fromList([1, 2, 3]), fileName: 'فاکتور.jpg');

    test('puts multipart data and maps the envelope', () async {
      when(
        () => dio.put<Map<String, dynamic>>(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => ok({'service': visitJson(withInvoice: true)}));

      final result = await repository.uploadInvoice('v1', 's1', file);

      expect(result, Right<Failure, ServiceVisit>(visit(withInvoice: true)));
      final form =
          verify(
                () => dio.put<Map<String, dynamic>>(
                  path,
                  data: captureAny(named: 'data'),
                  options: any(named: 'options'),
                ),
              ).captured.single
              as FormData;
      expect(form.files.single.key, 'invoice');
      expect(form.files.single.value.filename, 'فاکتور.jpg');
    });

    test('maps 413 to InvoiceTooLargeFailure and 400 to InvalidInvoiceFailure', () async {
      when(
        () => dio.put<Map<String, dynamic>>(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) => httpError(413, {
          'error': {'message': 'Too large'},
        }),
      );
      expect(
        await repository.uploadInvoice('v1', 's1', file),
        const Left<Failure, ServiceVisit>(InvoiceTooLargeFailure('Too large')),
      );

      when(
        () => dio.put<Map<String, dynamic>>(
          path,
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) => httpError(400, {
          'error': {'message': 'Not an image'},
        }),
      );
      expect(
        await repository.uploadInvoice('v1', 's1', file),
        const Left<Failure, ServiceVisit>(InvalidInvoiceFailure('Not an image')),
      );
    });
  });

  test('fetchInvoice returns the bytes', () async {
    when(() => dio.get<List<int>>('/x/invoice', options: any(named: 'options')))
        .thenAnswer((_) async => ok([1, 2]));

    expect((await repository.fetchInvoice('/x/invoice')).getOrElse((f) => throw f), [1, 2]);
  });
}
