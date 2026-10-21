import '../../domain/entities/profile_stats.dart';

/// `GET /api/profile/stats` → `{ "stats": { "vehicleCount", "serviceCount" } }`.
class ProfileStatsDto {
  const ProfileStatsDto({required this.vehicleCount, required this.serviceCount});

  /// Parses the `{ "stats": … }` envelope.
  factory ProfileStatsDto.fromEnvelope(Map<String, dynamic> json) =>
      ProfileStatsDto.fromJson(json['stats'] as Map<String, dynamic>);

  factory ProfileStatsDto.fromJson(Map<String, dynamic> json) => ProfileStatsDto(
    vehicleCount: (json['vehicleCount'] as num).toInt(),
    serviceCount: (json['serviceCount'] as num).toInt(),
  );

  final int vehicleCount;
  final int serviceCount;

  ProfileStats toEntity() => ProfileStats(vehicleCount: vehicleCount, serviceCount: serviceCount);
}
