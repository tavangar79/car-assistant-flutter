import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../../../vehicles/presentation/widgets/vehicle_form/mileage_field.dart';
import '../service_formats.dart';
import 'wizard_field.dart';

/// "جزئیات برچسب سرویس (اختیاری)": the next-service km on the oil-change sticker and the visit
/// time (tapping it opens the time picker).
class ServiceStickerCard extends StatelessWidget {
  const ServiceStickerCard({
    super.key,
    required this.stickerController,
    required this.visitMinutes,
    required this.onStickerChanged,
    required this.onPickTime,
  });

  final TextEditingController stickerController;

  /// The visit time as minutes since midnight.
  final int visitMinutes;
  final ValueChanged<String> onStickerChanged;
  final VoidCallback onPickTime;

  static DigitsInputFormatter formatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: MileageField.maxDigits, grouped: true);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final inputFormatter = formatter(l10n.localeName);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.label_outline, size: 20, color: scheme.secondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.serviceStickerTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.serviceStickerBody, style: theme.textTheme.bodySmall?.copyWith(color: muted)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: WizardField(
                  label: l10n.serviceStickerKmLabel,
                  child: TextField(
                    controller: stickerController,
                    onChanged: onStickerChanged,
                    keyboardType: TextInputType.number,
                    inputFormatters: [inputFormatter],
                    style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                    decoration: wizardInputDecoration(
                      context,
                      hint: inputFormatter.format('40000'),
                      suffix: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10),
                        child: Text(
                          l10n.vehicleMileageUnit,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: WizardField(
                  label: l10n.serviceVisitTimeLabel,
                  child: Material(
                    color: scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onPickTime,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                formatMinutes(visitMinutes, l10n.localeName),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                            Icon(Icons.schedule, size: 18, color: scheme.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
