import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/utils/localize_digits.dart';
import '../../../../../l10n/app_localizations.dart';

/// Bottom sheet with one wheel of Jalali years, newest ([last], marked "brand new") first.
class YearPickerSheet extends StatefulWidget {
  const YearPickerSheet({
    super.key,
    required this.initial,
    required this.first,
    required this.last,
  });

  final int initial;
  final int first;
  final int last;

  /// Opens the sheet; returns the chosen year, or `null` if dismissed.
  static Future<int?> show(
    BuildContext context, {
    required int initial,
    required int first,
    required int last,
  }) => showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => YearPickerSheet(initial: initial, first: first, last: last),
  );

  @override
  State<YearPickerSheet> createState() => _YearPickerSheetState();
}

class _YearPickerSheetState extends State<YearPickerSheet> {
  late final List<int> _years = [for (var y = widget.last; y >= widget.first; y--) y];
  late int _year = widget.initial.clamp(widget.first, widget.last);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.vehicleYearPickerTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                  ),
                ),
                IconButton(
                  tooltip: l10n.vehicleYearClose,
                  onPressed: () => Navigator.of(context).pop(),
                  color: AppTones.of(context).muted,
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            Divider(height: 1, color: scheme.surfaceContainerHigh),
            const SizedBox(height: 16),
            SizedBox(
              height: 192,
              child: CupertinoPicker(
                itemExtent: 48,
                scrollController: FixedExtentScrollController(initialItem: _years.indexOf(_year)),
                onSelectedItemChanged: (i) => setState(() => _year = _years[i]),
                selectionOverlay: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: AppTheme.radius,
                    border: Border.all(color: scheme.surfaceContainerHigh),
                  ),
                ),
                children: [
                  for (final year in _years)
                    Center(
                      child: Text(
                        _label(l10n, year),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_year),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              child: Text(l10n.vehicleYearConfirm),
            ),
          ],
        ),
      ),
    );
  }

  String _label(AppLocalizations l10n, int year) {
    final text = localizeDigits('$year', l10n.localeName);
    return year == widget.last ? l10n.vehicleYearZeroKm(text) : text;
  }
}
