import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../widgets/bottom_nav_dock.dart';

/// Signed-in frame: the current tab with the bottom dock under it. Each tab keeps its own state.
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
        onAdd: () => context.push(AppRoutes.addVehiclePath),
      ),
    );
  }
}
