import '../../domain/entities/interval_setting.dart';

/// Body of `PUT /api/vehicles/:id/intervals`: `{ intervals: [ { id, km, months } ] }`.
class SetIntervalsRequestDto {
  const SetIntervalsRequestDto(this.settings);

  final List<IntervalSetting> settings;

  Map<String, dynamic> toJson() => {
    'intervals': [
      for (final setting in settings)
        {'id': setting.id, 'km': setting.km, 'months': setting.months},
    ],
  };
}
