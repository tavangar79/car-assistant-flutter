import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/main_app_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/vehicles_view.dart';

/// The Garage tab. The app bar shows the vehicle count once the list has loaded.
class VehiclesPage extends ConsumerWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final count = ref.watch(vehiclesProvider).value?.length;
    return Scaffold(
      appBar: MainAppBar(
        title: l10n.navGarage,
        subtitle: count == null ? null : l10n.garageVehicleCount(count),
      ),
      body: const VehiclesView(),
    );
  }
}
