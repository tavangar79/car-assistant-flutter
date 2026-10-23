import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import '../../domain/entities/vehicle_transfer.dart';

/// The vehicle's pending outgoing transfer (instead of the form): the buyer's phone, when it was
/// sent, and "لغو درخواست". [onCancel] is `null` while busy.
class PendingTransferCard extends StatelessWidget {
  const PendingTransferCard({super.key, required this.transfer, required this.onCancel});

  final VehicleTransfer transfer;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final body = theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant);
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.hourglass_top, size: 20, color: tones.dueSoon.foreground),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.transferPendingTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.transferPendingPhone(localizeDigits(transfer.toPhone, l10n.localeName)),
            style: body,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.transferPendingDate(formatJalaliDate(transfer.createdAt.toLocal(), l10n)),
            style: body,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              foregroundColor: scheme.error,
              side: BorderSide(color: scheme.error.withValues(alpha: 0.4)),
            ),
            icon: const Icon(Icons.cancel_outlined, size: 20),
            label: Text(l10n.transferCancelRequest),
          ),
        ],
      ),
    );
  }
}
