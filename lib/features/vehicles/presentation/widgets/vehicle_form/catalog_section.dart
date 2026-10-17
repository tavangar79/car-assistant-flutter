import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/catalog_make.dart';
import '../../../domain/entities/catalog_model.dart';
import 'form_field_header.dart';
import '../../../../auth/presentation/widgets/auth_error_text.dart';
import 'form_input_decoration.dart';
import 'form_section_card.dart';

/// Make, model and trim dropdowns, cascading: the model list follows the chosen make and the trim
/// list follows the chosen model. Make and model are required, trim is optional.
class CatalogSection extends StatelessWidget {
  const CatalogSection({
    super.key,
    required this.catalog,
    required this.makeId,
    required this.modelId,
    required this.trimId,
    required this.onMakeChanged,
    required this.onModelChanged,
    required this.onTrimChanged,
    required this.onRetry,
    this.makeError,
    this.modelError,
    this.trimError,
  });

  final AsyncValue<List<CatalogMake>> catalog;
  final String? makeId;
  final String? modelId;
  final String? trimId;
  final ValueChanged<String> onMakeChanged;
  final ValueChanged<String> onModelChanged;
  final ValueChanged<String?> onTrimChanged;
  final VoidCallback onRetry;
  final String? makeError;
  final String? modelError;
  final String? trimError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormFieldHeader(label: l10n.vehicleMakeSectionTitle, badge: l10n.vehicleMakeSectionBadge),
          const SizedBox(height: 16),
          ...catalog.when(
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (_, _) => [_CatalogError(onRetry: onRetry)],
            data: (makes) => _pickers(l10n, makes),
          ),
        ],
      ),
    );
  }

  List<Widget> _pickers(AppLocalizations l10n, List<CatalogMake> makes) {
    final make = makes.where((m) => m.id == makeId).firstOrNull;
    final models = make?.models ?? const <CatalogModel>[];
    final model = models.where((m) => m.id == modelId).firstOrNull;
    final trims = model?.trims ?? const [];
    return [
      _Picker(
        label: l10n.vehicleMakeLabel,
        hint: l10n.vehicleMakeHint,
        required: true,
        value: make?.id,
        items: {for (final m in makes) m.id: m.name},
        onChanged: (id) => onMakeChanged(id!),
        error: makeError,
      ),
      const SizedBox(height: 16),
      _Picker(
        label: l10n.vehicleModelLabel,
        hint: l10n.vehicleModelHint,
        required: true,
        value: model?.id,
        items: {for (final m in models) m.id: m.name},
        onChanged: make == null ? null : (id) => onModelChanged(id!),
        error: modelError,
      ),
      const SizedBox(height: 16),
      _Picker(
        label: l10n.vehicleTrimLabel,
        hint: l10n.vehicleTrimHint,
        value: trims.any((t) => t.id == trimId) ? trimId : null,
        items: {for (final t in trims) t.id: t.name},
        onChanged: trims.isEmpty ? null : onTrimChanged,
        error: trimError,
      ),
    ];
  }
}

/// One labelled dropdown. [onChanged] `null` disables it (nothing to choose yet).
class _Picker extends StatelessWidget {
  const _Picker({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.required = false,
    this.error,
  });

  final String label;
  final String hint;
  final String? value;

  /// id → display name.
  final Map<String, String> items;
  final ValueChanged<String?>? onChanged;
  final bool required;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormFieldHeader(label: label, required: required, small: true),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          // Rebuild when the value is cleared by a parent change (e.g. a new make).
          key: ValueKey('$label-$value-${items.length}'),
          initialValue: value,
          isExpanded: true,
          icon: Icon(Icons.expand_more, size: 20, color: AppTones.of(context).muted),
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
          decoration: formInputDecoration(context, hint: hint, hasError: error != null),
          onChanged: onChanged,
          items: [
            for (final MapEntry(key: id, value: name) in items.entries)
              DropdownMenuItem(
                value: id,
                child: Text(name, overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
        if (error case final message?) ...[const SizedBox(height: 4), AuthErrorText(message)],
      ],
    );
  }
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(l10n.vehicleCatalogError, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
      ],
    );
  }
}
