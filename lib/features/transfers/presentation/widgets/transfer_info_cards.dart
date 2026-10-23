import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';

/// "اقلامی که به مالک جدید منتقل می‌شوند": four checked items and the private documents, which
/// stay behind (faded, with a cross).
class TransferItemsCard extends StatelessWidget {
  const TransferItemsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final items = [
      (l10n.transferItemServices, l10n.transferItemServicesHint),
      (l10n.transferItemIntervals, l10n.transferItemIntervalsHint),
      (l10n.transferItemDocuments, l10n.transferItemDocumentsHint),
      (l10n.transferItemFuel, l10n.transferItemFuelHint),
    ];
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.sync_alt, size: 20, color: scheme.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.transferItemsTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final (title, hint) in items) ...[
            _Item(title: title, hint: hint, moves: true),
            const SizedBox(height: 8),
          ],
          Opacity(
            opacity: 0.85,
            child: _Item(
              title: l10n.transferItemPrivate,
              hint: l10n.transferItemPrivateHint,
              moves: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.title, required this.hint, required this.moves});

  final String title;
  final String hint;
  final bool moves;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: moves ? scheme.surfaceContainerLow : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: moves ? tones.info.background : scheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(
              moves ? Icons.check : Icons.close,
              size: 14,
              color: moves ? tones.info.foreground : scheme.secondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: moves ? scheme.onSurface : scheme.secondary,
                  ),
                ),
                Text(hint, style: theme.textTheme.bodySmall?.copyWith(color: tones.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "قوانین حفظ حریم خصوصی و نگهداری سوابق": the amber warning with three numbered rules. Rule ۲
/// points to the report export ([onOpenReport]).
class TransferRulesCard extends StatelessWidget {
  const TransferRulesCard({super.key, required this.onOpenReport});

  final VoidCallback onOpenReport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final amber = AppTones.of(context).amber;
    final text = theme.textTheme.bodySmall?.copyWith(color: amber.chipForeground, height: 1.6);
    Widget rule(int number, String body) => Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${localizeDigits('$number', l10n.localeName)}.',
            style: text?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(body, style: text)),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: amber.background, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_rounded, size: 24, color: amber.foreground),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.transferRulesTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: amber.chipForeground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.transferRulesIntro, style: text?.copyWith(fontWeight: FontWeight.w600)),
          rule(1, l10n.transferRule1),
          rule(2, l10n.transferRule2),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: onOpenReport,
              style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
                foregroundColor: amber.chipForeground,
                textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              icon: const Icon(Icons.ios_share, size: 18),
              label: Text(l10n.transferRule2Link),
            ),
          ),
          rule(3, l10n.transferRule3),
        ],
      ),
    );
  }
}
