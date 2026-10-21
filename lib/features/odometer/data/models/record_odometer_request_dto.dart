/// Body of `POST /api/vehicles/:id/odometer`: `{ mileageKm, recordedAt? }`, the date in ISO-8601 UTC.
class RecordOdometerRequestDto {
  const RecordOdometerRequestDto({required this.mileageKm, this.recordedAt});

  final int mileageKm;
  final DateTime? recordedAt;

  Map<String, dynamic> toJson() => {
    'mileageKm': mileageKm,
    if (recordedAt case final date?) 'recordedAt': date.toUtc().toIso8601String(),
  };
}
