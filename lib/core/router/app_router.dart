import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/complete_profile_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/phone_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/otp_args.dart';
import '../../features/documents/presentation/pages/document_form_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/documents/presentation/providers/document_form_args.dart';
import '../../features/expenses/presentation/pages/new_expense_page.dart';
import '../../features/fuel/presentation/pages/new_fuel_page.dart';
import '../../features/history/presentation/pages/history_filter_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/intervals/presentation/pages/due_services_page.dart';
import '../../features/intervals/presentation/pages/service_intervals_page.dart';
import '../../features/intervals/presentation/widgets/due_success_card.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/plans/presentation/pages/plans_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/reports/presentation/pages/report_export_page.dart';
import '../../features/services/presentation/pages/new_service_page.dart';
import '../../features/services/presentation/pages/service_details_page.dart';
import '../../features/shell/presentation/pages/app_shell.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/transfers/presentation/pages/transfer_page.dart';
import '../../features/vehicles/presentation/pages/add_vehicle_page.dart';
import '../../features/vehicles/presentation/pages/vehicle_details_page.dart';
import '../../features/vehicles/domain/entities/vehicle.dart';
import '../../features/vehicles/presentation/pages/vehicles_page.dart';
import 'app_routes.dart';
import 'auth_redirect.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // Re-run the redirect whenever the sign-in state changes (e.g. logout).
  final authChanges = ValueNotifier(ref.read(authStatusProvider));
  ref.listen(authStatusProvider, (_, next) => authChanges.value = next);

  final router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: authChanges,
    redirect: (context, state) => authRedirect(ref.read(authStatusProvider), state.matchedLocation),
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.phonePath,
        name: AppRoutes.phoneName,
        builder: (context, state) => const PhonePage(),
        routes: [
          GoRoute(
            path: 'otp',
            name: AppRoutes.otpName,
            // Without arguments (e.g. a restored deep link) start again from the phone page.
            redirect: (context, state) => state.extra is OtpArgs ? null : AppRoutes.phonePath,
            builder: (context, state) => OtpPage(args: state.extra! as OtpArgs),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.completeProfilePath,
        name: AppRoutes.completeProfileName,
        builder: (context, state) => const CompleteProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.addVehiclePath,
        name: AppRoutes.addVehicleName,
        builder: (context, state) => const AddVehiclePage(),
      ),
      GoRoute(
        path: AppRoutes.editVehiclePath,
        name: AppRoutes.editVehicleName,
        // Without a vehicle (e.g. a restored deep link) go back to the garage.
        redirect: (context, state) => state.extra is Vehicle ? null : AppRoutes.vehiclesPath,
        builder: (context, state) => AddVehiclePage(vehicle: state.extra! as Vehicle),
      ),
      // Before the shell, so `services/new` is not taken for a service id.
      GoRoute(
        path: '/vehicles/:id/services/new',
        name: AppRoutes.newServiceName,
        builder: (context, state) => NewServicePage(
          vehicleId: state.pathParameters['id']!,
          preselectedItemIds: switch (state.extra) {
            final List<String> ids => ids,
            _ => const [],
          },
        ),
      ),
      GoRoute(
        path: '/vehicles/:id/fuel/new',
        name: AppRoutes.newFuelName,
        builder: (context, state) => NewFuelPage(vehicleId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/vehicles/:id/expenses/new',
        name: AppRoutes.newExpenseName,
        builder: (context, state) => NewExpensePage(vehicleId: state.pathParameters['id']!),
      ),
      // Before the shell too: opened above every tab right after an odometer update.
      GoRoute(
        path: '/vehicles/:id/due',
        name: AppRoutes.dueName,
        builder: (context, state) => DueServicesPage(
          vehicleId: state.pathParameters['id']!,
          args: switch (state.extra) {
            final OdometerUpdateArgs args => args,
            _ => null,
          },
        ),
      ),
      // Before the shell too: opened from the garage tools and from the notifications.
      GoRoute(
        path: '/vehicles/:id/documents',
        name: AppRoutes.documentsName,
        builder: (context, state) => DocumentsPage(vehicleId: state.pathParameters['id']!),
      ),
      // Before the edit route, so `new` is not taken for a document id.
      GoRoute(
        path: '/vehicles/:id/documents/new',
        name: AppRoutes.newDocumentName,
        builder: (context, state) => DocumentFormPage(
          vehicleId: state.pathParameters['id']!,
          args: switch (state.extra) {
            final DocumentFormArgs args => args,
            _ => const DocumentFormArgs(),
          },
        ),
      ),
      GoRoute(
        path: '/vehicles/:id/documents/:documentId',
        name: AppRoutes.editDocumentName,
        builder: (context, state) => DocumentFormPage(
          vehicleId: state.pathParameters['id']!,
          documentId: state.pathParameters['documentId'],
        ),
      ),
      GoRoute(
        path: '/vehicles/:id/transfer',
        name: AppRoutes.transferName,
        builder: (context, state) => TransferPage(vehicleId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.notificationsPath,
        name: AppRoutes.notificationsName,
        builder: (context, state) => const NotificationsPage(),
      ),
      // Before the shell, so `/history/filter` is not taken by the History tab.
      GoRoute(
        path: AppRoutes.historyFilterPath,
        name: AppRoutes.historyFilterName,
        builder: (context, state) => const HistoryFilterPage(),
      ),
      GoRoute(
        path: AppRoutes.reportExportPath,
        name: AppRoutes.reportExportName,
        builder: (context, state) =>
            ReportExportPage(vehicleId: state.uri.queryParameters['vehicleId']),
      ),
      GoRoute(
        path: AppRoutes.plansPath,
        name: AppRoutes.plansName,
        builder: (context, state) => const PlansPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          _tab(AppRoutes.homePath, AppRoutes.homeName, const HomePage()),
          _tab(
            AppRoutes.vehiclesPath,
            AppRoutes.vehiclesName,
            const VehiclesPage(),
            routes: [
              GoRoute(
                path: ':id',
                name: AppRoutes.vehicleDetailsName,
                builder: (context, state) =>
                    VehicleDetailsPage(vehicleId: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'services/:serviceId',
                    name: AppRoutes.serviceDetailsName,
                    builder: (context, state) => ServiceDetailsPage(
                      vehicleId: state.pathParameters['id']!,
                      serviceId: state.pathParameters['serviceId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'intervals',
                    name: AppRoutes.intervalsName,
                    builder: (context, state) =>
                        ServiceIntervalsPage(vehicleId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          _tab(
            AppRoutes.historyPath,
            AppRoutes.historyName,
            const HistoryPage(),
            routes: [
              GoRoute(
                path: 'services/:vehicleId/:serviceId',
                name: AppRoutes.historyServiceName,
                builder: (context, state) => ServiceDetailsPage(
                  vehicleId: state.pathParameters['vehicleId']!,
                  serviceId: state.pathParameters['serviceId']!,
                ),
              ),
            ],
          ),
          _tab(AppRoutes.profilePath, AppRoutes.profileName, const ProfilePage()),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    authChanges.dispose();
  });
  return router;
});

StatefulShellBranch _tab(
  String path,
  String name,
  Widget page, {
  List<RouteBase> routes = const [],
}) => StatefulShellBranch(
  routes: [GoRoute(path: path, name: name, builder: (context, state) => page, routes: routes)],
);
