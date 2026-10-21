import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_stats.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_stats.dart';

// Dependency wiring for the profile page. Override [profileRepositoryProvider] in tests.

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ProfileRemoteDataSource(ref.watch(dioProvider)));
});

final getProfileStatsProvider = Provider<GetProfileStats>((ref) {
  return GetProfileStats(ref.watch(profileRepositoryProvider));
});

/// The vehicle and service counts. Invalidate it after adding a vehicle or a service visit.
final profileStatsProvider = FutureProvider.autoDispose<ProfileStats>((ref) async {
  final stats = await ref.watch(getProfileStatsProvider).call();
  return stats.getOrElse((failure) => throw failure);
});
