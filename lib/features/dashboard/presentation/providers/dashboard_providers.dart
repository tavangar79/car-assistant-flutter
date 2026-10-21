import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard.dart';

// Dependency wiring for the dashboard. Override [dashboardRepositoryProvider] in tests.

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(DashboardRemoteDataSource(ref.watch(dioProvider)));
});

final getDashboardProvider = Provider<GetDashboard>((ref) {
  return GetDashboard(ref.watch(dashboardRepositoryProvider));
});

/// The garage dashboard. Invalidate it after a write that changes a cost, an invoice, a due item
/// or the garage.
final dashboardProvider = FutureProvider.autoDispose<Dashboard>((ref) async {
  final dashboard = await ref.watch(getDashboardProvider).call();
  return dashboard.getOrElse((failure) => throw failure);
});
