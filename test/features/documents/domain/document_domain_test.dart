import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/documents/domain/entities/document_draft.dart';
import 'package:car_assistant/features/documents/domain/entities/document_failures.dart';
import 'package:car_assistant/features/documents/domain/entities/document_field.dart';
import 'package:car_assistant/features/documents/domain/entities/document_input.dart';
import 'package:car_assistant/features/documents/domain/entities/document_rules.dart';
import 'package:car_assistant/features/documents/domain/entities/document_status.dart';
import 'package:car_assistant/features/documents/domain/entities/document_type.dart';
import 'package:car_assistant/features/documents/domain/entities/save_document_result.dart';
import 'package:car_assistant/features/documents/domain/repositories/document_repository.dart';
import 'package:car_assistant/features/documents/domain/usecases/save_document.dart';
import 'package:car_assistant/features/expenses/domain/entities/attachment_file.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../document_fixtures.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  final issued = DateTime(2023, 12, 1);
  final expires = DateTime(2024, 11, 30);

  group('DocumentStatus', () {
    final now = DateTime(2026, 10, 21, 18, 45);

    test('no expiry is permanent', () {
      expect(DocumentStatus.of(null, now), const DocumentStatus(DocumentStatusKind.permanent));
    });

    test('a past expiry counts the days since', () {
      expect(
        DocumentStatus.of(DateTime(2026, 7, 28), now),
        const DocumentStatus(DocumentStatusKind.expired, 85),
      );
    });

    test('today and up to 15 days are due soon', () {
      expect(DocumentStatus.of(DateTime(2026, 10, 21), now).kind, DocumentStatusKind.dueSoon);
      expect(
        DocumentStatus.of(DateTime(2026, 11, 5), now),
        const DocumentStatus(DocumentStatusKind.dueSoon, 15),
      );
    });

    test('16 to 30 days are upcoming, more is valid', () {
      expect(
        DocumentStatus.of(DateTime(2026, 11, 6), now),
        const DocumentStatus(DocumentStatusKind.upcoming, 16),
      );
      expect(
        DocumentStatus.of(DateTime(2026, 11, 20), now),
        const DocumentStatus(DocumentStatusKind.upcoming, 30),
      );
      expect(
        DocumentStatus.of(DateTime(2027, 1, 3), now),
        const DocumentStatus(DocumentStatusKind.valid, 74),
      );
    });
  });

  group('DocumentRules.validate', () {
    test('trims the text and sends null for empty fields', () {
      final draft = DocumentDraft(
        type: DocumentType.inspection,
        title: '  ',
        issuer: ' مرکز ۴ ',
        issuedAt: issued,
        hasExpiry: true,
        expiresAt: expires,
      );
      expect(
        DocumentRules.validate(draft),
        Right<InvalidDocumentFailure, DocumentInput>(
          DocumentInput(
            type: DocumentType.inspection,
            issuer: 'مرکز ۴',
            issuedAt: issued,
            expiresAt: expires,
          ),
        ),
      );
    });

    test('an expiry turned off is not sent (permanent)', () {
      final draft = DocumentDraft(type: DocumentType.greenSheet, expiresAt: expires);
      expect(DocumentRules.validate(draft).toNullable()!.expiresAt, isNull);
    });

    test('rejects a missing type, long text and a bad expiry', () {
      final draft = DocumentDraft(
        title: 'x' * 101,
        issuer: 'x' * 101,
        number: 'x' * 51,
        notes: 'x' * 501,
        issuedAt: expires,
        hasExpiry: true,
        expiresAt: issued,
      );
      expect(
        DocumentRules.validate(draft),
        const Left<InvalidDocumentFailure, DocumentInput>(
          InvalidDocumentFailure({
            DocumentField.type,
            DocumentField.title,
            DocumentField.issuer,
            DocumentField.number,
            DocumentField.expiresAt,
            DocumentField.notes,
          }),
        ),
      );
    });

    test('an expiry turned on without a date is invalid', () {
      const draft = DocumentDraft(type: DocumentType.inspection, hasExpiry: true);
      expect(DocumentRules.validate(draft).getLeft().toNullable()!.fields, {
        DocumentField.expiresAt,
      });
    });

    test('fromDocument fills the form from a saved document', () {
      final draft = DocumentDraft.fromDocument(insurance());
      expect(draft.type, DocumentType.thirdPartyInsurance);
      expect(draft.issuer, 'بیمه ایران');
      expect(draft.hasExpiry, isTrue);
      expect(draft.title, '');
    });
  });

  group('SaveDocument', () {
    late MockDocumentRepository repository;
    late SaveDocument save;
    const draft = DocumentDraft(type: DocumentType.thirdPartyInsurance, issuer: 'بیمه ایران');
    const input = DocumentInput(type: DocumentType.thirdPartyInsurance, issuer: 'بیمه ایران');

    setUpAll(() {
      registerFallbackValue(input);
      registerFallbackValue(pdfUpload);
    });

    setUp(() {
      repository = MockDocumentRepository();
      save = SaveDocument(repository);
      when(() => repository.createDocument('v1', input))
          .thenAnswer((_) async => Right(insurance(withFile: false)));
      when(() => repository.updateDocument('v1', 'd1', input))
          .thenAnswer((_) async => Right(insurance(withFile: false)));
      when(() => repository.uploadFile('v1', 'd1', any()))
          .thenAnswer((_) async => Right(insurance()));
    });

    test('creates the document, then uploads its files', () async {
      final result = await save('v1', draft, files: [pdfUpload]);

      expect(result, Right<Failure, SaveDocumentResult>(SaveDocumentResult(insurance())));
      verify(() => repository.uploadFile('v1', 'd1', pdfUpload)).called(1);
    });

    test('updates an existing document', () async {
      final result = await save('v1', draft, documentId: 'd1');

      expect(result.toNullable()!.document, insurance(withFile: false));
      verifyNever(() => repository.createDocument(any(), any()));
    });

    test('a failed upload still saves the document, with the failure', () async {
      when(() => repository.uploadFile('v1', 'd1', any()))
          .thenAnswer((_) async => const Left(DocumentFileLimitFailure()));

      final result = await save('v1', draft, files: [pdfUpload, pdfUpload]);

      expect(
        result,
        Right<Failure, SaveDocumentResult>(
          SaveDocumentResult(
            insurance(withFile: false),
            fileFailure: const DocumentFileLimitFailure(),
          ),
        ),
      );
      verify(() => repository.uploadFile('v1', 'd1', any())).called(1);
    });

    test('more than four files in all are refused before sending', () async {
      final result = await save('v1', draft, files: [pdfUpload, pdfUpload], existingFileCount: 3);

      expect(result, const Left<Failure, SaveDocumentResult>(DocumentFileLimitFailure()));
      verifyZeroInteractions(repository);
    });

    test('a wrong type or a too large file is refused before sending', () async {
      final text = AttachmentFile(
        bytes: Uint8List.fromList([1]),
        fileName: 'a.txt',
        mimeType: 'text/plain',
      );
      final big = AttachmentFile(
        bytes: Uint8List(AttachmentFile.maxBytes + 1),
        fileName: 'big.pdf',
      );

      expect(
        await save('v1', draft, files: [text]),
        const Left<Failure, SaveDocumentResult>(InvalidAttachmentFailure()),
      );
      expect(
        await save('v1', draft, files: [big]),
        const Left<Failure, SaveDocumentResult>(AttachmentTooLargeFailure()),
      );
      verifyZeroInteractions(repository);
    });

    test('an invalid draft is refused before sending', () async {
      final result = await save('v1', const DocumentDraft());

      expect(
        result,
        const Left<Failure, SaveDocumentResult>(InvalidDocumentFailure({DocumentField.type})),
      );
      verifyZeroInteractions(repository);
    });
  });
}
