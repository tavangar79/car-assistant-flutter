import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/utils/material_symbol_icon.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/widgets/jalali_date_picker_sheet.dart';
import '../../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../../vehicles/domain/entities/vehicle.dart';
import '../../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../../domain/entities/service_category.dart';
import '../../providers/service_providers.dart';
import '../../providers/service_wizard.dart';
import 'service_date_card.dart';
import 'service_odometer_card.dart';
import 'service_sticker_card.dart';
import 'service_stepper.dart';
import 'wizard_card.dart';
import 'wizard_footer.dart';

/// Step 2 "زمان و کارکرد" (Stitch `8c226f9a9e26459086dc607051ce7b95`): the selected items, the
/// odometer at the visit, its date, the sticker details and the sync note, then the continue bar.
class ServiceTimeStep extends ConsumerStatefulWidget {
  const ServiceTimeStep({
    super.key,
    required this.args,
    required this.vehicle,
    required this.onNext,
    required this.onBack,
  });

  final ServiceWizardArgs args;
  final Vehicle vehicle;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  ConsumerState<ServiceTimeStep> createState() => _ServiceTimeStepState();
}

class _ServiceTimeStepState extends ConsumerState<ServiceTimeStep> {
  final _mileage = TextEditingController();
  final _sticker = TextEditingController();
  bool _filled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_filled) return;
    _filled = true;
    final locale = AppLocalizations.of(context).localeName;
    final draft = ref.read(serviceWizardProvider(widget.args)).draft;
    _mileage.text = ServiceOdometerCard.formatter(locale)
        .format('${draft.odometerKm ?? widget.vehicle.mileageKm}');
    if (draft.stickerNextKm case final km?) {
      _sticker.text = ServiceStickerCard.formatter(locale).format('$km');
    }
  }

  @override
  void dispose() {
    _mileage.dispose();
    _sticker.dispose();
    super.dispose();
  }

  ServiceWizard get _wizard => ref.read(serviceWizardProvider(widget.args).notifier);

  int get _mileageValue => int.tryParse(DigitsInputFormatter.digitsOf(_mileage.text)) ?? 0;

  void _setMileage(int km) {
    final locale = AppLocalizations.of(context).localeName;
    _mileage.text = ServiceOdometerCard.formatter(locale).format('${km < 0 ? 0 : km}');
    _mileageChanged();
  }

  void _mileageChanged() {
    _wizard.setOdometerKm(_mileageValue);
    setState(() {});
  }

  void _stickerChanged() =>
      _wizard.setStickerNextKm(int.tryParse(DigitsInputFormatter.digitsOf(_sticker.text)));

  void _chip(ServiceDateChip chip, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    _wizard.setServiceDay(switch (chip) {
      ServiceDateChip.today => null,
      ServiceDateChip.yesterday => today.subtract(const Duration(days: 1)),
      ServiceDateChip.lastWeek => today.subtract(const Duration(days: 7)),
    });
  }

  Future<void> _pickDate(DateTime current, DateTime now) async {
    final l10n = AppLocalizations.of(context);
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: current,
      first: DateTime(2000),
      last: now,
      title: l10n.serviceDatePickTitle,
      confirmLabel: l10n.odometerPickDateConfirm,
    );
    if (picked == null || !mounted) return;
    final isToday = picked.year == now.year && picked.month == now.month && picked.day == now.day;
    _wizard.setServiceDay(isToday ? null : picked);
  }

  Future<void> _pickTime(int minutes) async {
    final l10n = AppLocalizations.of(context);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      helpText: l10n.serviceVisitTimePickHelp,
    );
    if (picked == null || !mounted) return;
    _wizard.setVisitMinutes(picked.hour * 60 + picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final now = ref.watch(clockProvider)();
    final draft = ref.watch(serviceWizardProvider(widget.args)).draft;
    final catalog = ref.watch(serviceCatalogProvider).value ?? const <ServiceCategory>[];
    final items = [for (final id in draft.itemIds) ?findServiceItem(catalog, id)];
    final readings = ref.watch(odometerReadingsProvider(widget.vehicle.id)).value;
    final date = draft.serviceDate(now);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const ServiceStepper(current: 1),
              const SizedBox(height: 16),
              WizardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.checklist, size: 18, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            l10n.serviceSelectedItemsLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: widget.onBack,
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 40),
                            foregroundColor: scheme.secondary,
                            textStyle: theme.textTheme.labelSmall,
                          ),
                          iconAlignment: IconAlignment.end,
                          icon: const Icon(Icons.edit, size: 14),
                          label: Text(l10n.serviceEditItems),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final item in items)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  materialSymbolIcon(item.icon),
                                  size: 16,
                                  color: scheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.title,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ServiceOdometerCard(
                controller: _mileage,
                value: _mileageValue,
                currentMileageKm: widget.vehicle.mileageKm,
                lastReadingAt: readings?.firstOrNull?.recordedAt,
                now: now,
                onChanged: (_) => _mileageChanged(),
                onAdjust: (step) => _setMileage(_mileageValue + step),
              ),
              const SizedBox(height: 16),
              ServiceDateCard(
                date: date,
                now: now,
                onChip: (chip) => _chip(chip, now),
                onPick: () => _pickDate(date, now),
              ),
              const SizedBox(height: 16),
              ServiceStickerCard(
                stickerController: _sticker,
                visitMinutes: date.hour * 60 + date.minute,
                onStickerChanged: (_) => _stickerChanged(),
                onPickTime: () => _pickTime(date.hour * 60 + date.minute),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tones.info.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.info_outline, size: 20, color: tones.info.foreground),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.serviceSyncTitle,
                            style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.serviceSyncBody(items.map((item) => item.title).join(' و ')),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        WizardFooter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WizardContinueButton(label: l10n.serviceContinueStep3, onPressed: widget.onNext),
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: widget.onBack,
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  foregroundColor: scheme.secondary,
                  textStyle: theme.textTheme.labelMedium,
                ),
                // chevron_left mirrors to point right (back) in RTL.
                icon: const Icon(Icons.chevron_left, size: 18),
                label: Text(l10n.serviceBackToItems),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
