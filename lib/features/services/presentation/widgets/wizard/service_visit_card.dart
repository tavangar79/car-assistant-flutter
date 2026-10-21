import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/widgets/suggestion_text_field.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../domain/entities/invoice_file.dart';
import '../../../domain/entities/service_rules.dart';
import 'invoice_attachment_field.dart';
import 'wizard_field.dart';

/// The shared card at the top of step 3: the workshop (with the names used before as
/// suggestions) and the single invoice photo of the whole visit. Drawn in the style of the
/// step-3 item header and attachment blocks (Stitch `262e74911b5b45158bec636a3f484ef4`).
class ServiceVisitCard extends StatelessWidget {
  const ServiceVisitCard({
    super.key,
    required this.workshopController,
    required this.workshopSuggestions,
    required this.invoice,
    required this.onWorkshopChanged,
    required this.onInvoiceChanged,
    this.workshopError,
  });

  final TextEditingController workshopController;
  final List<String> workshopSuggestions;
  final InvoiceFile? invoice;
  final ValueChanged<String> onWorkshopChanged;
  final ValueChanged<InvoiceFile?> onInvoiceChanged;
  final String? workshopError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
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
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tones.amber.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: tones.amber.border),
                ),
                child: Icon(Icons.store_outlined, size: 24, color: tones.amber.foreground),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.serviceSharedCardTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
                    ),
                    Text(
                      l10n.serviceSharedCardBody,
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          WizardField(
            label: l10n.serviceWorkshopLabel,
            child: SuggestionTextField(
              controller: workshopController,
              suggestions: workshopSuggestions,
              onChanged: onWorkshopChanged,
              maxLength: ServiceRules.workshopMaxLength,
              textInputAction: TextInputAction.next,
              style: theme.textTheme.bodyMedium,
              decoration: wizardInputDecoration(
                context,
                hasError: workshopError != null,
                prefixIcon: Icon(Icons.store_outlined, size: 20, color: scheme.onSurfaceVariant),
              ),
            ),
          ),
          if (workshopError case final error?) ...[const SizedBox(height: 6), AuthErrorText(error)],
          const SizedBox(height: 16),
          InvoiceAttachmentField(invoice: invoice, onChanged: onInvoiceChanged),
        ],
      ),
    );
  }
}
