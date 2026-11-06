import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/user_blocked_failure.dart';
import 'package:car_assistant/core/network/api_call.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

const _blockedMessage = 'حساب کاربری شما مسدود شده است. با پشتیبانی تماس بگیرید.';

DioException _httpError(int status, Map<String, dynamic> error) => DioException.badResponse(
  statusCode: status,
  requestOptions: RequestOptions(),
  response: Response(requestOptions: RequestOptions(), statusCode: status, data: {'error': error}),
);

void main() {
  test(
    'a 403 user_blocked becomes UserBlockedFailure with the server message, before onStatus',
    () async {
      var mapperCalled = false;
      final result = await apiCall<int>(
        () => Future.error(
          _httpError(403, {
            'message': _blockedMessage,
            'details': {'code': 'user_blocked'},
          }),
        ),
        onStatus: (_, _) {
          mapperCalled = true;
          return const Failure('mapped');
        },
      );

      expect(result, const Left<Failure, int>(UserBlockedFailure(_blockedMessage)));
      expect(mapperCalled, isFalse);
    },
  );

  test('another 403 keeps going through onStatus, or to a generic Failure', () async {
    Future<Either<Failure, int>> call({StatusFailureMapper? onStatus}) => apiCall<int>(
      () => Future.error(
        _httpError(403, {
          'message': 'Forbidden',
          'details': {'code': 'not_owner'},
        }),
      ),
      onStatus: onStatus,
    );

    expect(await call(), const Left<Failure, int>(Failure('HTTP 403: Forbidden')));
    expect(
      await call(onStatus: (status, _) => status == 403 ? const Failure('mapped') : null),
      const Left<Failure, int>(Failure('mapped')),
    );
  });
}
