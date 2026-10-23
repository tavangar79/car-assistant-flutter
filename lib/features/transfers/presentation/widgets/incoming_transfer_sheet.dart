import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/presentation/widgets/history_formats.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/plate_badge.dart';
import '../../domain/entities/transfer_failures.dart';
import '../../domain/entities/vehicle_transfer.dart';
import '../providers/transfer_providers.dart';

/// The buyer's review of an incoming transfer: the vehicle snapshot, the sender, what accepting
/// does, then "پذیرش" (opens the vehicle in the garage) or "رد درخواست".
class IncomingTransferSheet extends ConsumerWidget {
  const IncomingTransferSheet({super.key, required this.transfer});

  final VehicleTransfer transfer;

  static Future<void> show(BuildContext context, VehicleTransfer transfer) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        builder: (_) => IncomingTransferSheet(transfer: transfer),
      );

  Future<void> _accept(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);
    final result = await ref.read(transferControllerProvider.notifier).accept(transfer.id);
    switch (result) {
      case Right(value: final vehicle):
        navigator.pop();
        messenger.showSnackBar(SnackBar(content: Text(l10n.incomingTransferAccepted)));
        router.go(AppRoutes.vehicleDetailsPath(vehicle.id));
      case Left(value: TransferConflictFailure(:final serverMessage)):
        navigator.pop();
        messenger.showSnackBar(SnackBar(content: Text(serverMessage)));
      case Left():
        messenger.showSnackBar(SnackBar(content: Text(l10n.incomingTransferFailed)));
    }
  }

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final failure = await ref.read(transferControllerProvider.notifier).reject(transfer.id);
    if (failure == null) navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          failure == null ? l10n.incomingTransferRejected : l10n.incomingTransferFailed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final busy = ref.watch(transferControllerProvider).isLoading;
    final vehicle = transfer.vehicle;
    final muted = theme.textTheme.bodyMedium?.copyWith(color: tones.muted);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.incomingTransferSheetTitle,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.nickname,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                        Text(
                          l10n.vehicleDetailsModelYear(
                            localizeDigits('${vehicle.yearJalali}', l10n.localeName),
                          ),
                          style: muted,
                        ),
                        Text(
                          l10n.incomingTransferMileage(
                            formatAmount(vehicle.mileageKm, l10n.localeName),
                          ),
                          style: muted,
                        ),
                      ],
                    ),
                  ),
                  PlateBadge(plate: vehicle.plate, dense: true),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.incomingTransferFrom(transfer.fromName ?? l10n.incomingTransferUnknownSender),
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(l10n.incomingTransferNote, style: muted),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: busy ? null : () => _accept(context, ref),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: Text(l10n.incomingTransferAccept),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: busy ? null : () => _reject(context, ref),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                foregroundColor: scheme.error,
              ),
              child: Text(l10n.incomingTransferReject),
            ),
          ],
        ),
      ),
    );
  }
}
