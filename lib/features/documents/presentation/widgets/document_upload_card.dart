import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/document_file_picker.dart';

/// "بارگذاری مدرک جدید": the upload icon, title and hint, then camera / gallery / PDF buttons.
class DocumentUploadCard extends StatelessWidget {
  const DocumentUploadCard({super.key, required this.onPick});

  final ValueChanged<DocumentFileSource> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.8)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.surfaceContainerHighest),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: scheme.surfaceContainerHigh, shape: BoxShape.circle),
              child: Icon(Icons.upload_file, size: 24, color: scheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.documentsUploadTitle,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.documentsUploadBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: AppTones.of(context).muted),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (final (index, source) in DocumentFileSource.values.indexed) ...[
                  if (index > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _SourceButton(
                      icon: switch (source) {
                        DocumentFileSource.camera => Icons.photo_camera_outlined,
                        DocumentFileSource.gallery => Icons.add_photo_alternate_outlined,
                        DocumentFileSource.pdf => Icons.attach_file,
                      },
                      label: switch (source) {
                        DocumentFileSource.camera => l10n.documentsUploadCamera,
                        DocumentFileSource.gallery => l10n.documentsUploadGallery,
                        DocumentFileSource.pdf => l10n.documentsUploadPdf,
                      },
                      onPressed: () => onPick(source),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({required this.icon, required this.label, required this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: scheme.surfaceContainerLowest,
        foregroundColor: AppTones.of(context).label,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: theme.textTheme.labelMedium,
      ),
      icon: Icon(icon, size: 16, color: scheme.onSurface),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
