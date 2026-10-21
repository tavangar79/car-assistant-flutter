import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

/// "مشاهده در ابعاد کامل": the invoice photo on a dark full-screen page, pinch-zoomable.
class InvoiceViewerPage extends StatelessWidget {
  const InvoiceViewerPage({super.key, required this.bytes, required this.fileName});

  final Uint8List bytes;
  final String fileName;

  static Future<void> open(BuildContext context, Uint8List bytes, String fileName) =>
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => InvoiceViewerPage(bytes: bytes, fileName: fileName),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: scheme.inverseSurface,
      appBar: AppBar(
        backgroundColor: scheme.inverseSurface,
        foregroundColor: scheme.onInverseSurface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: l10n.quickActionsClose,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: Text(
          fileName,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 5,
          child: Image.memory(
            bytes,
            fit: BoxFit.contain,
            semanticLabel: l10n.serviceDetailsInvoiceTitle,
          ),
        ),
      ),
    );
  }
}
