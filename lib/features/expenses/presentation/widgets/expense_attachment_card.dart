import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../services/presentation/widgets/service_formats.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../domain/entities/attachment_file.dart';
import '../providers/expense_providers.dart';
import 'expense_field.dart';

/// "پیوست سند یا فیش پرداخت": an attach tile that opens the file picker, then the chosen file
/// (PDF or image tile, name, size and kind) with a remove button, and the allowed-formats line.
/// The file is only kept locally; it is uploaded after the expense is saved.
class ExpenseAttachmentCard extends ConsumerStatefulWidget {
  const ExpenseAttachmentCard({super.key, required this.file, required this.onChanged});

  final AttachmentFile? file;
  final ValueChanged<AttachmentFile?> onChanged;

  @override
  ConsumerState<ExpenseAttachmentCard> createState() => _ExpenseAttachmentCardState();
}

class _ExpenseAttachmentCardState extends ConsumerState<ExpenseAttachmentCard> {
  bool _pickFailed = false;

  Future<void> _pick() async {
    setState(() => _pickFailed = false);
    try {
      final file = await ref.read(attachmentPickerProvider).pick();
      if (file != null && mounted) widget.onChanged(file);
    } catch (_) {
      if (mounted) setState(() => _pickFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final file = widget.file;
    return WizardCard(
      child: ExpenseField(
        label: l10n.expenseAttachmentLabel,
        hint: file == null ? l10n.expenseAttachmentNone : l10n.expenseAttachmentAttached,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: file == null ? _attachTile(l10n, theme) : _fileRow(file, l10n, theme),
            ),
            if (_pickFailed) ...[
              const SizedBox(height: 6),
              AuthErrorText(l10n.expenseAttachmentPickFailed),
            ],
            const SizedBox(height: 8),
            Text(
              l10n.expenseAttachmentHelp,
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachTile(AppLocalizations l10n, ThemeData theme) => InkWell(
    onTap: _pick,
    child: SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.attach_file, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            l10n.expenseAttachmentAdd,
            style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    ),
  );

  Widget _fileRow(AttachmentFile file, AppLocalizations l10n, ThemeData theme) {
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: file.isPdf ? scheme.errorContainer : scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              file.isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
              size: 24,
              color: file.isPdf ? scheme.error : scheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.fileName,
                  textDirection: TextDirection.ltr,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurface),
                ),
                Text(
                  l10n.expenseAttachmentMeta(
                    formatMegabytes(file.bytes.length, l10n),
                    file.isPdf ? l10n.expenseAttachmentPdf : l10n.expenseAttachmentImage,
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.expenseAttachmentRemove,
            onPressed: () => widget.onChanged(null),
            style: IconButton.styleFrom(
              backgroundColor: scheme.errorContainer.withValues(alpha: 0.4),
              foregroundColor: scheme.error,
              minimumSize: const Size(44, 44),
            ),
            icon: const Icon(Icons.delete_outline, size: 18),
          ),
        ],
      ),
    );
  }
}
