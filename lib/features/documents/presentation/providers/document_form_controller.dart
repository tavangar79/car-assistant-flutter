import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../expenses/domain/entities/attachment_file.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../domain/entities/document_draft.dart';
import '../../domain/entities/save_document_result.dart';
import '../../domain/entities/vehicle_document.dart';
import 'document_providers.dart';

/// Saves, deletes and trims the document of the form. The state carries loading and the last
/// error (an `InvalidDocumentFailure`, a file failure or any other `Failure`). Every success
/// refreshes the vehicle's documents and the profile count.
class DocumentFormController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Creates (or updates [documentId]) from [draft], then uploads the new [files]. Returns the
  /// result once the document is saved (its `fileFailure` says whether a file was not), or `null`
  /// when nothing was saved.
  Future<SaveDocumentResult?> submit(
    String vehicleId,
    DocumentDraft draft, {
    String? documentId,
    List<AttachmentFile> files = const [],
    int existingFileCount = 0,
  }) => _run(
    vehicleId,
    () => ref
        .read(saveDocumentProvider)
        .call(
          vehicleId,
          draft,
          documentId: documentId,
          files: files,
          existingFileCount: existingFileCount,
        ),
  );

  /// Deletes the document. Returns whether it worked.
  Future<bool> delete(String vehicleId, String documentId) async {
    final deleted = await _run(
      vehicleId,
      () => ref.read(deleteDocumentProvider).call(vehicleId, documentId),
    );
    // Its reminders are deleted with it.
    if (deleted != null) ref.invalidate(unreadNotificationCountProvider);
    return deleted != null;
  }

  /// Removes one saved file. Returns the document without it, or `null` when it failed.
  Future<VehicleDocument?> deleteFile(String vehicleId, String documentId, String fileId) => _run(
    vehicleId,
    () => ref.read(deleteDocumentFileProvider).call(vehicleId, documentId, fileId),
  );

  Future<T?> _run<T>(String vehicleId, Future<Either<Failure, T>> Function() write) async {
    state = const AsyncLoading();
    final result = await write();
    if (!ref.mounted) return null;
    switch (result) {
      case Right(value: final value):
        ref.invalidate(documentsProvider(vehicleId));
        ref.invalidate(profileStatsProvider);
        state = const AsyncData(null);
        return value;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return null;
    }
  }

  /// Forgets the last error, e.g. once the user edits a field.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
