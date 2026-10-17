import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import 'phone_input_formatter.dart';

/// Phone field with the fixed Iran `+98` prefix, laid out left to right as in the design.
/// Shows a check mark once [isComplete].
class PhoneInputField extends StatefulWidget {
  const PhoneInputField({super.key, required this.controller, required this.isComplete});

  final TextEditingController controller;
  final bool isComplete;

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  /// Line box of the digits and the hint, as a multiple of the 14px font size.
  static const _lineHeight = 1.4;

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final focused = _focusNode.hasFocus;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 48,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: focused ? scheme.surfaceContainerLowest : scheme.surface,
          borderRadius: AppTheme.radius,
          border: Border.all(color: focused ? scheme.primary : scheme.surfaceContainerHighest),
          boxShadow: [
            if (focused) BoxShadow(color: scheme.primary.withValues(alpha: 0.1), spreadRadius: 2),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _CountryPrefix(),
            // A collapsed field centered in the 48px row, with a fixed line box (strut) so
            // Vazirmatn's tall ascent/descent cannot push the digits off center (seen on web).
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  inputFormatters: const [PhoneInputFormatter()],
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    height: _lineHeight,
                    leadingDistribution: TextLeadingDistribution.even,
                    color: scheme.primary,
                  ),
                  strutStyle: const StrutStyle(
                    fontSize: 14,
                    height: _lineHeight,
                    leadingDistribution: TextLeadingDistribution.even,
                    forceStrutHeight: true,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: AppLocalizations.of(context).authPhoneHint,
                    hintStyle: TextStyle(color: scheme.outline),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ),
            if (widget.isComplete)
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 12),
                child: Icon(Icons.check_circle, size: 20, color: AppTones.of(context).success),
              ),
          ],
        ),
      ),
    );
  }
}

/// Iran flag, `+98` and a chevron. Iran is the only country, so it is not tappable.
class _CountryPrefix extends StatelessWidget {
  const _CountryPrefix();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border(right: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SvgPicture.asset('assets/images/flag_ir.svg', width: 20, height: 14),
          ),
          const SizedBox(width: 6),
          Text(
            AppLocalizations.of(context).authCountryCode,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: scheme.secondary,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down, size: 14, color: scheme.outline),
        ],
      ),
    );
  }
}
