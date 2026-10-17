import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/theme/vehicle_palette.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/plate.dart';
import 'digits_input_formatter.dart';
import 'form_field_header.dart';
import 'form_help_text.dart';
import 'form_section_card.dart';

/// The Iranian plate as one strip (Stitch): blue IR band, two digits, letter picker, three digits
/// and the province code under "ایران". Digits show in the locale's script; read them back with
/// `DigitsInputFormatter.digitsOf`. The strip is always laid out right to left, like the design.
class PlateInput extends StatelessWidget {
  const PlateInput({
    super.key,
    required this.twoDigits,
    required this.letter,
    required this.threeDigits,
    required this.provinceCode,
    required this.onLetterChanged,
    this.onChanged,
    this.error,
  });

  final TextEditingController twoDigits;
  final String? letter;
  final TextEditingController threeDigits;
  final TextEditingController provinceCode;
  final ValueChanged<String> onLetterChanged;

  /// Called when any digit box changes.
  final VoidCallback? onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final locale = l10n.localeName;
    final digitsStyle = Theme.of(context).textTheme.headlineLarge
        ?.copyWith(fontWeight: FontWeight.w700, color: scheme.onSurface);
    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormFieldHeader(
            label: l10n.vehiclePlateLabel,
            required: true,
            badge: l10n.vehiclePlateBadge,
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 340),
              height: 64,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: error == null ? scheme.outlineVariant : scheme.error),
                boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.08), blurRadius: 6)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _IranBand(),
                      SizedBox(
                        width: 56,
                        child: _DigitsBox(
                          controller: twoDigits,
                          maxDigits: 2,
                          locale: locale,
                          label: l10n.vehiclePlateTwoDigits,
                          style: digitsStyle,
                          onChanged: onChanged,
                        ),
                      ),
                      SizedBox(
                        width: 64,
                        child: _LetterPicker(letter: letter, onChanged: onLetterChanged),
                      ),
                      Expanded(
                        child: _DigitsBox(
                          controller: threeDigits,
                          maxDigits: 3,
                          locale: locale,
                          label: l10n.vehiclePlateThreeDigits,
                          style: digitsStyle,
                          onChanged: onChanged,
                        ),
                      ),
                      SizedBox(
                        width: 56,
                        child: _ProvinceBox(
                          controller: provinceCode,
                          locale: locale,
                          onChanged: onChanged,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FormHelpText(help: l10n.vehiclePlateHelp, error: error),
        ],
      ),
    );
  }
}

/// The blue strip with the flag and `I.R. / IRAN`.
class _IranBand extends StatelessWidget {
  const _IranBand();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = VehiclePalette.of(context);
    final style = TextStyle(
      fontSize: 7,
      height: 8 / 7,
      fontWeight: FontWeight.w700,
      color: palette.onPlateBand,
    );
    return ExcludeSemantics(
      child: Container(
        width: 40,
        color: palette.plateBand,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset('assets/images/flag_ir.svg', width: 20, height: 14),
            Text(l10n.vehiclePlateBandTop, style: style, textDirection: TextDirection.ltr),
            Text(l10n.vehiclePlateBandBottom, style: style, textDirection: TextDirection.ltr),
          ],
        ),
      ),
    );
  }
}

class _DigitsBox extends StatelessWidget {
  const _DigitsBox({
    required this.controller,
    required this.maxDigits,
    required this.locale,
    required this.label,
    required this.style,
    this.onChanged,
  });

  final TextEditingController controller;
  final int maxDigits;
  final String locale;
  final String label;
  final TextStyle? style;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: label,
        child: TextField(
          controller: controller,
          onChanged: (_) => onChanged?.call(),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: style,
          inputFormatters: [DigitsInputFormatter(locale: locale, maxDigits: maxDigits)],
          decoration: const InputDecoration(
            isCollapsed: true,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          ),
        ),
      ),
    );
  }
}

/// Grey box with "ایران" over the two-digit province code.
class _ProvinceBox extends StatelessWidget {
  const _ProvinceBox({required this.controller, required this.locale, this.onChanged});

  final TextEditingController controller;
  final String locale;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surfaceContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExcludeSemantics(
            child: Text(
              l10n.vehiclePlateIran,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 9,
                height: 1,
                fontWeight: FontWeight.w700,
                color: AppTones.of(context).muted,
              ),
            ),
          ),
          _DigitsBox(
            controller: controller,
            maxDigits: 2,
            locale: locale,
            label: l10n.vehiclePlateProvince,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// The plate letter as a dropdown on a grey segment.
class _LetterPicker extends StatelessWidget {
  const _LetterPicker({required this.letter, required this.onChanged});

  final String? letter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
    );
    return Semantics(
      label: l10n.vehiclePlateLetter,
      child: ColoredBox(
        color: theme.colorScheme.surfaceContainer,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: letter,
            isExpanded: true,
            alignment: Alignment.center,
            padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
            iconSize: 14,
            icon: Icon(Icons.unfold_more, color: AppTones.of(context).muted),
            hint: Center(
              child: Text(l10n.vehiclePlateLetterHint, style: theme.textTheme.bodySmall),
            ),
            style: style,
            menuMaxHeight: 360,
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
            items: [
              for (final value in Plate.letters)
                DropdownMenuItem(
                  value: value,
                  alignment: Alignment.center,
                  child: Text(value, style: style),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
