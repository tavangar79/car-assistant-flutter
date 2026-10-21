import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/jalali_date_picker_sheet.dart';
import '../../../intervals/presentation/widgets/due_success_card.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/entities/vehicle_rules.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../domain/entities/odometer_failures.dart';
import '../providers/odometer_providers.dart';
import 'odometer_input_card.dart';
import 'odometer_sheet_header.dart';
import 'quick_adjust_buttons.dart';
import 'recorded_at_row.dart';
import 'vehicle_switcher.dart';

/// "بروزرسانی کیلومتر" (Stitch `b474a206ee6a4890b7a4de3df3fdf1e8`): a modal bottom sheet to record
/// a new odometer reading for one of the user's vehicles, [vehicleId] preselected. On success the
/// vehicle data is refreshed, the sheet closes and the due services page opens (when a router is
/// available).
class OdometerSheet extends ConsumerStatefulWidget {
  const OdometerSheet({super.key, required this.vehicleId});

  final String vehicleId;

  /// Opens the sheet above the whole app for vehicle [vehicleId].
  static Future<void> show(BuildContext context, {required String vehicleId}) =>
      showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        builder: (_) => OdometerSheet(vehicleId: vehicleId),
      );

  @override
  ConsumerState<OdometerSheet> createState() => _OdometerSheetState();
}

class _OdometerSheetState extends ConsumerState<OdometerSheet> {
  final _mileage = TextEditingController();
  late String _vehicleId = widget.vehicleId;

  /// The vehicle whose mileage fills the input; `null` until the vehicles have loaded.
  String? _filledFor;

  /// When the reading was taken; `null` means now.
  DateTime? _recordedAt;

  @override
  void dispose() {
    _mileage.dispose();
    super.dispose();
  }

  int get _value => int.tryParse(DigitsInputFormatter.digitsOf(_mileage.text)) ?? 0;

  void _setValue(int km) {
    final locale = AppLocalizations.of(context).localeName;
    _mileage.text = OdometerInputCard.formatter(locale).format('${km < 0 ? 0 : km}');
    _edited();
  }

  void _edited() {
    ref.read(odometerControllerProvider.notifier).clearError();
    setState(() {});
  }

  /// Fills the input with [vehicle]'s mileage once the vehicles have loaded.
  void _fillFor(Vehicle vehicle) {
    if (_filledFor == vehicle.id) return;
    _filledFor = vehicle.id;
    final locale = AppLocalizations.of(context).localeName;
    _mileage.text = OdometerInputCard.formatter(locale).format('${vehicle.mileageKm}');
  }

  void _select(Vehicle vehicle) {
    _vehicleId = vehicle.id;
    _filledFor = vehicle.id;
    _setValue(vehicle.mileageKm);
  }

  Future<void> _pickDate() async {
    final now = ref.read(clockProvider)();
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: _recordedAt ?? now,
      first: DateTime(2000),
      last: now,
      title: AppLocalizations.of(context).odometerPickDateTitle,
      confirmLabel: AppLocalizations.of(context).odometerPickDateConfirm,
    );
    if (picked == null || !mounted) return;
    final isToday = picked.year == now.year && picked.month == now.month && picked.day == now.day;
    // An earlier day keeps the current time of day, so it is never in the future.
    setState(
      () => _recordedAt = isToday
          ? null
          : DateTime(picked.year, picked.month, picked.day, now.hour, now.minute),
    );
  }

  Future<void> _submit(Vehicle vehicle) async {
    if (ref.read(odometerControllerProvider).isLoading) return;
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final router = GoRouter.maybeOf(context);
    final newKm = _value;
    final saved = await ref
        .read(odometerControllerProvider.notifier)
        .submit(vehicle, mileageKm: newKm, recordedAt: _recordedAt);
    if (!mounted) return;
    if (saved) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.odometerSaved)));
      navigator.pop();
      // The due services, with the new mileage and the distance since the previous reading.
      router?.push(
        AppRoutes.duePath(vehicle.id),
        extra: OdometerUpdateArgs(previousKm: vehicle.mileageKm, newKm: newKm),
      );
      return;
    }
    final failure = ref.read(odometerControllerProvider).error;
    if (failure is! MileageBelowCurrentFailure && failure is! MileageTooHighFailure) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.odometerSaveFailed)));
    }
  }

  /// The inline error: the value is out of range, or the server said so (422).
  String? _error(Vehicle vehicle, AppLocalizations l10n) {
    if (_value < vehicle.mileageKm) return l10n.odometerBelowCurrent(vehicle.mileageKm);
    if (_value > VehicleRules.maxMileageKm) {
      return l10n.vehicleMileageError(VehicleRules.maxMileageKm);
    }
    return switch (ref.watch(odometerControllerProvider).error) {
      MileageBelowCurrentFailure(:final currentMileageKm) => l10n.odometerBelowCurrent(
        currentMileageKm,
      ),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OdometerSheetHeader(onClose: () => Navigator.of(context).pop()),
            const SizedBox(height: 12),
            ref
                .watch(vehiclesProvider)
                .when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => _LoadError(onRetry: () => ref.invalidate(vehiclesProvider)),
                  data: (vehicles) {
                    final vehicle = vehicles.where((v) => v.id == _vehicleId).firstOrNull;
                    if (vehicle == null) {
                      return _LoadError(onRetry: () => ref.invalidate(vehiclesProvider));
                    }
                    _fillFor(vehicle);
                    return _form(vehicles, vehicle, l10n);
                  },
                ),
          ],
        ),
      ),
    );
  }

  Widget _form(List<Vehicle> vehicles, Vehicle vehicle, AppLocalizations l10n) {
    final saving = ref.watch(odometerControllerProvider).isLoading;
    final now = ref.watch(clockProvider)();
    final scheme = Theme.of(context).colorScheme;
    final readings = ref.watch(odometerReadingsProvider(vehicle.id)).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VehicleSwitcher(vehicles: vehicles, selectedId: vehicle.id, onSelected: _select),
        const SizedBox(height: 16),
        OdometerInputCard(
          controller: _mileage,
          currentMileageKm: vehicle.mileageKm,
          value: _value,
          lastReadingAt: readings?.firstOrNull?.recordedAt,
          error: _error(vehicle, l10n),
          onChanged: (_) => _edited(),
          onReset: () => _setValue(vehicle.mileageKm),
        ),
        const SizedBox(height: 12),
        QuickAdjustButtons(onAdjust: (step) => _setValue(_value + step)),
        const SizedBox(height: 16),
        RecordedAtRow(date: _recordedAt ?? now, now: now, onChange: _pickDate),
        // TODO(service-intervals): the "یادآور سرویس روغن موتور" card of the Stitch screen needs
        // the service intervals (Phase 2).
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: saving ? null : () => _submit(vehicle),
          icon: saving
              ? SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                )
              : Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: AppTones.of(context).accentOnPrimary,
                ),
          label: Text(l10n.odometerSubmit),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: scheme.surfaceContainer,
            foregroundColor: scheme.onSurfaceVariant,
          ),
          child: Text(l10n.odometerCancel),
        ),
      ],
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(l10n.vehiclesLoadError),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
