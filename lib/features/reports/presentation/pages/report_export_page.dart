import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/jalali_date_picker_sheet.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../services/presentation/providers/service_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../export/report_file_name.dart';
import '../providers/report_providers.dart';
import '../widgets/report_content_card.dart';
import '../widgets/report_period_card.dart';
import '../widgets/report_preview_card.dart';
import '../widgets/report_scope_card.dart';

/// "خروجی گزارش" (Stitch `6a6e4f3f474549c88b2f94b6a9c0722b`): the vehicle scope, the date range,
/// the record types, a preview of the record count and total, and the PDF / CSV downloads. Opens
/// on [vehicleId], else on the default vehicle.
class ReportExportPage extends ConsumerWidget {
  const ReportExportPage({super.key, this.vehicleId});

  final String? vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
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
        title: Text(
          l10n.reportExportTitle,
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: ref
          .watch(vehiclesProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => LoadErrorView(
              message: l10n.reportPreviewError,
              onRetry: () => ref.invalidate(vehiclesProvider),
            ),
            data: (garage) {
              final initial = _initialVehicle(garage);
              return _ExportForm(key: ValueKey(initial?.id), garage: garage, vehicle: initial);
            },
          ),
    );
  }

  /// The passed vehicle, else the default one, else the first; `null` with an empty garage.
  Vehicle? _initialVehicle(List<Vehicle> garage) {
    for (final vehicle in garage) {
      if (vehicle.id == vehicleId) return vehicle;
    }
    return garage.where((vehicle) => vehicle.isDefault).firstOrNull ?? garage.firstOrNull;
  }
}

class _ExportForm extends ConsumerStatefulWidget {
  const _ExportForm({super.key, required this.garage, required this.vehicle});

  final List<Vehicle> garage;
  final Vehicle? vehicle;

  @override
  ConsumerState<_ExportForm> createState() => _ExportFormState();
}

class _ExportFormState extends ConsumerState<_ExportForm> {
  /// The format being exported, or `null` when idle.
  ReportFormat? _busy;

  String? get _key => widget.vehicle?.id;

  Future<void> _pickFrom(DateTime? from, DateTime? to) async {
    final l10n = AppLocalizations.of(context);
    final now = ref.read(clockProvider)();
    final last = to ?? now;
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: from ?? last,
      first: DateTime(2000),
      last: last,
      title: l10n.reportFrom,
      confirmLabel: l10n.historyFilterPickDate,
    );
    if (picked == null || !mounted) return;
    ref.read(reportOptionsProvider(_key).notifier).setCustomRange(now, from: picked);
  }

  Future<void> _pickTo(DateTime? from) async {
    final l10n = AppLocalizations.of(context);
    final now = ref.read(clockProvider)();
    final options = ref.read(reportOptionsProvider(_key));
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: options.range(now).$2?.toLocal() ?? now,
      first: from ?? DateTime(2000),
      last: now,
      title: l10n.reportTo,
      confirmLabel: l10n.historyFilterPickDate,
    );
    if (picked == null || !mounted) return;
    ref.read(reportOptionsProvider(_key).notifier).setCustomRange(now, to: picked);
  }

  Future<void> _export(ReportFormat format) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final tones = AppTones.of(context);
    final scheme = Theme.of(context).colorScheme;
    setState(() => _busy = format);
    try {
      final report = await ref.read(reportPreviewProvider(_key).future);
      final catalog = await ref.read(serviceCatalogProvider.future);
      await ref
          .read(reportExporterProvider)
          .export(
            format,
            report: report,
            options: ref.read(reportOptionsProvider(_key)),
            vehicles: widget.garage,
            catalog: catalog,
            l10n: l10n,
          );
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: scheme.inverseSurface,
          duration: const Duration(seconds: 4),
          content: Row(
            children: [
              Icon(Icons.download_done, size: 20, color: tones.accentOnPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(format == ReportFormat.pdf ? l10n.reportPdfDone : l10n.reportCsvDone),
              ),
            ],
          ),
          action: SnackBarAction(
            label: l10n.reportToastClose,
            textColor: scheme.onInverseSurface,
            onPressed: messenger.hideCurrentSnackBar,
          ),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.reportExportFailed)));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(reportOptionsProvider(_key));
    final notifier = ref.read(reportOptionsProvider(_key).notifier);
    final preview = ref.watch(reportPreviewProvider(_key));
    // Load the catalog early: the files need the service item titles.
    ref.watch(serviceCatalogProvider);
    final now = ref.watch(clockProvider)();
    final (from, to) = options.range(now);
    final shownFrom = from ?? preview.value?.entries.firstOrNull?.occurredAt;
    final canDownload = options.canExport && preview.hasValue && !preview.isLoading;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        ReportScopeCard(
          vehicle: widget.vehicle,
          vehicleCount: widget.garage.length,
          allVehicles: options.vehicleId == null,
          onChanged: notifier.setAllVehicles,
        ),
        const SizedBox(height: 16),
        ReportPeriodCard(
          period: options.period,
          from: shownFrom,
          to: to ?? now,
          currentYear: Jalali.fromDateTime(now.toLocal()).year,
          onPeriod: notifier.setPeriod,
          onPickFrom: () => _pickFrom(from, to),
          onPickTo: () => _pickTo(from),
        ),
        const SizedBox(height: 16),
        ReportContentCard(
          types: options.types,
          includeImages: options.includeImages,
          onToggleType: notifier.toggleType,
          onToggleImages: notifier.toggleImages,
          onToggleAll: notifier.toggleAll,
        ),
        const SizedBox(height: 16),
        ReportPreviewCard(
          preview: preview,
          hasContent: options.canExport,
          onRetry: () => ref.invalidate(reportPreviewProvider(_key)),
        ),
        const SizedBox(height: 16),
        _DownloadButton(
          format: ReportFormat.pdf,
          busy: _busy == ReportFormat.pdf,
          onPressed: canDownload && _busy == null ? () => _export(ReportFormat.pdf) : null,
        ),
        const SizedBox(height: 8),
        _DownloadButton(
          format: ReportFormat.csv,
          busy: _busy == ReportFormat.csv,
          onPressed: canDownload && _busy == null ? () => _export(ReportFormat.csv) : null,
        ),
      ],
    );
  }
}

/// "دریافت خروجی PDF رسمی" (navy) or "دریافت فایل اکسل (Excel / CSV)" (white).
class _DownloadButton extends StatelessWidget {
  const _DownloadButton({required this.format, required this.busy, required this.onPressed});

  final ReportFormat format;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final pdf = format == ReportFormat.pdf;
    final Widget icon = busy
        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : Icon(pdf ? Icons.picture_as_pdf_outlined : Icons.table_view_outlined, size: 22);
    final label = Text(pdf ? l10n.reportDownloadPdf : l10n.reportDownloadCsv);
    final textStyle = theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700);
    if (pdf) {
      return FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56), textStyle: textStyle),
        icon: icon,
        label: label,
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: scheme.surfaceContainerLowest,
        foregroundColor: scheme.onSurface,
        iconColor: scheme.secondary,
        textStyle: textStyle,
      ),
      icon: icon,
      label: label,
    );
  }
}
