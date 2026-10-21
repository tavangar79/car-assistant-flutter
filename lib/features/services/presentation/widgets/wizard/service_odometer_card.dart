import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/utils/calendar_days_ago.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../odometer/presentation/widgets/quick_adjust_buttons.dart';
import '../../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../../../vehicles/presentation/widgets/vehicle_form/mileage_field.dart';
import '../service_formats.dart';
import 'wizard_card.dart';

/// "کارکرد ثبت فاکتور": the large km input, the last reading with its date, the distance since
/// it and the quick-adjust buttons.
class ServiceOdometerCard extends StatelessWidget {
  const ServiceOdometerCard({
    super.key,
    required this.controller,
    required this.value,
    required this.currentMileageKm,
    required this.lastReadingAt,
    required this.now,
    required this.onChanged,
    required this.onAdjust,
  });

  final TextEditingController controller;

  /// The value in the input, in km.
  final int value;
  final int currentMileageKm;
  final DateTime? lastReadingAt;
  final DateTime now;
  final ValueChanged<String> onChanged;
  final ValueChanged<int> onAdjust;

  /// The input's formatter: locale digits with thousands separators.
  static DigitsInputFormatter formatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: MileageField.maxDigits, grouped: true);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final inputFormatter = formatter(l10n.localeName);
    final diff = value - currentMileageKm;
    final diffText =
        '${diff < 0 ? '-' : '+'}'
        '${NumberFormat.decimalPattern(l10n.localeName).format(diff.abs())}';
    final last = lastReadingAt?.toLocal();
    final lastText = last == null
        ? l10n.odometerLastRecorded(currentMileageKm)
        : l10n.serviceOdometerLastOn(
            currentMileageKm,
            formatJalaliDayMonth(last, l10n),
            l10n.relativeDaysAgo(calendarDaysAgo(last, now)),
          );
    return WizardCard(
      icon: Icons.speed,
      title: l10n.serviceOdometerTitle,
      trailing: WizardBadge(l10n.serviceOdometerBadge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.serviceOdometerLabel,
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  inputFormatters: [inputFormatter],
                  style: AppTextStyles.metricOdometer.copyWith(color: scheme.onSurface),
                  decoration: InputDecoration(
                    hintText: inputFormatter.format('0'),
                    hintStyle: TextStyle(color: scheme.outline),
                    filled: true,
                    fillColor: scheme.surfaceContainerLowest,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIconConstraints: const BoxConstraints(),
                    suffixIcon: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.vehicleMileageUnit,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.history, size: 16, color: scheme.secondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        lastText,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l10n.serviceOdometerDiff(diffText),
                        style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.serviceQuickAdjust, style: theme.textTheme.labelSmall?.copyWith(color: muted)),
          const SizedBox(height: 4),
          QuickAdjustButtons(onAdjust: onAdjust, showLabel: false),
        ],
      ),
    );
  }
}
