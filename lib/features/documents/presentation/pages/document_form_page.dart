import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/jalali_date_picker_sheet.dart';
import '../../../expenses/domain/entities/attachment_file.dart';
import '../../../expenses/domain/entities/expense_failures.dart';
import '../../../expenses/presentation/widgets/expense_expiry_card.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_footer.dart';
import '../../domain/entities/document_draft.dart';
import '../../domain/entities/document_failures.dart';
import '../../domain/entities/document_field.dart';
import '../../domain/entities/document_file.dart';
import '../../domain/entities/document_rules.dart';
import '../../domain/entities/vehicle_document.dart';
import '../providers/document_form_args.dart';
import '../providers/document_form_controller.dart';
import '../providers/document_providers.dart';
import '../widgets/document_files_card.dart';
import '../widgets/document_issue_date_card.dart';
import '../widgets/document_text_field.dart';
import '../widgets/document_type_grid.dart';
import '../widgets/open_document_file.dart';

/// Add or edit a document (no Stitch screen: the expense form's look). Type, title, issuer,
/// number, issue and expiry dates (Jalali picker), reminder, notes and up to four files. Editing
/// ([documentId]) loads the document from the vehicle's list and adds delete.
class DocumentFormPage extends ConsumerWidget {
  const DocumentFormPage({
    super.key,
    required this.vehicleId,
    this.documentId,
    this.args = const DocumentFormArgs(),
  });

  final String vehicleId;
  final String? documentId;
  final DocumentFormArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentId = this.documentId;
    if (documentId == null) return _DocumentForm(vehicleId: vehicleId, args: args);
    final l10n = AppLocalizations.of(context);
    final documents = ref.watch(documentsProvider(vehicleId));
    final document = documents.value?.where((d) => d.id == documentId).firstOrNull;
    if (document != null) {
      return _DocumentForm(key: ValueKey(documentId), vehicleId: vehicleId, document: document);
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.documentFormEditTitle)),
      body: documents.isLoading
          ? const Center(child: CircularProgressIndicator())
          : LoadErrorView(
              message: l10n.documentsLoadError,
              onRetry: () => ref.invalidate(documentsProvider(vehicleId)),
            ),
    );
  }
}

class _DocumentForm extends ConsumerStatefulWidget {
  const _DocumentForm({
    super.key,
    required this.vehicleId,
    this.document,
    this.args = const DocumentFormArgs(),
  });

  final String vehicleId;

  /// The document being edited; `null` adds one.
  final VehicleDocument? document;
  final DocumentFormArgs args;

  @override
  ConsumerState<_DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends ConsumerState<_DocumentForm> {
  late var _draft = switch (widget.document) {
    final document? => DocumentDraft.fromDocument(document),
    null => DocumentDraft(type: widget.args.type, issuer: widget.args.issuer ?? ''),
  };
  late final _title = TextEditingController(text: _draft.title);
  late final _issuer = TextEditingController(text: _draft.issuer);
  late final _number = TextEditingController(text: _draft.number);
  late final _notes = TextEditingController(text: _draft.notes);
  late var _savedFiles = widget.document?.files ?? const <DocumentFile>[];
  late final _newFiles = [?widget.args.file];

  bool get _editing => widget.document != null;

  DocumentFormController get _controller => ref.read(documentFormControllerProvider.notifier);

  @override
  void dispose() {
    _title.dispose();
    _issuer.dispose();
    _number.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _update(DocumentDraft draft) {
    _controller.clearError();
    setState(() => _draft = draft);
  }

  void _setFiles(VoidCallback change) {
    _controller.clearError();
    setState(change);
  }

  Future<void> _pickIssuedAt(DateTime now) async {
    final l10n = AppLocalizations.of(context);
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: _draft.issuedAt?.toLocal() ?? now,
      first: DateTime(1980),
      last: now,
      title: l10n.documentIssuedAtPickTitle,
      confirmLabel: l10n.odometerPickDateConfirm,
    );
    if (picked != null && mounted) _update(_draft.copyWith(issuedAt: () => picked));
  }

  Future<void> _pickExpiry(DateTime now) async {
    final l10n = AppLocalizations.of(context);
    final issued = _draft.issuedAt?.toLocal();
    final first = issued == null ? DateTime(2000) : issued.add(const Duration(days: 1));
    final suggested = issued == null ? now : DateTime(issued.year + 1, issued.month, issued.day);
    final initial = _draft.expiresAt?.toLocal() ?? suggested;
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: initial.isBefore(first) ? first : initial,
      first: first,
      last: DateTime(now.year + 30),
      title: l10n.expenseExpiryPickTitle,
      confirmLabel: l10n.odometerPickDateConfirm,
    );
    if (picked != null && mounted) _update(_draft.copyWith(expiresAt: () => picked));
  }

  Future<void> _removeSavedFile(DocumentFile file) async {
    final messenger = ScaffoldMessenger.of(context);
    final failed = AppLocalizations.of(context).documentFileDeleteFailed;
    final updated = await _controller.deleteFile(widget.vehicleId, widget.document!.id, file.id);
    if (!mounted) return;
    if (updated == null) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    } else {
      setState(() => _savedFiles = updated.files);
    }
  }

  Future<void> _submit() async {
    if (ref.read(documentFormControllerProvider).isLoading) return;
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final result = await _controller.submit(
      widget.vehicleId,
      _draft,
      documentId: widget.document?.id,
      files: _newFiles,
      existingFileCount: _savedFiles.length,
    );
    if (!mounted) return;
    if (result == null) {
      final failure = ref.read(documentFormControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(
          content: Text(switch (failure) {
            InvalidDocumentFailure() => l10n.documentSaveInvalid,
            DocumentFileLimitFailure() => l10n.documentFileLimit(DocumentRules.maxFiles),
            AttachmentTooLargeFailure() => l10n.expenseAttachmentTooLarge(
              AttachmentFile.maxMegabytes,
            ),
            InvalidAttachmentFailure() => l10n.expenseAttachmentInvalid,
            _ => l10n.documentSaveFailed,
          }),
        ),
      );
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.fileFailure == null ? l10n.documentSaved : l10n.documentSavedFilesFailed,
        ),
      ),
    );
    navigator.maybePop();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.documentDeleteConfirmTitle),
        content: Text(l10n.documentDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.documentDeleteCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.confirmDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final deleted = await _controller.delete(widget.vehicleId, widget.document!.id);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(deleted ? l10n.documentDeleted : l10n.documentDeleteFailed)),
    );
    if (deleted) navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final now = ref.watch(clockProvider)();
    final controller = ref.watch(documentFormControllerProvider);
    final failure = controller.isLoading ? null : controller.error;
    final invalid = failure is InvalidDocumentFailure ? failure.fields : const <DocumentField>{};
    final title = _editing ? l10n.documentFormEditTitle : l10n.documentFormNewTitle;
    const gap = SizedBox(height: 20);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        scrolledUnderElevation: 1,
        shadowColor: scheme.shadow.withValues(alpha: 0.04),
        leading: IconButton(
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: Text(title, style: theme.textTheme.headlineMedium),
        actions: [
          if (_editing)
            IconButton(
              tooltip: l10n.documentDelete,
              onPressed: controller.isLoading ? null : _delete,
              color: scheme.error,
              icon: const Icon(Icons.delete_outline),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                DocumentTypeGrid(
                  selected: _draft.type,
                  error: invalid.contains(DocumentField.type) ? l10n.documentTypeError : null,
                  onSelected: (type) => _update(_draft.copyWith(type: () => type)),
                ),
                gap,
                WizardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DocumentTextField(
                        label: l10n.documentTitleLabel,
                        hint: l10n.documentTitleHint,
                        controller: _title,
                        maxLength: DocumentRules.titleMaxLength,
                        error: invalid.contains(DocumentField.title)
                            ? l10n.documentTitleError(DocumentRules.titleMaxLength)
                            : null,
                        onChanged: (value) => _update(_draft.copyWith(title: value)),
                      ),
                      const SizedBox(height: 16),
                      DocumentTextField(
                        label: l10n.documentIssuerLabel,
                        hint: l10n.documentIssuerHint,
                        controller: _issuer,
                        maxLength: DocumentRules.issuerMaxLength,
                        error: invalid.contains(DocumentField.issuer)
                            ? l10n.documentIssuerError(DocumentRules.issuerMaxLength)
                            : null,
                        onChanged: (value) => _update(_draft.copyWith(issuer: value)),
                      ),
                      const SizedBox(height: 16),
                      DocumentTextField(
                        label: l10n.documentNumberLabel,
                        hint: l10n.documentNumberHint,
                        controller: _number,
                        maxLength: DocumentRules.numberMaxLength,
                        error: invalid.contains(DocumentField.number)
                            ? l10n.documentNumberError(DocumentRules.numberMaxLength)
                            : null,
                        onChanged: (value) => _update(_draft.copyWith(number: value)),
                      ),
                    ],
                  ),
                ),
                gap,
                DocumentIssueDateCard(
                  date: _draft.issuedAt,
                  onPick: () => _pickIssuedAt(now),
                  onClear: () => _update(_draft.copyWith(issuedAt: () => null)),
                ),
                gap,
                ExpenseExpiryCard(
                  enabled: _draft.hasExpiry,
                  expiresAt: _draft.expiresAt?.toLocal(),
                  paidAt: _draft.issuedAt?.toLocal() ?? now,
                  now: now,
                  reminder: _draft.expiryReminder,
                  error: invalid.contains(DocumentField.expiresAt)
                      ? l10n.documentExpiresAtError
                      : null,
                  onToggle: (on) => _update(_draft.copyWith(hasExpiry: on)),
                  onPick: () => _pickExpiry(now),
                  onReminderChanged: (value) => _update(_draft.copyWith(expiryReminder: value)),
                ),
                gap,
                WizardCard(
                  child: DocumentTextField(
                    label: l10n.documentNotesLabel,
                    hint: l10n.documentNotesHint,
                    controller: _notes,
                    maxLength: DocumentRules.notesMaxLength,
                    maxLines: 4,
                    error: invalid.contains(DocumentField.notes)
                        ? l10n.documentNotesError(DocumentRules.notesMaxLength)
                        : null,
                    onChanged: (value) => _update(_draft.copyWith(notes: value)),
                  ),
                ),
                gap,
                DocumentFilesCard(
                  savedFiles: _savedFiles,
                  newFiles: _newFiles,
                  error: failure is DocumentFileLimitFailure
                      ? l10n.documentFileLimit(DocumentRules.maxFiles)
                      : null,
                  onAdd: (file) => _setFiles(() => _newFiles.add(file)),
                  onRemoveNew: (file) => _setFiles(() => _newFiles.remove(file)),
                  onRemoveSaved: _removeSavedFile,
                  onViewSaved: (file) => openDocumentFile(context, ref, file),
                ),
              ],
            ),
          ),
          WizardFooter(
            child: FilledButton(
              onPressed: controller.isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                disabledBackgroundColor: scheme.primary.withValues(alpha: 0.8),
                disabledForegroundColor: scheme.onPrimary,
              ),
              child: controller.isLoading
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                    )
                  : Text(_editing ? l10n.documentSave : l10n.documentFormNewTitle),
            ),
          ),
        ],
      ),
    );
  }
}
