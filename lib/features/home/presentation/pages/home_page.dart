import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../dashboard/domain/entities/dashboard.dart';
import '../../../dashboard/presentation/open_history.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../odometer/presentation/widgets/odometer_sheet.dart';
import '../../../shell/presentation/widgets/quick_actions_sheet.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../../vehicles/presentation/widgets/empty_garage.dart';
import '../widgets/fleet_strip.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/spend_chart_card.dart';
import '../widgets/summary_tiles.dart';
import '../widgets/update_odometer_cta.dart';

/// The Home tab: "داشبورد کلی گاراژ" (Stitch `8acbd7d603f54b068264028fb2e0dd85`). The garage
/// strip, the summary tiles and the 6-month spend chart (from `GET /api/dashboard`) and the odometer
/// update. Without vehicles it shows the empty garage.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: ref
          .watch(vehiclesProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => LoadErrorView(
              message: l10n.vehiclesLoadError,
              onRetry: () => ref.invalidate(vehiclesProvider),
            ),
            data: (vehicles) => vehicles.isEmpty
                ? EmptyGarage(onAddVehicle: () => context.push(AppRoutes.addVehiclePath))
                : _Dashboard(vehicles: vehicles),
          ),
    );
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard({required this.vehicles});

  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final active = QuickActionsSheet.activeVehicle(vehicles)!;
    const gap = SizedBox(height: 24);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        FleetStrip(
          vehicles: vehicles,
          onManage: () => context.go(AppRoutes.vehiclesPath),
          onOpenVehicle: (vehicle) => context.go(AppRoutes.vehicleDetailsPath(vehicle.id)),
        ),
        gap,
        ref
            .watch(dashboardProvider)
            .when(
              loading: () =>
                  const SizedBox(height: 240, child: Center(child: CircularProgressIndicator())),
              error: (_, _) => SizedBox(
                height: 240,
                child: LoadErrorView(
                  message: l10n.dashboardLoadError,
                  onRetry: () => ref.invalidate(dashboardProvider),
                ),
              ),
              data: (dashboard) => _DashboardFigures(dashboard: dashboard, vehicles: vehicles),
            ),
        const SizedBox(height: 28),
        UpdateOdometerCta(onPressed: () => OdometerSheet.show(context, vehicleId: active.id)),
      ],
    );
  }
}

/// The summary tiles and the spend chart, from the dashboard.
class _DashboardFigures extends ConsumerWidget {
  const _DashboardFigures({required this.dashboard, required this.vehicles});

  final Dashboard dashboard;
  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attentionVehicle = dashboard.firstVehicleNeedingAttention;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SummaryTiles(
          yearTotalCost: dashboard.yearTotalCost,
          invoiceCount: dashboard.invoiceCount,
          attentionCount: dashboard.attentionCount,
          onOpenCost: () => openHistory(context, ref, HistoryPreset.currentYear),
          onOpenInvoices: () => openHistory(context, ref, HistoryPreset.withAttachments),
          onOpenAttention: attentionVehicle == null
              ? null
              : () => context.push(AppRoutes.duePath(attentionVehicle)),
        ),
        const SizedBox(height: 24),
        SpendChartCard(months: dashboard.months, vehicles: vehicles),
      ],
    );
  }
}
