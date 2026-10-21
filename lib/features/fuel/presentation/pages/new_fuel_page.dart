import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../auth/presentation/widgets/jalali_date_picker_sheet.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../domain/entities/fuel_economy.dart';
import '../../domain/entities/fuel_failures.dart';
import '../../domain/entities/fuel_field.dart';
import '../../domain/entities/fuel_log.dart';
import '../../domain/entities/fuel_log_draft.dart';
import '../../domain/entities/fuel_rules.dart';
import '../providers/fuel_providers.dart';
import '../widgets/decimal_input_formatter.dart';
import '../widgets/fuel_amount_card.dart';
import '../widgets/fuel_date_card.dart';
import '../widgets/fuel_details_card.dart';
import '../widgets/fuel_economy_card.dart';
import '../widgets/fuel_formats.dart';
import '../widgets/fuel_odometer_card.dart';
import '../widgets/fuel_type_card.dart';
import '../widgets/fuel_vehicle_card.dart';
import '../widgets/full_fill_card.dart';

/// "ثبت سوخت‌گیری" (Stitch `f9dfc5c4c7644de1a68f8fef867f1be6`): records a fill-up for a vehicle.
/// A full page above the tabs; on save it refreshes the vehicle and goes back.
class NewFuelPage extends ConsumerStatefulWidget {
  const NewFuelPage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  ConsumerState<NewFuelPage> createState() => _NewFuelPageState();
}

class _NewFuelPageState extends ConsumerState<NewFuelPage> {
  final _odometer = TextEditingController();
  final _volume = TextEditingController();
  final _cost = TextEditingController();
  final _station = TextEditingController();
  final _notes = TextEditingController();
  var _draft = const FuelLogDraft();

  /// The vehicle whose mileage filled the odometer input; `null` until it has loaded.
  String? _filledFor;

  @override
  void dispose() {
    _odometer.dispose();
    _volume.dispose();
    _cost.dispose();
    _station.dispose();
    _notes.dispose();
    super.dispose();
  }

  String get _locale => AppLocalizations.of(context).localeName;

  int get _odometerValue => int.tryParse(DigitsInputFormatter.digitsOf(_odometer.text)) ?? 0;

  /// Fills the odometer with [vehicle]'s mileage once it has loaded.
  void _fillFor(Vehicle vehicle) {
    if (_filledFor == vehicle.id) return;
    _filledFor = vehicle.id;
    _odometer.text = FuelOdometerCard.formatter(_locale).format('${vehicle.mileageKm}');
  }

  void _update(FuelLogDraft draft) {
    ref.read(newFuelControllerProvider.notifier).clearError();
    setState(() => _draft = draft);
  }

  void _odometerChanged() => _update(_draft.copyWith(odometerKm: () => _odometerValue));

  void _adjustOdometer(int step) {
    final km = _odometerValue + step;
    _odometer.text = FuelOdometerCard.formatter(_locale).format('${km < 0 ? 0 : km}');
    _odometerChanged();
  }

  void _volumeChanged(String text) =>
      _update(_draft.copyWith(volume: () => DecimalInputFormatter.parse(text)));

  void _costChanged(String text) =>
      _update(_draft.copyWith(totalCost: () => int.tryParse(DigitsInputFormatter.digitsOf(text))));

  void _chip(FuelDateChip chip, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    _update(
      _draft.copyWith(
        fueledDay: () => switch (chip) {
          FuelDateChip.today => null,
          FuelDateChip.yesterday => today.subtract(const Duration(days: 1)),
        },
      ),
    );
  }

  Future<void> _pickDate(DateTime current, DateTime now) async {
    final l10n = AppLocalizations.of(context);
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: current,
      first: DateTime(2000),
      last: now,
      title: l10n.fuelDatePickTitle,
      confirmLabel: l10n.odometerPickDateConfirm,
    );
    if (picked == null || !mounted) return;
    final isToday = picked.year == now.year && picked.month == now.month && picked.day == now.day;
    _update(_draft.copyWith(fueledDay: () => isToday ? null : picked));
  }

  Future<void> _pickTime(DateTime current) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
      helpText: AppLocalizations.of(context).fuelTimePickHelp,
    );
    if (picked == null || !mounted) return;
    _update(_draft.copyWith(fueledMinutes: () => picked.hour * 60 + picked.minute));
  }

  Future<void> _submit(Vehicle vehicle) async {
    if (ref.read(newFuelControllerProvider).isLoading) return;
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final saved = await ref.read(newFuelControllerProvider.notifier).submit(vehicle, _draft);
    if (!mounted) return;
    if (saved == null) {
      final failure = ref.read(newFuelControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(
          content: Text(switch (failure) {
            InvalidFuelLogFailure() || FuelLogRejectedFailure() => l10n.fuelSaveInvalid,
            _ => l10n.fuelSaveFailed,
          }),
        ),
      );
      return;
    }
    messenger.showSnackBar(SnackBar(content: Text(l10n.fuelSaved)));
    navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final vehicle = ref.watch(vehicleProvider(widget.vehicleId));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        scrolledUnderElevation: 1,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.04),
        leading: IconButton(
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: Text(l10n.fuelPageTitle, style: theme.textTheme.headlineSmall),
      ),
      body: vehicle.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(
          message: l10n.vehicleDetailsLoadError,
          onRetry: () => ref.invalidate(vehicleProvider(widget.vehicleId)),
        ),
        data: (vehicle) {
          _fillFor(vehicle);
          return _form(vehicle, l10n);
        },
      ),
    );
  }

  Widget _form(Vehicle vehicle, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final now = ref.watch(clockProvider)();
    final logs = ref.watch(fuelLogsProvider(vehicle.id)).value ?? const <FuelLog>[];
    final controller = ref.watch(newFuelControllerProvider);
    final failure = controller.isLoading ? null : controller.error;
    final invalid = failure is InvalidFuelLogFailure ? failure.fields : const <FuelField>{};
    final unit = fuelUnitLabel(_draft.fuelType, l10n);
    final date = _draft.fueledAt(now);
    final preview = previewFuelEconomy(
      logs,
      odometerKm: _odometerValue,
      fuelType: _draft.fuelType,
      volume: _draft.volume,
      isFullFill: _draft.isFullFill,
    );
    const gap = SizedBox(height: 16);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        FuelVehicleCard(vehicle: vehicle, lastLog: logs.firstOrNull),
        gap,
        FuelDateCard(
          date: date,
          now: now,
          onChip: (chip) => _chip(chip, now),
          onPickDate: () => _pickDate(date, now),
          onPickTime: () => _pickTime(date),
        ),
        gap,
        FuelOdometerCard(
          controller: _odometer,
          value: _odometerValue,
          currentMileageKm: vehicle.mileageKm,
          lastFillKm: logs.firstOrNull?.odometerKm,
          error: invalid.contains(FuelField.odometerKm)
              ? l10n.vehicleMileageError(FuelRules.maxMileageKm)
              : null,
          onChanged: (_) => _odometerChanged(),
          onAdjust: _adjustOdometer,
        ),
        gap,
        FuelTypeCard(
          selected: _draft.fuelType,
          onSelected: (type) => _update(_draft.copyWith(fuelType: type)),
        ),
        gap,
        FuelAmountCard(
          volumeController: _volume,
          costController: _cost,
          unit: unit,
          ratePerUnit: _draft.ratePerUnit,
          volumeError: invalid.contains(FuelField.volume)
              ? l10n.fuelVolumeError(FuelRules.maxVolume)
              : null,
          costError: invalid.contains(FuelField.totalCost) ? l10n.fuelTotalCostError : null,
          onVolumeChanged: _volumeChanged,
          onCostChanged: _costChanged,
        ),
        gap,
        FullFillCard(
          value: _draft.isFullFill,
          onChanged: (value) => _update(_draft.copyWith(isFullFill: value)),
        ),
        gap,
        FuelEconomyCard(preview: preview, unit: unit),
        gap,
        FuelDetailsCard(
          stationController: _station,
          notesController: _notes,
          paymentMethod: _draft.paymentMethod,
          stationError: invalid.contains(FuelField.station)
              ? l10n.fuelStationError(FuelRules.stationMaxLength)
              : null,
          notesError: invalid.contains(FuelField.notes)
              ? l10n.fuelNotesError(FuelRules.notesMaxLength)
              : null,
          onStationChanged: (value) => _update(_draft.copyWith(station: value)),
          onNotesChanged: (value) => _update(_draft.copyWith(notes: value)),
          onPaymentMethodChanged: (method) => _update(_draft.copyWith(paymentMethod: () => method)),
        ),
        const SizedBox(height: 24),
        if (invalid.contains(FuelField.fueledAt)) ...[
          AuthErrorText(l10n.fuelDateInFuture),
          const SizedBox(height: 8),
        ],
        FilledButton.icon(
          onPressed: controller.isLoading ? null : () => _submit(vehicle),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            disabledBackgroundColor: scheme.primary.withValues(alpha: 0.8),
            disabledForegroundColor: scheme.onPrimary,
          ),
          icon: controller.isLoading
              ? SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                )
              : const Icon(Icons.check_circle_outline, size: 20),
          label: Text(controller.isLoading ? l10n.serviceSaving : l10n.fuelSubmit),
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
            backgroundColor: scheme.surfaceContainerLowest,
            foregroundColor: scheme.onSurfaceVariant,
            textStyle: theme.textTheme.labelMedium,
          ),
          child: Text(l10n.fuelCancel),
        ),
      ],
    );
  }
}
