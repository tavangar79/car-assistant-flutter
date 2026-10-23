import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../domain/entities/service_visit.dart';
import '../../providers/service_providers.dart';
import '../service_formats.dart';
import 'invoice_viewer_page.dart';

/// "تصویر فیزیکی فاکتور / رسید": the invoice photo with its name, upload date and the
/// full-size viewer, or the attach action when the visit has none.
class ServiceInvoiceCard extends ConsumerWidget {
  const ServiceInvoiceCard({super.key, required this.visit, required this.onAttach});

  final ServiceVisit visit;

  /// `null` disables attaching (a locked record).
  final VoidCallback? onAttach;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final invoice = visit.invoice;
    final url = visit.invoiceUrl;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined, size: 20, color: scheme.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.serviceDetailsInvoiceTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
              if (invoice != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    formatMegabytes(invoice.sizeBytes, l10n),
                    style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (invoice == null || url == null)
            _EmptyInvoice(onAttach: onAttach)
          else
            ref
                .watch(serviceInvoiceBytesProvider(url))
                .when(
                  loading: () => const SizedBox(
                    height: 176,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => SizedBox(
                    height: 96,
                    child: Center(
                      child: Text(
                        l10n.serviceDetailsInvoiceLoadError,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTones.of(context).muted,
                        ),
                      ),
                    ),
                  ),
                  data: (bytes) => _InvoicePreview(
                    bytes: bytes,
                    fileName: invoice.fileName,
                    uploadedAt: invoice.updatedAt,
                    onView: () => InvoiceViewerPage.open(context, bytes, invoice.fileName),
                  ),
                ),
        ],
      ),
    );
  }
}

class _EmptyInvoice extends StatelessWidget {
  const _EmptyInvoice({required this.onAttach});

  /// `null` disables attaching (a locked record).
  final VoidCallback? onAttach;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        Icon(Icons.receipt_long_outlined, size: 40, color: scheme.outline),
        const SizedBox(height: 8),
        Text(
          l10n.serviceDetailsInvoiceEmpty,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppTones.of(context).muted),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onAttach,
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          icon: const Icon(Icons.add_a_photo_outlined, size: 20),
          label: Text(l10n.serviceDetailsInvoiceAttach),
        ),
      ],
    );
  }
}

/// The 176px photo with a dark gradient, the file name and upload date, and the view button.
class _InvoicePreview extends StatelessWidget {
  const _InvoicePreview({
    required this.bytes,
    required this.fileName,
    required this.uploadedAt,
    required this.onView,
  });

  final Uint8List bytes;
  final String fileName;
  final DateTime uploadedAt;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 176,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(
              bytes,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              semanticLabel: l10n.serviceDetailsInvoiceTitle,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    scheme.inverseSurface.withValues(alpha: 0.7),
                    scheme.inverseSurface.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: scheme.onInverseSurface,
                          ),
                        ),
                        Text(
                          l10n.serviceDetailsInvoiceUploaded(
                            formatJalaliDate(uploadedAt.toLocal(), l10n),
                          ),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onInverseSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onView,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 40),
                      backgroundColor: scheme.surfaceContainerLowest.withValues(alpha: 0.9),
                      foregroundColor: scheme.onSurface,
                      textStyle: theme.textTheme.labelSmall,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: Text(l10n.serviceDetailsInvoiceView),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
