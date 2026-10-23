import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/vehicle_transfer.dart';
import '../providers/transfer_providers.dart';
import 'incoming_transfer_sheet.dart';

/// A card per incoming transfer (the garage banner and the pinned notifications card). Tapping
/// one opens [IncomingTransferSheet]. Shows nothing while loading, on error or without any.
class IncomingTransfers extends ConsumerWidget {
  const IncomingTransfers({super.key, this.padding = EdgeInsets.zero});

  /// Around the cards, only when there are some.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incoming = ref.watch(transfersProvider).value?.incoming ?? const [];
    if (incoming.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, transfer) in incoming.indexed) ...[
            if (index > 0) const SizedBox(height: 8),
            _IncomingTransferCard(transfer: transfer),
          ],
        ],
      ),
    );
  }
}

class _IncomingTransferCard extends StatelessWidget {
  const _IncomingTransferCard({required this.transfer});

  final VehicleTransfer transfer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tone = AppTones.of(context).amber;
    return Material(
      color: tone.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: tone.border),
      ),
      child: InkWell(
        onTap: () => IncomingTransferSheet.show(context, transfer),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tone.chipBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.swap_horiz, color: tone.foreground),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.incomingTransferTitle,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      l10n.incomingTransferBody(
                        transfer.fromName ?? l10n.incomingTransferUnknownSender,
                        transfer.vehicle.nickname,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.incomingTransferReview,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: tone.chipForeground,
                ),
              ),
              Icon(Icons.chevron_left, size: 18, color: tone.chipForeground),
            ],
          ),
        ),
      ),
    );
  }
}
