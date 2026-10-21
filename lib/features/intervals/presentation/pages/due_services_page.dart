import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/due_item.dart';
import '../../domain/entities/due_report.dart';
import '../providers/interval_providers.dart';
import '../widgets/due_item_card.dart';
import '../widgets/due_success_card.dart';

/// "سرویس‌های سررسید شده" (Stitch `5686e3f9f6cf403cb2aa717c13b9ccdc`): after an odometer update
/// ([args] set) the success card, then the amber notice, the items that are not `ok` with an
/// action into the service wizard, the archive hint and the footer buttons. A full page above
/// the tabs.
class DueServicesPage extends ConsumerWidget {
  const DueServicesPage({super.key, required this.vehicleId, this.args});

  final String vehicleId;

  /// The odometer update this page follows, or `null` when opened from the vehicle details.
  final OdometerUpdateArgs? args;

  void _record(BuildContext context, DueItem item) =>
      context.push(AppRoutes.newServicePath(vehicleId), extra: item.coversItemIds);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final report = ref.watch(dueReportProvider(vehicleId));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: scheme.surface,
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
            Text(l10n.dueTitle, style: theme.textTheme.headlineSmall),
            Text(
              l10n.dueSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          Semantics(
            label: l10n.accountLabel,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primary,
              child: Icon(Icons.person, size: 18, color: scheme.onPrimary),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: report.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(
          message: l10n.dueLoadError,
          onRetry: () => ref.invalidate(dueReportProvider(vehicleId)),
        ),
        data: (report) => _Body(
          vehicleId: vehicleId,
          args: args,
          report: report,
          onRecord: (item) => _record(context, item),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.vehicleId,
    required this.args,
    required this.report,
    required this.onRecord,
  });

  final String vehicleId;
  final OdometerUpdateArgs? args;
  final DueReport report;
  final ValueChanged<DueItem> onRecord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final pending = report.pending;
    final reached = report.reachedCount;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        if (args case final args?) ...[
          DueSuccessCard(
            args: args,
            vehicle: ref.watch(vehicleProvider(vehicleId)).value,
            now: ref.watch(clockProvider)(),
          ),
          const SizedBox(height: 16),
        ],
        if (reached > 0) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tones.dueSoon.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: tones.amber.chipBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.warning_rounded, size: 20, color: tones.amber.foreground),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dueNoticeTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: tones.amber.chipForeground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        args == null
                            ? l10n.dueNoticeBody(reached)
                            : l10n.dueNoticeBodyAfterUpdate(reached),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: tones.amber.chipForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  l10n.dueListTitle,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  l10n.serviceStepNumber(pending.length),
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.dueListBasis,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (pending.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.event_available_outlined, size: 40, color: tones.ok.foreground),
                const SizedBox(height: 8),
                Text(
                  l10n.dueEmpty,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: tones.muted),
                ),
              ],
            ),
          ),
        for (final (index, item) in pending.indexed) ...[
          if (index > 0) const SizedBox(height: 14),
          DueItemCard(item: item, onRecord: () => onRecord(item)),
        ],
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_long_outlined, size: 20, color: scheme.secondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dueArchiveTitle,
                      style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                    ),
                    Text(
                      l10n.dueArchiveBody,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.of(context).maybePop(),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          child: Text(l10n.dueConfirmBack),
        ),
        const SizedBox(height: 8),
        TextButton(
          // TODO(notifications): schedule a reminder once Phase 5 lands; for now it just closes.
          onPressed: () => Navigator.of(context).maybePop(),
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: scheme.surfaceContainerLow,
            foregroundColor: scheme.onSurfaceVariant,
            textStyle: theme.textTheme.labelMedium,
          ),
          child: Text(l10n.dueRemindLater),
        ),
      ],
    );
  }
}
