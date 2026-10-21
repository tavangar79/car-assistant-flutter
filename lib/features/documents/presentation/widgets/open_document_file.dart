import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../services/presentation/widgets/details/invoice_viewer_page.dart';
import '../../domain/entities/document_file.dart';
import '../providers/document_providers.dart';

/// "مشاهده اصل فایل": loads the bytes of [file] with the bearer token, then shows an image in the
/// full-screen viewer or hands a PDF to the platform. A failure shows a snackbar.
Future<void> openDocumentFile(BuildContext context, WidgetRef ref, DocumentFile file) async {
  final messenger = ScaffoldMessenger.of(context);
  final failed = SnackBar(content: Text(AppLocalizations.of(context).documentFileOpenFailed));
  final saver = ref.read(documentFileSaverProvider);
  final bytes = (await ref.read(getDocumentFileProvider).call(file.url)).toNullable();
  if (!context.mounted) return;
  if (bytes == null) {
    messenger.showSnackBar(failed);
  } else if (file.isPdf) {
    try {
      await saver.save(bytes, file);
    } catch (_) {
      messenger.showSnackBar(failed);
    }
  } else {
    await InvoiceViewerPage.open(context, bytes, file.fileName);
  }
}
