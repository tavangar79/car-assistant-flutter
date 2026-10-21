import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/empty_garage.dart';
import '../widgets/garage/garage_view.dart';

/// The Garage tab. With vehicles it is Stitch "گاراژ من" (`7e67f2261e4548858c5f8fc227a781d9`):
/// the count as a pill next to the title and a history button. Without vehicles it is
/// "گاراژ خالی" (`b758f9e06d2b444f95d26b3532376195`): the count under the title and the empty card.
class VehiclesPage extends ConsumerWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final vehicles = ref.watch(vehiclesProvider);
    final count = vehicles.value?.length;
    return Scaffold(
      appBar: count != null && count > 0
          ? MainAppBar(
              title: l10n.navGarage,
              badge: l10n.garageVehicleCount(count),
              actions: [
                IconButton(
                  tooltip: l10n.garageHistoryTooltip,
                  onPressed: () => context.go(AppRoutes.historyPath),
                  iconSize: 22,
                  constraints: const BoxConstraints.tightFor(width: 48, height: 48),
                  icon: const Icon(Icons.history),
                ),
                const SizedBox(width: 8),
              ],
            )
          : MainAppBar(
              title: l10n.navGarage,
              subtitle: count == null ? null : l10n.garageVehicleCount(count),
            ),
      body: vehicles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(
          message: l10n.vehiclesLoadError,
          onRetry: () => ref.invalidate(vehiclesProvider),
        ),
        data: (items) => items.isEmpty
            ? EmptyGarage(onAddVehicle: () => context.push(AppRoutes.addVehiclePath))
            : GarageView(vehicles: items),
      ),
    );
  }
}
