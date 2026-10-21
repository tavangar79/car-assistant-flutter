import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/widgets/suggestion_text_field.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../../domain/entities/service_item.dart';
import '../../../domain/entities/service_line_item.dart';
import '../../../domain/entities/service_rules.dart';
import '../service_icon_tile.dart';
import '../wizard/reminder_fields.dart';
import '../wizard/service_line_card.dart';
import '../wizard/wizard_field.dart';

/// Edits one item of a saved visit (brand, cost, notes and the reminder) in a bottom sheet.
/// [brandSuggestions] are the brands used before for this item. Returns the new
/// [ServiceLineItem], or `null` when dismissed.
class LineItemEditorSheet extends StatefulWidget {
  const LineItemEditorSheet({
    super.key,
    required this.item,
    required this.baseKm,
    required this.baseDate,
    this.brandSuggestions = const [],
    this.initial,
  });

  final ServiceItem item;
  final int baseKm;
  final DateTime baseDate;
  final List<String> brandSuggestions;

  /// The current values in edit mode; `null` when adding the item.
  final ServiceLineItem? initial;

  static Future<ServiceLineItem?> show(
    BuildContext context, {
    required ServiceItem item,
    required int baseKm,
    required DateTime baseDate,
    List<String> brandSuggestions = const [],
    ServiceLineItem? initial,
  }) => showModalBottomSheet<ServiceLineItem>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => LineItemEditorSheet(
      item: item,
      baseKm: baseKm,
      baseDate: baseDate,
      brandSuggestions: brandSuggestions,
      initial: initial,
    ),
  );

  @override
  State<LineItemEditorSheet> createState() => _LineItemEditorSheetState();
}

class _LineItemEditorSheetState extends State<LineItemEditorSheet> {
  late final TextEditingController _brand = TextEditingController(
    text: widget.initial?.brand ?? '',
  );
  late final TextEditingController _notes = TextEditingController(
    text: widget.initial?.notes ?? '',
  );
  late final TextEditingController _cost;
  late final TextEditingController _km;
  late final TextEditingController _months;
  bool _created = false;
  bool _invalid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_created) return;
    _created = true;
    final locale = AppLocalizations.of(context).localeName;
    String digits(int? value, DigitsInputFormatter formatter) =>
        value == null ? '' : formatter.format('$value');
    _cost = TextEditingController(
      text: digits(widget.initial?.cost, ServiceLineCard.costFormatter(locale)),
    );
    _km = TextEditingController(
      text: digits(widget.initial?.nextDueKm, ReminderFields.kmFormatter(locale)),
    );
    _months = TextEditingController(
      text: digits(widget.initial?.nextDueMonths, ReminderFields.monthsFormatter(locale)),
    );
  }

  @override
  void dispose() {
    for (final controller in [_brand, _notes, _cost, _km, _months]) {
      controller.dispose();
    }
    super.dispose();
  }

  static int? _int(String text) => int.tryParse(DigitsInputFormatter.digitsOf(text));

  ServiceLineItem get _line {
    final brand = _brand.text.trim();
    final notes = _notes.text.trim();
    return ServiceLineItem(
      itemId: widget.item.id,
      brand: brand.isEmpty ? null : brand,
      cost: _int(_cost.text) ?? 0,
      notes: notes.isEmpty ? null : notes,
      nextDueKm: _int(_km.text),
      nextDueMonths: _int(_months.text),
    );
  }

  void _save() {
    final line = _line;
    if (!ServiceRules.isValidLine(line)) {
      setState(() => _invalid = true);
      return;
    }
    Navigator.of(context).pop(line);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final locale = l10n.localeName;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ServiceIconTile(icon: widget.item.icon, tone: tones.amber, size: 40, iconSize: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.initial == null
                            ? l10n.serviceEditorTitleAdd
                            : l10n.serviceEditorTitleEdit,
                        style: theme.textTheme.labelSmall?.copyWith(color: tones.muted),
                      ),
                      Text(
                        widget.item.title,
                        style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.quickActionsClose,
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: scheme.surfaceContainer,
                    foregroundColor: scheme.onSurfaceVariant,
                  ),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            WizardField(
              label: l10n.serviceCostLabel,
              child: TextField(
                controller: _cost,
                onChanged: (_) => setState(() => _invalid = false),
                keyboardType: TextInputType.number,
                inputFormatters: [ServiceLineCard.costFormatter(locale)],
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
                decoration: wizardInputDecoration(
                  context,
                  hint: ServiceLineCard.costFormatter(locale).format('0'),
                  suffix: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16),
                    child: Text(
                      l10n.currencyToman,
                      style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            WizardField(
              label: l10n.serviceBrandLabel,
              child: SuggestionTextField(
                controller: _brand,
                suggestions: widget.brandSuggestions,
                onChanged: (_) => setState(() => _invalid = false),
                maxLength: ServiceRules.brandMaxLength,
                style: theme.textTheme.bodyMedium,
                decoration: wizardInputDecoration(
                  context,
                  prefixIcon: Icon(
                    Icons.verified_outlined,
                    size: 20,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            WizardField(
              label: l10n.serviceNotesLabel,
              child: TextField(
                controller: _notes,
                onChanged: (_) => setState(() => _invalid = false),
                maxLength: ServiceRules.lineNotesMaxLength,
                minLines: 2,
                maxLines: 4,
                style: theme.textTheme.bodySmall,
                decoration: wizardInputDecoration(context),
              ),
            ),
            const SizedBox(height: 16),
            ReminderFields(
              kmController: _km,
              monthsController: _months,
              nextDueKm: _int(_km.text),
              nextDueMonths: _int(_months.text),
              baseKm: widget.baseKm,
              baseDate: widget.baseDate,
              onKmChanged: (_) => setState(() => _invalid = false),
              onMonthsChanged: (_) => setState(() => _invalid = false),
            ),
            if (_invalid) ...[const SizedBox(height: 8), AuthErrorText(l10n.serviceLineItemsError)],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: Text(l10n.serviceEditorSave),
            ),
          ],
        ),
      ),
    );
  }
}
