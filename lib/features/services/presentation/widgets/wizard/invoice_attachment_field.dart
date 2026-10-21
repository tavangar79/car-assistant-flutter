import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../domain/entities/invoice_file.dart';
import '../../providers/invoice_picker.dart';
import '../../providers/service_providers.dart';
import '../service_formats.dart';
import 'wizard_field.dart';

/// "تصویر فاکتور و رسید سرویس": an attach tile that opens gallery / camera options, then the
/// chosen [invoice] as a 64px thumb with its name and size, and change / remove buttons.
/// The file is only kept locally; it is uploaded after the visit is saved.
class InvoiceAttachmentField extends ConsumerStatefulWidget {
  const InvoiceAttachmentField({super.key, required this.invoice, required this.onChanged});

  final InvoiceFile? invoice;
  final ValueChanged<InvoiceFile?> onChanged;

  /// Lets the user pick an invoice from the gallery or the camera; `null` when cancelled.
  /// Throws when the source is unavailable.
  static Future<InvoiceFile?> pick(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<InvoiceSource>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              minTileHeight: 64,
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.serviceInvoiceGallery),
              onTap: () => Navigator.of(context).pop(InvoiceSource.gallery),
            ),
            ListTile(
              minTileHeight: 64,
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.serviceInvoiceCamera),
              onTap: () => Navigator.of(context).pop(InvoiceSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return null;
    return ref.read(invoicePickerProvider).pick(source);
  }

  @override
  ConsumerState<InvoiceAttachmentField> createState() => _InvoiceAttachmentFieldState();
}

class _InvoiceAttachmentFieldState extends ConsumerState<InvoiceAttachmentField> {
  bool _pickFailed = false;

  Future<void> _pick() async {
    setState(() => _pickFailed = false);
    try {
      final invoice = await InvoiceAttachmentField.pick(context, ref);
      if (invoice != null && mounted) widget.onChanged(invoice);
    } catch (_) {
      if (mounted) setState(() => _pickFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final invoice = widget.invoice;
    return WizardField(
      label: l10n.serviceInvoiceLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: invoice == null
                ? InkWell(
                    onTap: _pick,
                    child: SizedBox(
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 20,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.serviceInvoiceAttach,
                            style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurface),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            invoice.bytes,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                            semanticLabel: l10n.serviceInvoiceLabel,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                invoice.fileName,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: scheme.onSurface,
                                ),
                              ),
                              Text(
                                l10n.serviceInvoiceAttached(
                                  formatMegabytes(invoice.bytes.length, l10n),
                                ),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.serviceInvoiceChange,
                          onPressed: _pick,
                          color: scheme.onSurfaceVariant,
                          icon: const Icon(Icons.edit, size: 20),
                        ),
                        IconButton(
                          tooltip: l10n.serviceInvoiceRemove,
                          onPressed: () => widget.onChanged(null),
                          color: scheme.error,
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),
                  ),
          ),
          if (_pickFailed) ...[
            const SizedBox(height: 6),
            AuthErrorText(l10n.serviceInvoicePickFailed),
          ],
        ],
      ),
    );
  }
}
