import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../auth/presentation/widgets/jalali_date_picker_sheet.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../services/presentation/widgets/wizard/service_date_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';
import '../../../services/presentation/widgets/wizard/wizard_footer.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../domain/entities/attachment_file.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/expense_draft.dart';
import '../../domain/entities/expense_failures.dart';
import '../../domain/entities/expense_field.dart';
import '../../domain/entities/expense_rules.dart';
import '../providers/expense_providers.dart';
import '../widgets/expense_amount_card.dart';
import '../widgets/expense_attachment_card.dart';
import '../widgets/expense_category_grid.dart';
import '../widgets/expense_date_card.dart';
import '../widgets/expense_expiry_card.dart';
import '../widgets/expense_payment_card.dart';
import '../widgets/expense_text_card.dart';

/// "ثبت هزینه" (Stitch `7ebb36d09f6848dbb50a9a2f26264ab5`): records a manual expense for a
/// vehicle. A full page above the tabs; on save it refreshes the expenses and goes back.
class NewExpensePage extends ConsumerStatefulWidget {
  const NewExpensePage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  ConsumerState<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends ConsumerState<NewExpensePage> {
  final _amount = TextEditingController();
  final _title = TextEditingController();
  final _reference = TextEditingController();
  final _issuer = TextEditingController();
  var _draft = const ExpenseDraft();
  AttachmentFile? _attachment;

  @override
  void dispose() {
    _amount.dispose();
    _title.dispose();
    _reference.dispose();
    _issuer.dispose();
    super.dispose();
  }

  int? get _amountValue => int.tryParse(DigitsInputFormatter.digitsOf(_amount.text));

  void _update(ExpenseDraft draft) {
    ref.read(newExpenseControllerProvider.notifier).clearError();
    setState(() => _draft = draft);
  }

  void _setAmount(int amount) {
    final locale = AppLocalizations.of(context).localeName;
    _amount.text = ExpenseAmountCard.formatter(locale).format('$amount');
    _amountChanged();
  }

  void _amountChanged() => _update(_draft.copyWith(amount: () => _amountValue));

  /// Picking a category turns the expiry on with its suggestion (+1 year for insurance and
  /// inspection) or off, unless the user chose a date of their own already.
  void _selectCategory(ExpenseCategory category, DateTime now) {
    final draft = _draft.copyWith(category: () => category);
    final custom = _draft.expiresAt != null && _draft.expiresAt != _draft.suggestedExpiry(now);
    if (custom) return _update(draft);
    final suggested = draft.suggestedExpiry(now);
    _update(draft.copyWith(hasExpiry: suggested != null, expiresAt: () => suggested));
  }

  void _toggleExpiry(bool on, DateTime now) => _update(
    _draft.copyWith(
      hasExpiry: on,
      expiresAt: () => on ? (_draft.expiresAt ?? _draft.suggestedExpiry(now)) : null,
    ),
  );

  /// Sets the paid day (`null` means today). A suggested expiry moves with it; a date the user
  /// chose stays.
  void _setPaidDay(DateTime? day, DateTime now) {
    final followsSuggestion =
        _draft.expiresAt != null && _draft.expiresAt == _draft.suggestedExpiry(now);
    final draft = _draft.copyWith(paidDay: () => day);
    _update(
      followsSuggestion ? draft.copyWith(expiresAt: () => draft.suggestedExpiry(now)) : draft,
    );
  }

  void _chip(ServiceDateChip chip, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    _setPaidDay(switch (chip) {
      ServiceDateChip.today => null,
      ServiceDateChip.yesterday => today.subtract(const Duration(days: 1)),
      ServiceDateChip.lastWeek => today.subtract(const Duration(days: 7)),
    }, now);
  }

  Future<void> _pickPaidDate(DateTime current, DateTime now) async {
    final l10n = AppLocalizations.of(context);
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: current,
      first: DateTime(2000),
      last: now,
      title: l10n.expensePaidAtPickTitle,
      confirmLabel: l10n.odometerPickDateConfirm,
    );
    if (picked == null || !mounted) return;
    final isToday = picked.year == now.year && picked.month == now.month && picked.day == now.day;
    _setPaidDay(isToday ? null : picked, now);
  }

  Future<void> _pickExpiry(DateTime paidAt, DateTime now) async {
    final l10n = AppLocalizations.of(context);
    final first = paidAt.add(const Duration(days: 1));
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: _draft.expiresAt ?? _draft.suggestedExpiry(now) ?? first,
      first: first,
      last: DateTime(now.year + 30),
      title: l10n.expenseExpiryPickTitle,
      confirmLabel: l10n.odometerPickDateConfirm,
    );
    if (picked == null || !mounted) return;
    _update(_draft.copyWith(expiresAt: () => picked));
  }

  Future<void> _submit() async {
    if (ref.read(newExpenseControllerProvider).isLoading) return;
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final result = await ref
        .read(newExpenseControllerProvider.notifier)
        .submit(widget.vehicleId, _draft, attachment: _attachment);
    if (!mounted) return;
    if (result == null) {
      final failure = ref.read(newExpenseControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(
          content: Text(switch (failure) {
            InvalidExpenseFailure() || ExpenseRejectedFailure() => l10n.expenseSaveInvalid,
            AttachmentTooLargeFailure() => l10n.expenseAttachmentTooLarge(
              AttachmentFile.maxMegabytes,
            ),
            InvalidAttachmentFailure() => l10n.expenseAttachmentInvalid,
            _ => l10n.expenseSaveFailed,
          }),
        ),
      );
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.attachmentFailure == null ? l10n.expenseSaved : l10n.expenseSavedAttachmentFailed,
        ),
      ),
    );
    navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final vehicle = ref.watch(vehicleProvider(widget.vehicleId));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        scrolledUnderElevation: 1,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.04),
        leading: IconButton(
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: Text(l10n.expensePageTitle, style: theme.textTheme.headlineMedium),
      ),
      body: vehicle.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => LoadErrorView(
          message: l10n.vehicleDetailsLoadError,
          onRetry: () => ref.invalidate(vehicleProvider(widget.vehicleId)),
        ),
        data: (vehicle) => _form(vehicle, l10n),
      ),
    );
  }

  Widget _form(Vehicle vehicle, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final now = ref.watch(clockProvider)();
    final controller = ref.watch(newExpenseControllerProvider);
    final failure = controller.isLoading ? null : controller.error;
    final invalid = failure is InvalidExpenseFailure ? failure.fields : const <ExpenseField>{};
    final paidAt = _draft.paidAt(now);
    const gap = SizedBox(height: 20);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _VehicleCard(vehicle: vehicle),
              gap,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20, color: scheme.secondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.expenseManualNotice,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
              gap,
              ExpenseCategoryGrid(
                selected: _draft.category,
                error: invalid.contains(ExpenseField.category) ? l10n.expenseCategoryError : null,
                onSelected: (category) => _selectCategory(category, now),
              ),
              gap,
              ExpenseAmountCard(
                controller: _amount,
                error: invalid.contains(ExpenseField.amount) ? l10n.expenseAmountError : null,
                onChanged: (_) => _amountChanged(),
                onAdd: (step) => _setAmount((_amountValue ?? 0) + step),
                onRound: () => _setAmount(ExpenseRules.roundAmount(_amountValue ?? 0)),
              ),
              gap,
              ExpenseTextCard(
                titleController: _title,
                referenceController: _reference,
                titleError: invalid.contains(ExpenseField.title)
                    ? l10n.expenseTitleError(ExpenseRules.titleMaxLength)
                    : null,
                referenceError: invalid.contains(ExpenseField.referenceNumber)
                    ? l10n.expenseReferenceError(ExpenseRules.referenceMaxLength)
                    : null,
                onTitleChanged: (value) => _update(_draft.copyWith(title: value)),
                onReferenceChanged: (value) => _update(_draft.copyWith(referenceNumber: value)),
              ),
              gap,
              ExpenseDateCard(
                date: paidAt,
                now: now,
                error: invalid.contains(ExpenseField.paidAt) ? l10n.expensePaidAtError : null,
                onChip: (chip) => _chip(chip, now),
                onPick: () => _pickPaidDate(paidAt, now),
              ),
              gap,
              ExpenseExpiryCard(
                enabled: _draft.hasExpiry,
                expiresAt: _draft.expiresAt,
                paidAt: paidAt,
                now: now,
                reminder: _draft.expiryReminder,
                error: invalid.contains(ExpenseField.expiresAt) ? l10n.expenseExpiresAtError : null,
                onToggle: (on) => _toggleExpiry(on, now),
                onPick: () => _pickExpiry(paidAt, now),
                onReminderChanged: (value) => _update(_draft.copyWith(expiryReminder: value)),
              ),
              gap,
              ExpenseAttachmentCard(
                file: _attachment,
                onChanged: (file) {
                  ref.read(newExpenseControllerProvider.notifier).clearError();
                  setState(() => _attachment = file);
                },
              ),
              gap,
              ExpensePaymentCard(
                paymentMethod: _draft.paymentMethod,
                issuerController: _issuer,
                issuerError: invalid.contains(ExpenseField.issuer)
                    ? l10n.expenseIssuerError(ExpenseRules.issuerMaxLength)
                    : null,
                onPaymentMethodChanged: (method) =>
                    _update(_draft.copyWith(paymentMethod: () => method)),
                onIssuerChanged: (value) => _update(_draft.copyWith(issuer: value)),
              ),
            ],
          ),
        ),
        WizardFooter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (invalid.contains(ExpenseField.category)) ...[
                AuthErrorText(l10n.expenseCategoryError),
                const SizedBox(height: 8),
              ],
              FilledButton(
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
                    : Text(l10n.expensePageTitle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The active vehicle at the top of the page: a 44px car tile and the nickname.
class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return WizardCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.directions_car, size: 24, color: scheme.onSurface),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              vehicle.nickname,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
