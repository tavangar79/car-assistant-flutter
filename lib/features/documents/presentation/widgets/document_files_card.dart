import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../expenses/domain/entities/attachment_file.dart';
import '../../../expenses/presentation/providers/expense_providers.dart';
import '../../../expenses/presentation/widgets/expense_field.dart';
import '../../../services/presentation/widgets/service_formats.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../domain/entities/document_file.dart';
import '../../domain/entities/document_rules.dart';

/// "فایل‌های مدرک": the saved files (tap to view, remove at once) and the new ones (kept locally,
/// uploaded after the document is saved), then the add tile (the expense file picker) while fewer
/// than four, and the allowed-formats line.
class DocumentFilesCard extends ConsumerStatefulWidget {
  const DocumentFilesCard({
    super.key,
    required this.savedFiles,
    required this.newFiles,
    required this.onAdd,
    required this.onRemoveNew,
    required this.onRemoveSaved,
    required this.onViewSaved,
    this.error,
  });

  final List<DocumentFile> savedFiles;
  final List<AttachmentFile> newFiles;
  final ValueChanged<AttachmentFile> onAdd;
  final ValueChanged<AttachmentFile> onRemoveNew;
  final ValueChanged<DocumentFile> onRemoveSaved;
  final ValueChanged<DocumentFile> onViewSaved;
  final String? error;

  @override
  ConsumerState<DocumentFilesCard> createState() => _DocumentFilesCardState();
}

class _DocumentFilesCardState extends ConsumerState<DocumentFilesCard> {
  bool _pickFailed = false;

  Future<void> _pick() async {
    setState(() => _pickFailed = false);
    try {
      final file = await ref.read(attachmentPickerProvider).pick();
      if (file != null && mounted) widget.onAdd(file);
    } catch (_) {
      if (mounted) setState(() => _pickFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final count = widget.savedFiles.length + widget.newFiles.length;
    return WizardCard(
      child: ExpenseField(
        label: l10n.documentFilesLabel,
        hint: l10n.documentFilesCount(count, DocumentRules.maxFiles),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final file in widget.savedFiles) ...[
              _FileRow(
                name: file.fileName,
                sizeBytes: file.sizeBytes,
                isPdf: file.isPdf,
                onTap: () => widget.onViewSaved(file),
                onRemove: () => widget.onRemoveSaved(file),
              ),
              const SizedBox(height: 8),
            ],
            for (final file in widget.newFiles) ...[
              _FileRow(
                name: file.fileName,
                sizeBytes: file.bytes.length,
                isPdf: file.isPdf,
                onRemove: () => widget.onRemoveNew(file),
              ),
              const SizedBox(height: 8),
            ],
            if (count < DocumentRules.maxFiles)
              Material(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _pick,
                  child: SizedBox(
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_file, size: 20, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          l10n.documentFilesAdd,
                          style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_pickFailed) ...[
              const SizedBox(height: 6),
              AuthErrorText(l10n.expenseAttachmentPickFailed),
            ],
            if (widget.error case final error?) ...[
              const SizedBox(height: 6),
              AuthErrorText(error),
            ],
            const SizedBox(height: 8),
            Text(
              l10n.documentFilesHelp(DocumentRules.maxFiles),
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// A file: PDF or image tile, name, size and kind, and a remove button.
class _FileRow extends StatelessWidget {
  const _FileRow({
    required this.name,
    required this.sizeBytes,
    required this.isPdf,
    required this.onRemove,
    this.onTap,
  });

  final String name;
  final int sizeBytes;
  final bool isPdf;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isPdf ? scheme.errorContainer : scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
                  size: 24,
                  color: isPdf ? scheme.error : scheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textDirection: TextDirection.ltr,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurface),
                    ),
                    Text(
                      l10n.expenseAttachmentMeta(
                        formatMegabytes(sizeBytes, l10n),
                        isPdf ? l10n.expenseAttachmentPdf : l10n.expenseAttachmentImage,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.expenseAttachmentRemove,
                onPressed: onRemove,
                style: IconButton.styleFrom(
                  backgroundColor: scheme.errorContainer.withValues(alpha: 0.4),
                  foregroundColor: scheme.error,
                  minimumSize: const Size(44, 44),
                ),
                icon: const Icon(Icons.delete_outline, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
