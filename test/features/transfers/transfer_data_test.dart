import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/transfers/data/datasources/transfer_remote_data_source.dart';
import 'package:car_assistant/features/transfers/data/models/transfer_dto.dart';
import 'package:car_assistant/features/transfers/data/repositories/transfer_repository_impl.dart';
import 'package:car_assistant/features/transfers/domain/entities/transfer_failures.dart';
import 'package:car_assistant/features/transfers/domain/entities/vehicle_transfer.dart';
import 'package:car_assistant/features/transfers/domain/repositories/transfer_repository.dart';
import 'package:car_assistant/features/transfers/domain/usecases/create_transfer.dart';
import 'package:car_assistant/features/vehicles/data/models/vehicle_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../vehicles/vehicle_fixtures.dart';
import 'transfer_fixtures.dart';

class MockDio extends Mock implements Dio {}

class MockTransferRepository extends Mock implements TransferRepository {}

Response<T> _ok<T>(T? data, [int status = 200]) =>
    Response<T>(requestOptions: RequestOptions(), statusCode: status, data: data);

DioException _status(int status, [String message = 'error']) => DioException.badResponse(
  statusCode: status,
  requestOptions: RequestOptions(),
  response: Response(
    requestOptions: RequestOptions(),
    statusCode: status,
    data: {
      'error': {'message': message},
    },
  ),
);

void main() {
  group('TransferDto', () {
    test('maps the contract sample', () {
      expect(TransferDto.fromJson(transferJson()).toEntity(), transfer());
    });

    test('reads a null sender name and a response date', () {
      final dto = TransferDto.fromJson({
        ...transferJson(fromName: null),
        'status': 'accepted',
        'respondedAt': '2024-11-16T08:00:00.000Z',
      }).toEntity();

      expect(dto.fromName, isNull);
      expect(dto.status, TransferStatus.accepted);
      expect(dto.respondedAt, DateTime.utc(2024, 11, 16, 8));
    });
  });

  group('VehicleDto.ownedSince', () {
    test('is null when absent or null', () {
      expect(VehicleDto.fromJson(vehicleJson()).toEntity().ownedSince, isNull);
      expect(VehicleDto.fromJson({...vehicleJson(), 'ownedSince': null}).ownedSince, isNull);
    });

    test('reads the transfer date', () {
      final vehicle = VehicleDto.fromJson({
        ...vehicleJson(),
        'ownedSince': '2026-10-20T08:00:00.000Z',
      }).toEntity();

      expect(vehicle.ownedSince, DateTime.utc(2026, 10, 20, 8));
    });
  });

  group('TransferList.outgoingFor', () {
    test('finds the pending transfer of a vehicle', () {
      final list = TransferList(outgoing: [transfer()]);

      expect(list.outgoingFor('v1'), transfer());
      expect(list.outgoingFor('v2'), isNull);
    });
  });

  group('CreateTransfer', () {
    late MockTransferRepository repository;

    setUp(() => repository = MockTransferRepository());

    test('sends the phone normalized to 09…', () async {
      when(() => repository.createTransfer(any(), any()))
          .thenAnswer((_) async => Right(transfer()));

      final result = await CreateTransfer(repository)('v1', '+98 912 123 4567');

      expect(result, Right<Failure, VehicleTransfer>(transfer()));
      verify(() => repository.createTransfer('v1', '09121234567')).called(1);
    });

    test('an invalid phone fails without a request', () async {
      final result = await CreateTransfer(repository)('v1', '0912');

      expect(result, const Left<Failure, VehicleTransfer>(InvalidTransferPhoneFailure()));
      verifyZeroInteractions(repository);
    });
  });

  group('TransferRepositoryImpl', () {
    late MockDio dio;
    late TransferRepositoryImpl repository;

    setUp(() {
      dio = MockDio();
      repository = TransferRepositoryImpl(TransferRemoteDataSource(dio));
    });

    void stubCreate(Future<Response<Map<String, dynamic>>> Function() answer) =>
        when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
            .thenAnswer((_) => answer());

    test('createTransfer posts the phone and maps the 201', () async {
      stubCreate(() async => _ok({'transfer': transferJson()}, 201));

      expect(
        await repository.createTransfer('v1', '09121234567'),
        Right<Failure, VehicleTransfer>(transfer()),
      );
      verify(
        () => dio.post<Map<String, dynamic>>(
          '/api/vehicles/v1/transfers',
          data: {'phone': '09121234567'},
        ),
      ).called(1);
    });

    for (final (status, failure) in [
      (400, const InvalidTransferPhoneFailure()),
      (422, const SelfTransferFailure()),
      (409, const TransferAlreadyPendingFailure()),
    ]) {
      test('createTransfer maps a $status', () async {
        stubCreate(() => Future.error(_status(status)));

        expect(
          await repository.createTransfer('v1', '09121234567'),
          Left<Failure, VehicleTransfer>(failure),
        );
      });
    }

    test('getTransfers maps incoming and outgoing', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/transfers')).thenAnswer(
        (_) async => _ok({
          'incoming': [transferJson(id: 'in')],
          'outgoing': [transferJson()],
        }),
      );

      expect(
        await repository.getTransfers(),
        Right<Failure, TransferList>(
          TransferList(
            incoming: [transfer(id: 'in')],
            outgoing: [transfer()],
          ),
        ),
      );
    });

    test('cancel deletes and reject posts', () async {
      when(() => dio.delete<void>(any())).thenAnswer((_) async => _ok<void>(null, 204));
      when(() => dio.post<void>(any())).thenAnswer((_) async => _ok<void>(null, 204));

      expect(await repository.cancelTransfer('t1'), const Right<Failure, Unit>(unit));
      expect(await repository.rejectTransfer('t1'), const Right<Failure, Unit>(unit));
      verify(() => dio.delete<void>('/api/transfers/t1')).called(1);
      verify(() => dio.post<void>('/api/transfers/t1/reject')).called(1);
    });

    test('accept answers the vehicle', () async {
      when(() => dio.post<Map<String, dynamic>>('/api/transfers/t1/accept'))
          .thenAnswer((_) async => _ok({'vehicle': vehicleJson()}));

      expect((await repository.acceptTransfer('t1')).getRight().toNullable()?.id, 'v1');
    });

    test('a 409 on accept carries the server message', () async {
      when(() => dio.post<Map<String, dynamic>>('/api/transfers/t1/accept')).thenAnswer(
        (_) => Future.error(_status(409, 'خودرویی با همین پلاک در گاراژ شما وجود دارد')),
      );

      expect(
        (await repository.acceptTransfer('t1')).getLeft().toNullable(),
        const TransferConflictFailure('خودرویی با همین پلاک در گاراژ شما وجود دارد'),
      );
    });
  });
}
