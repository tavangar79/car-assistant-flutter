import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../intervals/presentation/widgets/due_section.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../odometer/presentation/widgets/odometer_sheet.dart';
import '../../../services/presentation/widgets/service_history_section.dart';
import '../../domain/entities/vehicle.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/vehicle_details/mileage_card.dart';
import '../widgets/vehicle_details/vehicle_summary_card.dart';
import '../widgets/vehicle_options_menu.dart';

/// "جزئیات خودرو" (Stitch `50ada0c7b66e446587de52803c726122`): the vehicle's identity and plate,
/// its mileage with the odometer update, the upcoming services (empty until the due computation
/// lands) and the last service visits. Opened from the garage list, inside the Garage tab.
class VehicleDetailsPage extends ConsumerWidget {
  const VehicleDetailsPage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final vehicle = ref.watch(vehicleProvider(vehicleId));
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
        title: Text(l10n.vehicleDetailsTitle, style: theme.textTheme.headlineMedium),
        actions: [
          if (vehicle.value case final loaded?)
            VehicleOptionsMenu(
              onEdit: () => context.push(AppRoutes.editVehiclePath, extra: loaded),
            ),
          Semantics(
            label: l10n.accountLabel,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.person, size: 18, color: theme.colorScheme.onPrimary),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: vehicle.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.vehicleDetailsLoadError),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(vehicleProvider(vehicleId)),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (vehicle) => _DetailsBody(vehicle: vehicle),
      ),
    );
  }
}

class _DetailsBody extends ConsumerWidget {
  const _DetailsBody({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final readings = ref.watch(odometerReadingsProvider(vehicle.id)).value;
    const gap = SizedBox(height: 24);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        VehicleSummaryCard(vehicle: vehicle),
        gap,
        MileageCard(
          mileageKm: vehicle.mileageKm,
          lastReadingAt: readings?.firstOrNull?.recordedAt,
          onUpdate: () => OdometerSheet.show(context, vehicleId: vehicle.id),
        ),
        gap,
        DueSection(
          vehicleId: vehicle.id,
          onOpenDue: () => context.push(AppRoutes.duePath(vehicle.id)),
          onOpenSettings: () => context.push(AppRoutes.intervalsPath(vehicle.id)),
        ),
        gap,
        ServiceHistorySection(
          vehicleId: vehicle.id,
          onOpen: (visit) => context.push(AppRoutes.serviceDetailsPath(vehicle.id, visit.id)),
        ),
        const SizedBox(height: 4),
        // The report export comes with the services; until then the button is shown disabled.
        TextButton.icon(
          onPressed: null,
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          ),
          icon: const Icon(Icons.file_download_outlined, size: 18),
          label: Text(l10n.vehicleDetailsExport),
        ),
      ],
    );
  }
}
