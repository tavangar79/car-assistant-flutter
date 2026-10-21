import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../domain/entities/interval_failures.dart';
import '../../domain/entities/interval_setting.dart';
import '../../domain/entities/service_interval.dart';
import '../providers/interval_providers.dart';
import '../widgets/interval_card.dart';

/// "تنظیم دوره سرویس" (Stitch `dee2fcfb53034b6a96a868bb828e8d0f`): the vehicle and its mileage
/// with "بازنشانی همه", the whichever-comes-first note, one card per interval and the sticky
/// save button. Inside the Garage tab, under the vehicle details.
class ServiceIntervalsPage extends ConsumerWidget {
  const ServiceIntervalsPage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final intervals = ref.watch(serviceIntervalsProvider(vehicleId));
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
        title: Text(l10n.intervalsTitle, style: theme.textTheme.headlineMedium),
      ),
      body: intervals.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(
          message: l10n.intervalsLoadError,
          onRetry: () => ref.invalidate(serviceIntervalsProvider(vehicleId)),
        ),
        // Keyed on the loaded values, so a save or reset starts a fresh form from the server.
        data: (list) => _IntervalsForm(
          key: ValueKey(list),
          vehicleId: vehicleId,
          intervals: list,
          vehicle: ref.watch(vehicleProvider(vehicleId)).value,
        ),
      ),
    );
  }
}

class _IntervalsForm extends ConsumerStatefulWidget {
  const _IntervalsForm({
    super.key,
    required this.vehicleId,
    required this.intervals,
    required this.vehicle,
  });

  final String vehicleId;
  final List<ServiceInterval> intervals;
  final Vehicle? vehicle;

  @override
  ConsumerState<_IntervalsForm> createState() => _IntervalsFormState();
}

class _IntervalsFormState extends ConsumerState<_IntervalsForm> {
  final _km = <String, TextEditingController>{};
  final _months = <String, TextEditingController>{};

  /// Set once the user tried to save; inline errors show from then on.
  bool _validate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_km.isNotEmpty) return;
    final locale = AppLocalizations.of(context).localeName;
    for (final interval in widget.intervals) {
      _km[interval.id] = TextEditingController(
        text: IntervalCard.kmFormatter(locale).format('${interval.km}'),
      );
      _months[interval.id] = TextEditingController(
        text: IntervalCard.monthsFormatter(locale).format('${interval.months}'),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in [..._km.values, ..._months.values]) {
      controller.dispose();
    }
    super.dispose();
  }

  static int? _int(String text) => int.tryParse(DigitsInputFormatter.digitsOf(text));

  int? _kmOf(String id) => _int(_km[id]!.text);

  int? _monthsOf(String id) => _int(_months[id]!.text);

  void _edited() {
    ref.read(intervalsControllerProvider.notifier).clearError();
    setState(() {});
  }

  void _resetRow(ServiceInterval interval) {
    final locale = AppLocalizations.of(context).localeName;
    _km[interval.id]!.text = IntervalCard.kmFormatter(locale).format('${interval.defaultKm}');
    _months[interval.id]!.text = IntervalCard.monthsFormatter(locale)
        .format('${interval.defaultMonths}');
    _edited();
  }

  bool get _allValid => widget.intervals.every(
    (interval) =>
        kmErrorOf(_kmOf(interval.id), AppLocalizations.of(context)) == null &&
        monthsErrorOf(_monthsOf(interval.id), AppLocalizations.of(context)) == null,
  );

  Future<void> _save() async {
    if (ref.read(intervalsControllerProvider).isLoading) return;
    FocusScope.of(context).unfocus();
    setState(() => _validate = true);
    if (!_allValid) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final settings = [
      for (final interval in widget.intervals)
        IntervalSetting(id: interval.id, km: _kmOf(interval.id)!, months: _monthsOf(interval.id)!),
    ];
    final saved = await ref
        .read(intervalsControllerProvider.notifier)
        .save(widget.vehicleId, settings);
    if (!mounted) return;
    final message = saved
        ? l10n.intervalsSaved
        : switch (ref.read(intervalsControllerProvider).error) {
            InvalidIntervalsFailure() => l10n.intervalsSaveInvalid,
            _ => l10n.intervalsSaveFailed,
          };
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _resetAll() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final scheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.intervalsResetAllConfirmTitle),
        content: Text(l10n.intervalsResetAllConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.vehicleCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            child: Text(l10n.intervalsResetConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final done = await ref.read(intervalsControllerProvider.notifier).reset(widget.vehicleId);
    messenger.showSnackBar(
      SnackBar(content: Text(done ? l10n.intervalsResetDone : l10n.intervalsResetFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final busy = ref.watch(intervalsControllerProvider).isLoading;
    final serverRejected = ref.watch(intervalsControllerProvider).error is InvalidIntervalsFailure;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _HeaderCard(vehicle: widget.vehicle, onResetAll: busy ? null : _resetAll),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tones.info.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLowest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.info_outline, size: 18, color: tones.info.foreground),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.intervalsRuleTitle,
                            style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.intervalsRuleBody,
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
              const SizedBox(height: 16),
              for (final (index, interval) in widget.intervals.indexed) ...[
                if (index > 0) const SizedBox(height: 8),
                IntervalCard(
                  interval: interval,
                  index: index,
                  kmController: _km[interval.id]!,
                  monthsController: _months[interval.id]!,
                  kmError: _validate || serverRejected ? kmErrorOf(_kmOf(interval.id), l10n) : null,
                  monthsError: _validate || serverRejected
                      ? monthsErrorOf(_monthsOf(interval.id), l10n)
                      : null,
                  onChanged: _edited,
                  onReset: () => _resetRow(interval),
                ),
              ],
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: busy ? null : _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  disabledBackgroundColor: scheme.primary.withValues(alpha: 0.8),
                  disabledForegroundColor: scheme.onPrimary,
                ),
                icon: busy
                    ? SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                      )
                    : const Icon(Icons.check, size: 20),
                label: Text(l10n.intervalsSave),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The vehicle name, its current mileage, the manual note and "بازنشانی همه".
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.vehicle, required this.onResetAll});

  final Vehicle? vehicle;
  final VoidCallback? onResetAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (vehicle case final vehicle?) ...[
            Text(
              vehicle.nickname,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.speed, size: 16, color: scheme.secondary),
                const SizedBox(width: 4),
                Text(
                  l10n.intervalsCurrentMileage(vehicle.mileageKm),
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.intervalsSourceNote,
                  style: theme.textTheme.labelMedium?.copyWith(color: scheme.secondary),
                ),
              ),
              TextButton.icon(
                onPressed: onResetAll,
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  backgroundColor: scheme.surfaceContainer,
                  foregroundColor: scheme.onSurface,
                  textStyle: theme.textTheme.labelMedium,
                ),
                icon: Icon(Icons.restart_alt, size: 16, color: scheme.secondary),
                label: Text(l10n.intervalsResetAll),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
