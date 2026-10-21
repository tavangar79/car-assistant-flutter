import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/document_remote_data_source.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../domain/entities/vehicle_document.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/usecases/delete_document.dart';
import '../../domain/usecases/delete_document_file.dart';
import '../../domain/usecases/get_document_file.dart';
import '../../domain/usecases/get_documents.dart';
import '../../domain/usecases/save_document.dart';
import 'document_file_picker.dart';
import 'document_file_saver.dart';
import 'document_form_controller.dart';

// Dependency wiring for the documents feature. Override [documentRepositoryProvider] in tests.

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepositoryImpl(DocumentRemoteDataSource(ref.watch(dioProvider)));
});

final getDocumentsProvider = Provider<GetDocuments>((ref) {
  return GetDocuments(ref.watch(documentRepositoryProvider));
});

final saveDocumentProvider = Provider<SaveDocument>((ref) {
  return SaveDocument(ref.watch(documentRepositoryProvider));
});

final deleteDocumentProvider = Provider<DeleteDocument>((ref) {
  return DeleteDocument(ref.watch(documentRepositoryProvider));
});

final deleteDocumentFileProvider = Provider<DeleteDocumentFile>((ref) {
  return DeleteDocumentFile(ref.watch(documentRepositoryProvider));
});

final getDocumentFileProvider = Provider<GetDocumentFile>((ref) {
  return GetDocumentFile(ref.watch(documentRepositoryProvider));
});

final documentFilePickerProvider = Provider<DocumentFilePicker>(
  (ref) => const DocumentFilePicker(),
);

final documentFileSaverProvider = Provider<DocumentFileSaver>((ref) => const DocumentFileSaver());

/// The documents of a vehicle, expiring soonest first.
final documentsProvider = FutureProvider.autoDispose.family<List<VehicleDocument>, String>((
  ref,
  vehicleId,
) async {
  final documents = await ref.watch(getDocumentsProvider).call(vehicleId);
  return documents.getOrElse((failure) => throw failure);
});

/// State of the document form's writes: loading while saving or deleting, and the last error.
final documentFormControllerProvider =
    AsyncNotifierProvider.autoDispose<DocumentFormController, void>(DocumentFormController.new);
