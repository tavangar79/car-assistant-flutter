import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/widgets/suggestion_text_field.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../../domain/entities/service_item.dart';
import '../../../domain/entities/service_line_draft.dart';
import '../../../domain/entities/service_rules.dart';
import '../service_icon_tile.dart';
import 'reminder_fields.dart';
import 'wizard_field.dart';

/// One item card of step 3 (Stitch `262e74911b5b45158bec636a3f484ef4`): cost, brand (with the
/// brands used before for this item as suggestions), notes and the reminder. The workshop and
/// the invoice are on the shared card above.
class ServiceLineCard extends StatefulWidget {
  const ServiceLineCard({
    super.key,
    required this.item,
    required this.index,
    required this.count,
    required this.line,
    required this.baseKm,
    required this.baseDate,
    required this.brandSuggestions,
    required this.onLineChanged,
    required this.onRemove,
    this.lineError,
  });

  final ServiceItem item;

  /// 0-based position among the visit's items.
  final int index;
  final int count;
  final ServiceLineDraft line;
  final int baseKm;
  final DateTime baseDate;
  final List<String> brandSuggestions;
  final ValueChanged<ServiceLineDraft> onLineChanged;
  final VoidCallback onRemove;
  final String? lineError;

  /// Cost in toman: locale digits with thousands separators, up to 12 digits.
  static DigitsInputFormatter costFormatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: 12, grouped: true);

  @override
  State<ServiceLineCard> createState() => _ServiceLineCardState();
}

class _ServiceLineCardState extends State<ServiceLineCard> {
  late final TextEditingController _cost;
  late final TextEditingController _brand = TextEditingController(text: widget.line.brand);
  late final TextEditingController _notes = TextEditingController(text: widget.line.notes);
  late final TextEditingController _km;
  late final TextEditingController _months;
  bool _created = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_created) return;
    _created = true;
    final locale = AppLocalizations.of(context).localeName;
    String digits(int? value, DigitsInputFormatter formatter) =>
        value == null ? '' : formatter.format('$value');
    _cost = TextEditingController(
      text: digits(widget.line.cost, ServiceLineCard.costFormatter(locale)),
    );
    _km = TextEditingController(
      text: digits(widget.line.nextDueKm, ReminderFields.kmFormatter(locale)),
    );
    _months = TextEditingController(
      text: digits(widget.line.nextDueMonths, ReminderFields.monthsFormatter(locale)),
    );
  }

  @override
  void dispose() {
    for (final controller in [_cost, _brand, _notes, _km, _months]) {
      controller.dispose();
    }
    super.dispose();
  }

  static int? _int(String text) => int.tryParse(DigitsInputFormatter.digitsOf(text));

  void _changed() => widget.onLineChanged(
    widget.line.copyWith(
      brand: _brand.text,
      cost: () => _int(_cost.text),
      notes: _notes.text,
      nextDueKm: () => _int(_km.text),
      nextDueMonths: () => _int(_months.text),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    const gap = SizedBox(height: 16);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ServiceIconTile(
                icon: widget.item.icon,
                tone: widget.index == 0 ? tones.amber : tones.neutral,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.item.title,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.serviceItemIndex(widget.index + 1, widget.count),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.item.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.serviceRemoveItem,
                onPressed: widget.onRemove,
                style: IconButton.styleFrom(
                  backgroundColor: scheme.surfaceContainerLow,
                  foregroundColor: scheme.error,
                  minimumSize: const Size(44, 44),
                ),
                icon: const Icon(Icons.delete_outline, size: 20),
              ),
            ],
          ),
          gap,
          WizardField(
            label: l10n.serviceCostLabel,
            child: TextField(
              controller: _cost,
              onChanged: (_) => _changed(),
              keyboardType: TextInputType.number,
              inputFormatters: [ServiceLineCard.costFormatter(l10n.localeName)],
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
              decoration: wizardInputDecoration(
                context,
                hint: ServiceLineCard.costFormatter(l10n.localeName).format('0'),
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
          gap,
          WizardField(
            label: l10n.serviceBrandLabel,
            child: SuggestionTextField(
              controller: _brand,
              suggestions: widget.brandSuggestions,
              onChanged: (_) => _changed(),
              maxLength: ServiceRules.brandMaxLength,
              style: theme.textTheme.bodyMedium,
              decoration: wizardInputDecoration(
                context,
                prefixIcon: Icon(Icons.verified_outlined, size: 20, color: scheme.onSurfaceVariant),
              ),
            ),
          ),
          gap,
          WizardField(
            label: l10n.serviceNotesLabel,
            child: TextField(
              controller: _notes,
              onChanged: (_) => _changed(),
              maxLength: ServiceRules.lineNotesMaxLength,
              minLines: 2,
              maxLines: 4,
              style: theme.textTheme.bodySmall,
              decoration: wizardInputDecoration(context),
            ),
          ),
          gap,
          ReminderFields(
            kmController: _km,
            monthsController: _months,
            nextDueKm: _int(_km.text),
            nextDueMonths: _int(_months.text),
            baseKm: widget.baseKm,
            baseDate: widget.baseDate,
            onKmChanged: (_) => _changed(),
            onMonthsChanged: (_) => _changed(),
          ),
          if (widget.lineError case final error?) ...[
            const SizedBox(height: 8),
            AuthErrorText(error),
          ],
        ],
      ),
    );
  }
}
