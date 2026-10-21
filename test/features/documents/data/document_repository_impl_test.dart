import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/documents/data/datasources/document_remote_data_source.dart';
import 'package:car_assistant/features/documents/data/models/document_dto.dart';
import 'package:car_assistant/features/documents/data/models/document_request_dto.dart';
import 'package:car_assistant/features/documents/data/repositories/document_repository_impl.dart';
import 'package:car_assistant/features/documents/domain/entities/document_failures.dart';
import 'package:car_assistant/features/documents/domain/entities/document_field.dart';
import 'package:car_assistant/features/documents/domain/entities/document_input.dart';
import 'package:car_assistant/features/documents/domain/entities/document_type.dart';
import 'package:car_assistant/features/documents/domain/entities/vehicle_document.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../document_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  final input = DocumentInput(
    type: DocumentType.thirdPartyInsurance,
    issuer: 'بیمه ایران',
    number: '124/987432',
    issuedAt: DateTime.utc(2023, 12),
    expiresAt: DateTime.utc(2024, 11, 30),
  );

  group('DTOs', () {
    test('DocumentDto parses the contract sample', () {
      expect(DocumentDto.fromJson(documentJson()).toEntity(), insurance());
    });

    test('a permanent document without files has a null expiry and no files', () {
      final json = documentJson(withFile: false)..['expiresAt'] = null;
      final document = DocumentDto.fromJson(json).toEntity();
      expect(document.expiresAt, isNull);
      expect(document.files, isEmpty);
    });

    test('DocumentRequestDto sends every field, null when absent, dates in UTC', () {
      expect(DocumentRequestDto(input).toJson(), {
        'type': 'third_party_insurance',
        'title': null,
        'issuer': 'بیمه ایران',
        'number': '124/987432',
        'issuedAt': '2023-12-01T00:00:00.000Z',
        'expiresAt': '2024-11-30T00:00:00.000Z',
        'expiryReminder': true,
        'notes': null,
      });
    });
  });

  group('DocumentRepositoryImpl', () {
    late MockDio dio;
    late DocumentRepositoryImpl repository;
    const base = '/api/vehicles/v1/documents';

    setUpAll(() => registerFallbackValue(RequestOptions()));

    setUp(() {
      dio = MockDio();
      repository = DocumentRepositoryImpl(DocumentRemoteDataSource(dio));
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

    test('getDocuments maps the list', () async {
      when(() => dio.get<Map<String, dynamic>>(base)).thenAnswer(
        (_) async => ok({
          'documents': [documentJson()],
        }),
      );

      expect((await repository.getDocuments('v1')).toNullable(), [insurance()]);
    });

    test('createDocument posts the body', () async {
      when(() => dio.post<Map<String, dynamic>>(base, data: any(named: 'data')))
          .thenAnswer((_) async => ok({'document': documentJson()}, 201));

      expect(
        await repository.createDocument('v1', input),
        Right<Failure, VehicleDocument>(insurance()),
      );
      final body =
          verify(() => dio.post<Map<String, dynamic>>(base, data: captureAny(named: 'data')))
                  .captured
                  .single
              as Map<String, dynamic>;
      expect(body['type'], 'third_party_insurance');
    });

    test('updateDocument patches the document', () async {
      when(() => dio.patch<Map<String, dynamic>>('$base/d1', data: any(named: 'data')))
          .thenAnswer((_) async => ok({'document': documentJson()}));

      expect((await repository.updateDocument('v1', 'd1', input)).toNullable(), insurance());
    });

    test('a 400 names the invalid fields', () async {
      when(() => dio.post<Map<String, dynamic>>(base, data: any(named: 'data'))).thenAnswer(
        (_) => httpError(400, {
          'error': {
            'message': 'Invalid input',
            'details': {
              'expiresAt': ['must be after issuedAt'],
            },
          },
        }),
      );

      expect(
        await repository.createDocument('v1', input),
        const Left<Failure, VehicleDocument>(
          InvalidDocumentFailure({DocumentField.expiresAt}, 'Invalid input'),
        ),
      );
    });

    test('deleteDocument answers unit', () async {
      when(() => dio.delete<void>('$base/d1')).thenAnswer((_) async => ok<void>(null, 204));

      expect(await repository.deleteDocument('v1', 'd1'), const Right<Failure, Unit>(unit));
    });

    test('uploadFile posts the multipart field `file`', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '$base/d1/files',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => ok({'document': documentJson()}, 201));

      expect((await repository.uploadFile('v1', 'd1', pdfUpload)).toNullable(), insurance());
      final form =
          verify(
                () => dio.post<Map<String, dynamic>>(
                  '$base/d1/files',
                  data: captureAny(named: 'data'),
                  options: any(named: 'options'),
                ),
              ).captured.single
              as FormData;
      expect(form.files.single.key, 'file');
      expect(form.files.single.value.filename, 'policy.pdf');
    });

    test('upload failures map to 400, 413 and the 5th-file 422', () async {
      for (final (status, failure) in [
        (400, const InvalidAttachmentFailure('x')),
        (413, const AttachmentTooLargeFailure('x')),
        (422, const DocumentFileLimitFailure('x')),
      ]) {
        when(
          () => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) => httpError(status, {
            'error': {
              'message': 'x',
              'details': {
                'file': ['x'],
              },
            },
          }),
        );

        expect(
          await repository.uploadFile('v1', 'd1', pdfUpload),
          Left<Failure, VehicleDocument>(failure),
        );
      }
    });

    test('deleteFile returns the document without it', () async {
      when(() => dio.delete<Map<String, dynamic>>('$base/d1/files/f1'))
          .thenAnswer((_) async => ok({'document': documentJson(withFile: false)}));

      expect(
        (await repository.deleteFile('v1', 'd1', 'f1')).toNullable(),
        insurance(withFile: false),
      );
    });

    test('fetchFile returns the bytes of the url', () async {
      when(() => dio.get<List<int>>(fileUrl, options: any(named: 'options')))
          .thenAnswer((_) async => ok(<int>[1, 2, 3]));

      expect((await repository.fetchFile(fileUrl)).toNullable(), Uint8List.fromList([1, 2, 3]));
    });

    test('a connection error becomes NetworkFailure', () async {
      when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'x'),
        ),
      );

      expect(
        await repository.getDocuments('v1'),
        const Left<Failure, List<VehicleDocument>>(NetworkFailure()),
      );
    });
  });
}
