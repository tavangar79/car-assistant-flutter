import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/invoice_file.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_failures.dart';
import '../../domain/entities/service_item.dart';
import '../../domain/entities/service_line_item.dart';
import '../../domain/entities/service_visit.dart';
import '../providers/service_providers.dart';
import '../widgets/details/line_item_editor_sheet.dart';
import '../widgets/details/service_header_card.dart';
import '../widgets/details/service_invoice_card.dart';
import '../widgets/details/service_item_picker_sheet.dart';
import '../widgets/details/service_line_row.dart';
import '../widgets/details/service_total_card.dart';
import '../widgets/wizard/invoice_attachment_field.dart';

/// "جزئیات فاکتور سرویس" (Stitch `ca8a1402532c42dcb345e55f5e855068`): the read-only header, the
/// editable items, the invoice photo and the totals. The app bar menu deletes the visit.
/// Payment method, tracking code, print, share and PDF are not in the API: the PDF button is
/// shown disabled and the rest left out.
class ServiceDetailsPage extends ConsumerWidget {
  const ServiceDetailsPage({super.key, required this.vehicleId, required this.serviceId});

  final String vehicleId;
  final String serviceId;

  ServiceRef get _ref => ServiceRef(vehicleId, serviceId);

  Future<void> _deleteVisit(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmed = await _confirm(
      context,
      title: l10n.serviceDetailsDeleteConfirmTitle,
      body: l10n.serviceDetailsDeleteConfirmBody,
    );
    if (!confirmed || !context.mounted) return;
    final deleted = await ref.read(serviceDetailsControllerProvider.notifier).deleteVisit(_ref);
    messenger.showSnackBar(
      SnackBar(
        content: Text(deleted ? l10n.serviceDetailsDeleted : l10n.serviceDetailsDeleteFailed),
      ),
    );
    if (deleted) navigator.maybePop();
  }

  Future<void> _saveLines(BuildContext context, WidgetRef ref, List<ServiceLineItem> lines) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final saved = await ref
        .read(serviceDetailsControllerProvider.notifier)
        .saveLineItems(_ref, lines);
    messenger.showSnackBar(
      SnackBar(content: Text(saved ? l10n.serviceDetailsUpdated : l10n.serviceDetailsUpdateFailed)),
    );
  }

  Future<void> _editLine(
    BuildContext context,
    WidgetRef ref,
    ServiceVisit visit,
    ServiceItem item,
    ServiceLineItem? current,
  ) async {
    final edited = await LineItemEditorSheet.show(
      context,
      item: item,
      baseKm: visit.odometerKm,
      baseDate: visit.serviceDate.toLocal(),
      brandSuggestions: ref.read(serviceSuggestionsProvider).value?.brandsFor(item.id) ?? const [],
      initial: current,
    );
    if (edited == null || !context.mounted) return;
    final lines = [
      for (final line in visit.lineItems) line.itemId == edited.itemId ? edited : line,
      if (current == null) edited,
    ];
    await _saveLines(context, ref, lines);
  }

  Future<void> _addLine(
    BuildContext context,
    WidgetRef ref,
    ServiceVisit visit,
    List<ServiceCategory> catalog,
  ) async {
    final item = await ServiceItemPickerSheet.show(
      context,
      categories: catalog,
      excludeIds: {for (final line in visit.lineItems) line.itemId},
    );
    if (item == null || !context.mounted) return;
    await _editLine(context, ref, visit, item, null);
  }

  Future<void> _deleteLine(
    BuildContext context,
    WidgetRef ref,
    ServiceVisit visit,
    ServiceLineItem line,
    String title,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (visit.lineItems.length == 1) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.serviceDetailsLastItem)));
      return;
    }
    final confirmed = await _confirm(
      context,
      title: l10n.serviceDetailsDeleteItemConfirmTitle(title),
      body: l10n.serviceDetailsDeleteItemConfirmBody,
    );
    if (!confirmed || !context.mounted) return;
    await _saveLines(context, ref, [
      for (final other in visit.lineItems)
        if (other.itemId != line.itemId) other,
    ]);
  }

  Future<void> _attachInvoice(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    InvoiceFile? invoice;
    try {
      invoice = await InvoiceAttachmentField.pick(context, ref);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.serviceInvoicePickFailed)));
      return;
    }
    if (invoice == null || !context.mounted) return;
    final saved = await ref
        .read(serviceDetailsControllerProvider.notifier)
        .uploadInvoice(_ref, invoice);
    final message = saved
        ? l10n.serviceDetailsInvoiceSaved
        : switch (ref.read(serviceDetailsControllerProvider).error) {
            InvoiceTooLargeFailure() => l10n.serviceInvoiceTooLarge(InvoiceFile.maxMegabytes),
            InvalidInvoiceFailure() => l10n.serviceInvoiceInvalid,
            _ => l10n.serviceDetailsInvoiceSaveFailed,
          };
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String body,
  }) async {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.vehicleCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            child: Text(l10n.confirmDelete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final visit = ref.watch(serviceVisitProvider(_ref));
    final busy = ref.watch(serviceDetailsControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        scrolledUnderElevation: 1,
        shadowColor: scheme.shadow.withValues(alpha: 0.04),
        leading: IconButton(
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.serviceDetailsEyebrow,
              style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
            ),
            Text(
              l10n.serviceDetailsTitle,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          if (visit.hasValue)
            PopupMenuButton<VoidCallback>(
              tooltip: l10n.serviceDetailsOptions,
              icon: const Icon(Icons.more_vert),
              color: scheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (action) => action(),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: () => _deleteVisit(context, ref),
                  enabled: !busy,
                  height: 48,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20, color: scheme.error),
                      const SizedBox(width: 12),
                      Text(
                        l10n.serviceDetailsDelete,
                        style: theme.textTheme.labelMedium?.copyWith(color: scheme.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: visit.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(
          message: l10n.serviceDetailsLoadError,
          onRetry: () => ref.invalidate(serviceVisitProvider(_ref)),
        ),
        data: (visit) => _Body(
          visit: visit,
          busy: busy,
          onEditLine: (item, line) => _editLine(context, ref, visit, item, line),
          onDeleteLine: (line, title) => _deleteLine(context, ref, visit, line, title),
          onAddLine: (catalog) => _addLine(context, ref, visit, catalog),
          onAttachInvoice: () => _attachInvoice(context, ref),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest.withValues(alpha: 0.95),
          border: Border(top: BorderSide(color: scheme.surfaceContainerHigh)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: FilledButton.icon(
              // TODO(export): enable once the backend exports invoices as PDF.
              onPressed: null,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              icon: const Icon(Icons.download, size: 20),
              label: Text(l10n.serviceDetailsPdf),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.visit,
    required this.busy,
    required this.onEditLine,
    required this.onDeleteLine,
    required this.onAddLine,
    required this.onAttachInvoice,
  });

  final ServiceVisit visit;
  final bool busy;
  final void Function(ServiceItem item, ServiceLineItem line) onEditLine;
  final void Function(ServiceLineItem line, String title) onDeleteLine;
  final ValueChanged<List<ServiceCategory>> onAddLine;
  final VoidCallback onAttachInvoice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final catalog = ref.watch(serviceCatalogProvider).value ?? const <ServiceCategory>[];
    // Keeps the suggestions warm for the line-item editor.
    ref.watch(serviceSuggestionsProvider);
    final vehicle = ref.watch(vehicleProvider(visit.vehicleId)).value;
    final baseDate = visit.serviceDate.toLocal();
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            ServiceHeaderCard(visit: visit, vehicle: vehicle),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.serviceDetailsItemsTitle(visit.lineItems.length),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final (index, line) in visit.lineItems.indexed) ...[
              if (index > 0) const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  final item = findServiceItem(catalog, line.itemId);
                  final title = item?.title ?? line.itemId;
                  return ServiceLineRow(
                    line: line,
                    item: item,
                    index: index,
                    baseKm: visit.odometerKm,
                    baseDate: baseDate,
                    onEdit: item == null || busy ? () {} : () => onEditLine(item, line),
                    onDelete: busy ? () {} : () => onDeleteLine(line, title),
                  );
                },
              ),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: catalog.isEmpty || busy ? null : () => onAddLine(catalog),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: scheme.surfaceContainerLowest.withValues(alpha: 0.8),
                side: BorderSide(color: scheme.outlineVariant),
              ),
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: Text(l10n.serviceDetailsAddItem),
            ),
            const SizedBox(height: 16),
            ServiceInvoiceCard(visit: visit, onAttach: busy ? () {} : onAttachInvoice),
            const SizedBox(height: 16),
            ServiceTotalCard(totalCost: visit.totalCost),
          ],
        ),
        if (busy) const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator()),
      ],
    );
  }
}
