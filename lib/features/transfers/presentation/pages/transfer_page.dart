import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/phone_number.dart';
import '../../../auth/presentation/widgets/phone_input_formatter.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import '../../domain/entities/transfer_failures.dart';
import '../../domain/entities/vehicle_transfer.dart';
import '../providers/transfer_providers.dart';
import '../widgets/pending_transfer_card.dart';
import '../widgets/transfer_info_cards.dart';
import '../widgets/transfer_phone_card.dart';
import '../widgets/transfer_vehicle_card.dart';

/// "انتقال مالکیت خودرو" (Stitch `62ba7567cd1f4215a962c377ce8fa66e`): the vehicle, the buyer's
/// phone, what moves with the car, the rules and the consent box, then the destructive submit
/// (after a final confirmation). With a pending outgoing transfer it shows that request and
/// "لغو درخواست" instead of the form.
class TransferPage extends ConsumerWidget {
  const TransferPage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final vehicle = ref.watch(vehicleProvider(vehicleId));
    final transfers = ref.watch(transfersProvider);
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
              l10n.transferTitle,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (vehicle.value case final loaded?)
              Text(
                loaded.nickname,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(color: AppTones.of(context).muted),
              ),
          ],
        ),
      ),
      body: switch ((vehicle, transfers)) {
        (AsyncData(value: final vehicle), AsyncData(value: final transfers)) => _Body(
          vehicle: vehicle,
          pending: transfers.outgoingFor(vehicle.id),
        ),
        (AsyncError(), _) || (_, AsyncError()) => LoadErrorView(
          message: l10n.transfersLoadError,
          onRetry: () {
            ref.invalidate(vehicleProvider(vehicleId));
            ref.invalidate(transfersProvider);
          },
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.vehicle, required this.pending});

  final Vehicle vehicle;
  final VehicleTransfer? pending;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final _phone = TextEditingController();
  var _consent = false;

  @override
  void initState() {
    super.initState();
    _phone.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  /// `09xxxxxxxxx`, or `null` while the number is incomplete.
  String? get _normalizedPhone =>
      PhoneNumber.normalize('0${PhoneInputFormatter.digitsOf(_phone.text)}');

  Future<void> _submit(String phone) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.transferConfirmTitle),
        content: Text(
          l10n.transferConfirmBody(widget.vehicle.nickname, localizeDigits(phone, l10n.localeName)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.vehicleCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.transferConfirmSend),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final failure = await ref
        .read(transferControllerProvider.notifier)
        .create(widget.vehicle.id, phone);
    messenger.showSnackBar(SnackBar(content: Text(_createMessage(failure, l10n))));
  }

  static String _createMessage(Failure? failure, AppLocalizations l10n) => switch (failure) {
    null => l10n.transferSent,
    InvalidTransferPhoneFailure() => l10n.transferInvalidPhone,
    SelfTransferFailure() => l10n.transferSelf,
    TransferAlreadyPendingFailure() => l10n.transferAlreadyPending,
    _ => l10n.transferFailed,
  };

  Future<void> _cancel(VehicleTransfer transfer) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final failure = await ref.read(transferControllerProvider.notifier).cancel(transfer.id);
    messenger.showSnackBar(
      SnackBar(content: Text(failure == null ? l10n.transferCancelled : l10n.transferCancelFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final busy = ref.watch(transferControllerProvider).isLoading;
    final pending = widget.pending;
    final phone = _normalizedPhone;
    const gap = SizedBox(height: 16);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        TransferVehicleCard(vehicle: widget.vehicle),
        gap,
        if (pending != null) ...[
          PendingTransferCard(transfer: pending, onCancel: busy ? null : () => _cancel(pending)),
          gap,
          const TransferItemsCard(),
        ] else ...[
          TransferPhoneCard(controller: _phone),
          gap,
          const TransferItemsCard(),
          gap,
          TransferRulesCard(
            onOpenReport: () => context.push(AppRoutes.reportExportLocation(widget.vehicle.id)),
          ),
          gap,
          DetailsCard(
            child: Material(
              type: MaterialType.transparency,
              child: CheckboxListTile(
                value: _consent,
                onChanged: (value) => setState(() => _consent = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l10n.transferConsent,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: phone != null && _consent && !busy ? () => _submit(phone) : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
              textStyle: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            icon: busy
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send, size: 20),
            label: Text(l10n.transferSubmit),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: scheme.secondary,
            ),
            child: Text(l10n.transferBack),
          ),
        ],
      ],
    );
  }
}
