import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../services/presentation/widgets/service_icon_tile.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/empty_section.dart';
import '../../domain/entities/expense.dart';
import '../providers/expense_providers.dart';
import 'expense_formats.dart';

/// "آخرین هزینه‌ها" of the vehicle details page: the last [maxExpenses] expenses as rows
/// (category tile, title, date and amount, an attachment mark), the empty state when there are
/// none.
class ExpenseSection extends ConsumerWidget {
  const ExpenseSection({super.key, required this.vehicleId});

  static const maxExpenses = 5;

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final expenses = ref.watch(expensesProvider(vehicleId));
    if (expenses.value case final list? when list.isEmpty) {
      return EmptySection(
        icon: Icons.account_balance_wallet_outlined,
        title: l10n.expenseSectionTitle,
        emptyIcon: Icons.account_balance_wallet_outlined,
        message: l10n.expenseSectionEmpty,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 20, color: muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.expenseSectionTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        expenses.when(
          loading: () => const DetailsCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, _) => DetailsCard(
            child: Column(
              children: [
                Text(l10n.expenseSectionLoadError, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(expensesProvider(vehicleId)),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
          data: (list) => DetailsCard(
            child: Column(
              children: [
                for (final (index, expense) in list.take(maxExpenses).indexed) ...[
                  if (index > 0) Divider(height: 1, color: scheme.surfaceContainer),
                  _ExpenseRow(expense: expense),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// One expense: category tile, its title (or the category), date • amount, attachment mark.
class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          ServiceIconTile(icon: expenseCategoryIcon(expense.category), tone: tones.neutral),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title ?? expenseCategoryTitle(expense.category, l10n),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
                ),
                Text(
                  '${formatJalaliDate(expense.paidAt.toLocal(), l10n)} • '
                  '${l10n.serviceHistoryAmount(expense.amount)}',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
                ),
              ],
            ),
          ),
          if (expense.hasAttachment)
            Icon(Icons.attach_file, size: 18, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
