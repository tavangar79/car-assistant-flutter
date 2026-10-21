import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';

/// Bottom sheet with day / month / year wheels on the Jalali calendar. Dates outside
/// [first]..[last] snap to the nearest end on confirm. [title] and [confirmLabel] default to the
/// birth-date wording.
class JalaliDatePickerSheet extends StatefulWidget {
  const JalaliDatePickerSheet({
    super.key,
    required this.initial,
    required this.first,
    required this.last,
    this.title,
    this.confirmLabel,
  });

  final DateTime initial;
  final DateTime first;
  final DateTime last;
  final String? title;
  final String? confirmLabel;

  /// Opens the sheet; returns the chosen Gregorian date (local midnight), or `null` if dismissed.
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initial,
    required DateTime first,
    required DateTime last,
    String? title,
    String? confirmLabel,
  }) => showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => JalaliDatePickerSheet(
      initial: initial,
      first: first,
      last: last,
      title: title,
      confirmLabel: confirmLabel,
    ),
  );

  @override
  State<JalaliDatePickerSheet> createState() => _JalaliDatePickerSheetState();
}

class _JalaliDatePickerSheetState extends State<JalaliDatePickerSheet> {
  late final Jalali _first = Jalali.fromDateTime(widget.first);
  late final Jalali _last = Jalali.fromDateTime(widget.last);
  late int _year;
  late int _month;
  late int _day;

  @override
  void initState() {
    super.initState();
    final initial = Jalali.fromDateTime(widget.initial);
    _year = initial.year.clamp(_first.year, _last.year);
    _month = initial.month;
    _day = initial.day;
  }

  int get _monthLength => Jalali(_year, _month).monthLength;

  void _confirm() {
    var date = Jalali(_year, _month, _day.clamp(1, _monthLength));
    if (date < _first) date = _first;
    if (date > _last) date = _last;
    Navigator.of(context).pop(date.toDateTime());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tones = AppTones.of(context);
    final locale = l10n.localeName;
    final years = [for (var y = _first.year; y <= _last.year; y++) y];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _DragHandle(),
            const SizedBox(height: 12),
            _SheetHeader(
              title: widget.title ?? l10n.profilePickerTitle,
              onClose: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                for (final label in [
                  l10n.profilePickerDay,
                  l10n.profilePickerMonth,
                  l10n.profilePickerYear,
                ])
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(color: tones.muted),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 216,
              decoration: BoxDecoration(
                borderRadius: AppTheme.cardRadius,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  _Wheel(
                    // A new month may have fewer days: rebuild the wheel at a valid day.
                    key: ValueKey('day-$_monthLength'),
                    labels: [for (var d = 1; d <= _monthLength; d++) localizeDigits('$d', locale)],
                    selected: _day.clamp(1, _monthLength) - 1,
                    onChanged: (i) => setState(() => _day = i + 1),
                  ),
                  _Wheel(
                    key: const ValueKey('month'),
                    labels: [for (var m = 1; m <= 12; m++) l10n.jalaliMonth('$m')],
                    selected: _month - 1,
                    onChanged: (i) => setState(() => _month = i + 1),
                  ),
                  _Wheel(
                    key: const ValueKey('year'),
                    labels: [for (final y in years) localizeDigits('$y', locale)],
                    selected: years.indexOf(_year),
                    onChanged: (i) => setState(() => _year = years[i]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.profilePickerHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _confirm,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(widget.confirmLabel ?? l10n.profilePickerConfirm),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(88, 56),
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    foregroundColor: tones.muted,
                  ),
                  child: Text(l10n.profilePickerCancel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.event, size: 22, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.profilePickerClose,
          onPressed: onClose,
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainer,
            foregroundColor: AppTones.of(context).muted,
          ),
          icon: const Icon(Icons.close, size: 18),
        ),
      ],
    );
  }
}

/// One wheel column; the centered item is selected.
class _Wheel extends StatelessWidget {
  const _Wheel({super.key, required this.labels, required this.selected, required this.onChanged});

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 44,
        scrollController: FixedExtentScrollController(initialItem: selected),
        onSelectedItemChanged: onChanged,
        selectionOverlay: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.7),
            borderRadius: AppTheme.radius,
          ),
        ),
        children: [
          for (final label in labels)
            Center(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
