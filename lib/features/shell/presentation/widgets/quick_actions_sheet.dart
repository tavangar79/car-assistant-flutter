import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/tone_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../../vehicles/presentation/widgets/plate_text.dart';

/// "اقدامات سریع" (Stitch `8666dc1c749b4630bbe951bb49aa89bb`), opened by the dock's add button:
/// the active vehicle (the default one, else the first), then the entries. Fuel and expense are
/// disabled until their phase; the odometer and service entries need a vehicle.
/// The sheet closes itself before calling [onUpdateOdometer], [onAddService] or [onAddVehicle].
class QuickActionsSheet extends ConsumerWidget {
  const QuickActionsSheet({
    super.key,
    required this.onUpdateOdometer,
    required this.onAddService,
    required this.onAddVehicle,
  });

  final ValueChanged<Vehicle> onUpdateOdometer;
  final ValueChanged<Vehicle> onAddService;
  final VoidCallback onAddVehicle;

  /// Opens the sheet above the whole app.
  static Future<void> show(
    BuildContext context, {
    required ValueChanged<Vehicle> onUpdateOdometer,
    required ValueChanged<Vehicle> onAddService,
    required VoidCallback onAddVehicle,
  }) => showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => QuickActionsSheet(
      onUpdateOdometer: onUpdateOdometer,
      onAddService: onAddService,
      onAddVehicle: onAddVehicle,
    ),
  );

  /// The vehicle entries are saved for: the default one, else the first.
  static Vehicle? activeVehicle(List<Vehicle> vehicles) =>
      vehicles.where((v) => v.isDefault).firstOrNull ?? vehicles.firstOrNull;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final active = activeVehicle(ref.watch(vehiclesProvider).value ?? const []);
    void close(VoidCallback then) {
      Navigator.of(context).pop();
      then();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: scheme.tertiary, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.quickActionsTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.quickActionsClose,
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: scheme.surfaceContainer,
                  foregroundColor: scheme.onSurfaceVariant,
                ),
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (active != null) ...[
            _ActiveVehicleBanner(vehicle: active),
            const SizedBox(height: 12),
          ],
          _ActionRow(
            icon: Icons.speed,
            tone: tones.amber,
            title: l10n.odometerTitle,
            body: l10n.quickActionOdometerBody,
            onTap: active == null ? null : () => close(() => onUpdateOdometer(active)),
          ),
          _ActionRow(
            icon: Icons.build_outlined,
            tone: tones.neutral,
            title: l10n.quickActionServiceTitle,
            body: l10n.quickActionServiceBody,
            onTap: active == null ? null : () => close(() => onAddService(active)),
          ),
          _ActionRow(
            icon: Icons.local_gas_station_outlined,
            tone: tones.neutral,
            title: l10n.quickActionFuelTitle,
            body: l10n.quickActionFuelBody,
          ),
          _ActionRow(
            icon: Icons.receipt_long_outlined,
            tone: tones.neutral,
            title: l10n.quickActionExpenseTitle,
            body: l10n.quickActionExpenseBody,
          ),
          Divider(height: 13, thickness: 1, color: scheme.surfaceContainerHighest),
          _ActionRow(
            icon: Icons.directions_car_outlined,
            tone: tones.neutral,
            title: l10n.quickActionAddVehicleTitle,
            tag: l10n.quickActionGarageTag,
            body: l10n.quickActionAddVehicleBody,
            onTap: () => close(onAddVehicle),
          ),
        ],
      ),
    );
  }
}

/// The vehicle new entries are saved for, with its plate.
class _ActiveVehicleBanner extends StatelessWidget {
  const _ActiveVehicleBanner({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.directions_car, size: 22, color: scheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        vehicle.nickname,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l10n.activeVehicleBadge,
                        style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.quickActionsScope,
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                Text(
                  plateText(vehicle.plate, l10n),
                  style: theme.textTheme.labelSmall?.copyWith(color: AppTones.of(context).muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One 64dp entry: tinted icon tile, title (and optional tag), one-line description, chevron.
/// Without [onTap] it is shown disabled (its page isn't built yet, or no vehicle exists).
class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.tone,
    required this.title,
    required this.body,
    this.tag,
    this.onTap,
  });

  final IconData icon;
  final ToneColors tone;
  final String title;
  final String body;
  final String? tag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = onTap != null;
    return Semantics(
      enabled: enabled,
      hint: enabled ? null : l10n.quickActionUnavailable,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: tone.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 24, color: tone.foreground),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                            if (tag case final tag?) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // chevron_right mirrors to point left (forward) in RTL.
                  Icon(Icons.chevron_right, size: 20, color: scheme.outline),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
