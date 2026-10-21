import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Car identity in charts (DESIGN.md "Chart series"): a fixed color per vehicle slot, never a
/// status color. Read with `ChartPalette.of(context)`.
@immutable
class ChartPalette extends ThemeExtension<ChartPalette> {
  const ChartPalette({required this.series, required this.overflow});

  /// One color per vehicle, in garage order.
  final List<Color> series;

  /// Every vehicle after [series] runs out (`سایر`).
  final Color overflow;

  static const light = ChartPalette(
    series: [AppColors.chartBlue, AppColors.chartCyan, AppColors.chartViolet, AppColors.chartPink],
    overflow: AppColors.slate500,
  );

  static ChartPalette of(BuildContext context) =>
      Theme.of(context).extension<ChartPalette>() ?? light;

  /// The color of the vehicle in slot [index].
  Color colorAt(int index) => index < series.length ? series[index] : overflow;

  @override
  ChartPalette copyWith({List<Color>? series, Color? overflow}) =>
      ChartPalette(series: series ?? this.series, overflow: overflow ?? this.overflow);

  @override
  ChartPalette lerp(ChartPalette? other, double t) {
    if (other == null || other.series.length != series.length) return this;
    return ChartPalette(
      series: [for (var i = 0; i < series.length; i++) Color.lerp(series[i], other.series[i], t)!],
      overflow: Color.lerp(overflow, other.overflow, t)!,
    );
  }
}
