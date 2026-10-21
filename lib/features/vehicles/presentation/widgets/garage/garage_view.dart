import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../odometer/presentation/widgets/odometer_sheet.dart';
import '../../../../shell/presentation/widgets/quick_actions_sheet.dart';
import '../../../domain/entities/vehicle.dart';
import '../../providers/vehicle_providers.dart';
import 'garage_header.dart';
import 'garage_tools_section.dart';
import 'garage_vehicle_card.dart';

/// The garage with at least one vehicle (Stitch "گاراژ من"): the heading, a card per vehicle,
/// then the garage tools.
class GarageView extends ConsumerWidget {
  const GarageView({super.key, required this.vehicles});

  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> setDefault(Vehicle vehicle) async {
      final messenger = ScaffoldMessenger.of(context);
      final message = AppLocalizations.of(context).garageSetDefaultError;
      final result = await ref.read(setDefaultVehicleProvider).call(vehicle);
      result.match(
        (_) => messenger.showSnackBar(SnackBar(content: Text(message))),
        (_) => ref.invalidate(vehiclesProvider),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        GarageHeader(
          count: vehicles.length,
          onAddVehicle: () => context.push(AppRoutes.addVehiclePath),
        ),
        for (final vehicle in vehicles) ...[
          const SizedBox(height: 16),
          GarageVehicleCard(
            vehicle: vehicle,
            onOpen: () => context.push(AppRoutes.vehicleDetailsPath(vehicle.id)),
            onEdit: () => context.push(AppRoutes.editVehiclePath, extra: vehicle),
            onSetDefault: () => setDefault(vehicle),
            onUpdateOdometer: () => OdometerSheet.show(context, vehicleId: vehicle.id),
          ),
        ],
        const SizedBox(height: 24),
        GarageToolsSection(
          onOpenDocuments: () =>
              context.push(AppRoutes.documentsPath(QuickActionsSheet.activeVehicle(vehicles)!.id)),
        ),
      ],
    );
  }
}
