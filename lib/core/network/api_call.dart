import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';
import '../error/network_failure.dart';
import 'api_error_dto.dart';

/// Maps an HTTP error status (and the parsed error body, if any) to a feature-specific [Failure].
/// Return `null` to fall back to a generic [Failure].
typedef StatusFailureMapper = Failure? Function(int status, ApiErrorDto? error);

/// Runs [call] and turns every exception into a [Failure], so data sources can stay simple:
/// - a [Failure] thrown by [call] is kept,
/// - a [DioException] with a response goes through [onStatus] (generic [Failure] otherwise),
/// - a [DioException] without a response (offline, timeout) becomes a [NetworkFailure],
/// - anything else (e.g. a malformed body) becomes a generic [Failure].
Future<Either<Failure, T>> apiCall<T>(
  Future<T> Function() call, {
  StatusFailureMapper? onStatus,
}) async {
  try {
    return Right(await call());
  } on Failure catch (failure) {
    return Left(failure);
  } on DioException catch (exception) {
    return Left(_fromDio(exception, onStatus));
  } catch (error) {
    return Left(Failure('Unexpected error: $error'));
  }
}

Failure _fromDio(DioException exception, StatusFailureMapper? onStatus) {
  final response = exception.response;
  if (response == null) return const NetworkFailure();
  final status = response.statusCode ?? 0;
  final error = ApiErrorDto.tryParse(response.data);
  return onStatus?.call(status, error) ??
      Failure('HTTP $status: ${error?.message ?? 'unexpected response'}');
}
