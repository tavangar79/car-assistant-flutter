import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/presentation/widgets/history_formats.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/report_failures.dart';

/// "پیش‌نمایش خروجی مدنظر": "شامل N رکورد ثبت‌شده • مجموع: X تومان" from the report summary, a
/// spinner while it loads, or why there is nothing to export.
class ReportPreviewCard extends StatelessWidget {
  const ReportPreviewCard({
    super.key,
    required this.preview,
    required this.hasContent,
    required this.onRetry,
  });

  final AsyncValue<Report> preview;

  /// At least one record type is chosen.
  final bool hasContent;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final body = theme.textTheme.bodySmall?.copyWith(color: scheme.onSurface);
    final bold = body?.copyWith(fontWeight: FontWeight.w700);
    final Widget line = switch (preview) {
      _ when !hasContent => Text(l10n.reportNoContent, style: body),
      _ when preview.isLoading => const _Spinner(),
      AsyncError(error: ReportTooLargeFailure()) => Text(l10n.reportTooLarge, style: body),
      AsyncError() => Row(
        children: [
          Flexible(child: Text(l10n.reportPreviewError, style: body)),
          TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
      AsyncData(:final value) => Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${l10n.reportPreviewIncludes} '),
            TextSpan(text: formatAmount(value.summary.entryCount, l10n.localeName), style: bold),
            TextSpan(text: ' ${l10n.reportPreviewRecords}  •  ${l10n.reportPreviewTotal} '),
            TextSpan(text: formatAmount(value.summary.totalCost, l10n.localeName), style: bold),
            TextSpan(
              text: ' ${l10n.historyToman}',
              style: theme.textTheme.labelSmall?.copyWith(color: muted),
            ),
          ],
        ),
        style: body,
      ),
      _ => const _Spinner(),
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, shape: BoxShape.circle),
            child: Icon(Icons.analytics_outlined, size: 20, color: scheme.onSurface),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reportPreviewTitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                line,
              ],
            ),
          ),
          Icon(Icons.verified_outlined, size: 18, color: scheme.secondary),
        ],
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => const Align(
    alignment: AlignmentDirectional.centerStart,
    child: SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)),
  );
}
