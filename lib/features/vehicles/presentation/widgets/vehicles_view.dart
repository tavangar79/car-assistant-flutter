import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/vehicle_providers.dart';
import 'empty_garage.dart';
import 'vehicle_tile.dart';

/// The user's vehicles from [vehiclesProvider]: the empty garage when there are none, a list otherwise.
/// Shared by the Home and Garage tabs.
class VehiclesView extends ConsumerWidget {
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(vehiclesProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _ErrorView(
            message: l10n.vehiclesLoadError,
            onRetry: () => ref.invalidate(vehiclesProvider),
          ),
          data: (items) => items.isEmpty
              ? EmptyGarage(onAddVehicle: () => context.push(AppRoutes.addVehiclePath))
              : ListView(children: [for (final v in items) VehicleTile(vehicle: v)]),
        );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: Text(AppLocalizations.of(context).retry)),
        ],
      ),
    );
  }
}
