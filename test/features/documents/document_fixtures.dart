import 'dart:typed_data';

import 'package:car_assistant/features/documents/domain/entities/document_file.dart';
import 'package:car_assistant/features/documents/domain/entities/document_type.dart';
import 'package:car_assistant/features/documents/domain/entities/vehicle_document.dart';
import 'package:car_assistant/features/expenses/domain/entities/attachment_file.dart';

/// Shared document test data, for vehicle `v1` (`tara` in the vehicle fixtures).

const fileUrl = '/api/vehicles/v1/documents/d1/files/f1';

/// The file JSON of the contract sample.
const fileJson = {
  'id': 'f1',
  'fileName': 'policy.pdf',
  'contentType': 'application/pdf',
  'sizeBytes': 1258291,
  'createdAt': '2023-12-01T10:00:00.000Z',
  'url': fileUrl,
};

final policyFile = DocumentFile(
  id: 'f1',
  fileName: 'policy.pdf',
  contentType: 'application/pdf',
  sizeBytes: 1258291,
  createdAt: DateTime.utc(2023, 12, 1, 10),
  url: fileUrl,
);

/// The Document JSON sample of API-PHASE5.md T5.3; [expiresAt] and [withFile] vary it.
Map<String, dynamic> documentJson({
  String expiresAt = '2024-11-30T00:00:00.000Z',
  bool withFile = true,
}) => {
  'id': 'd1',
  'vehicleId': 'v1',
  'type': 'third_party_insurance',
  'title': null,
  'issuer': 'بیمه ایران',
  'number': '124/987432',
  'issuedAt': '2023-12-01T00:00:00.000Z',
  'expiresAt': expiresAt,
  'expiryReminder': true,
  'notes': null,
  'files': [if (withFile) fileJson],
  'createdAt': '2023-12-01T10:00:00.000Z',
  'updatedAt': '2023-12-01T10:00:00.000Z',
};

VehicleDocument insurance({DateTime? expiresAt, bool withFile = true}) => VehicleDocument(
  id: 'd1',
  vehicleId: 'v1',
  type: DocumentType.thirdPartyInsurance,
  issuer: 'بیمه ایران',
  number: '124/987432',
  issuedAt: DateTime.utc(2023, 12),
  expiresAt: expiresAt ?? DateTime.utc(2024, 11, 30),
  expiryReminder: true,
  files: [if (withFile) policyFile],
  createdAt: DateTime.utc(2023, 12, 1, 10),
  updatedAt: DateTime.utc(2023, 12, 1, 10),
);

/// A permanent vehicle card with two photos (front and back).
VehicleDocument vehicleCard() => VehicleDocument(
  id: 'd2',
  vehicleId: 'v1',
  type: DocumentType.vehicleCard,
  title: 'کارت هوشمند خودرو',
  number: 'IRN-847291039401',
  issuedAt: DateTime.utc(2022, 7, 11),
  expiryReminder: true,
  files: [
    DocumentFile(
      id: 'f2',
      fileName: 'front.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 300000,
      createdAt: DateTime.utc(2022, 7, 11),
      url: '/api/vehicles/v1/documents/d2/files/f2',
    ),
    DocumentFile(
      id: 'f3',
      fileName: 'back.jpg',
      contentType: 'image/jpeg',
      sizeBytes: 290000,
      createdAt: DateTime.utc(2022, 7, 11),
      url: '/api/vehicles/v1/documents/d2/files/f3',
    ),
  ],
  createdAt: DateTime.utc(2022, 7, 11),
  updatedAt: DateTime.utc(2022, 7, 11),
);

/// A small PDF for the upload tests.
final pdfUpload = AttachmentFile(
  bytes: Uint8List.fromList(List.filled(1200, 1)),
  fileName: 'policy.pdf',
  mimeType: 'application/pdf',
);
