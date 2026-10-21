import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../odometer/presentation/widgets/odometer_sheet.dart';
import '../widgets/bottom_nav_dock.dart';
import '../widgets/quick_actions_sheet.dart';

/// Signed-in frame: the current tab with the bottom dock under it. Each tab keeps its own state.
/// The dock's add button opens the quick actions sheet.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavDock(
        currentIndex: navigationShell.currentIndex,
        // Tapping the current tab again returns it to its first page.
        onTabSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        onAdd: () => QuickActionsSheet.show(
          context,
          onUpdateOdometer: (vehicle) => OdometerSheet.show(context, vehicleId: vehicle.id),
          onAddService: (vehicle) => context.push(AppRoutes.newServicePath(vehicle.id)),
          onAddFuel: (vehicle) => context.push(AppRoutes.newFuelPath(vehicle.id)),
          onAddExpense: (vehicle) => context.push(AppRoutes.newExpensePath(vehicle.id)),
          onAddVehicle: () => context.push(AppRoutes.addVehiclePath),
        ),
      ),
    );
  }
}
