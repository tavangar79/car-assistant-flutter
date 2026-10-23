import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/presentation/widgets/history_formats.dart';
import '../plans_catalog.dart';
import '../widgets/plan_card.dart';

/// "پلن‌ها و تعرفه‌ها" (Stitch `f5d932ab55044100874d23a52a20ede1`): the hero banner, the monthly /
/// yearly toggle, the three plans and the guarantee card. Display only: the current plan is always
/// پایه and the upgrade buttons only say "به‌زودی".
class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  var _cycle = BillingCycle.monthly;

  void _upgrade() {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).comingSoon)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final amber = AppTones.of(context).amber;
    String amount(int value) => formatAmount(value, l10n.localeName);
    final plans = plansCatalog(l10n, amount);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: scheme.surfaceContainerLowest,
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
        title: Text(
          l10n.plansTitle,
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          const _Hero(),
          const SizedBox(height: 24),
          SegmentedToggle(
            selected: _cycle.index,
            onSelected: (index) => setState(() => _cycle = BillingCycle.values[index]),
            segments: [
              (icon: null, label: l10n.plansMonthly, trailing: null),
              (
                icon: null,
                label: l10n.plansYearly,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: amber.chipBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.plansYearlyDiscount,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: amber.chipForeground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          for (final (index, plan) in plans.indexed) ...[
            if (index > 0) const SizedBox(height: 24),
            PlanCard(
              plan: plan,
              cycle: _cycle,
              formattedPrice: amount(plan.price(_cycle)),
              onUpgrade: _upgrade,
            ),
          ],
          const SizedBox(height: 32),
          const _Guarantee(),
        ],
      ),
    );
  }
}

/// The navy banner: the "شفاف، بدون تعهد…" badge, the title and the pitch.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.15), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars, size: 15, color: AppTones.of(context).accentOnPrimary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    l10n.plansHeroBadge,
                    style: theme.textTheme.labelSmall?.copyWith(color: scheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.plansHeroTitle,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.plansHeroBody,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.outline),
          ),
        ],
      ),
    );
  }
}

/// "تضمین شفافیت و رضایت" with the payment and support notes.
class _Guarantee extends StatelessWidget {
  const _Guarantee();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    Widget note(IconData icon, String label) => Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: scheme.secondary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(color: scheme.secondary),
            ),
          ),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.verified_outlined, size: 20, color: scheme.onSurface),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.plansGuaranteeTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.plansGuaranteeBody,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              note(Icons.lock_outline, l10n.plansSecurePayment),
              const SizedBox(width: 8),
              note(Icons.support_agent, l10n.plansSupport),
            ],
          ),
        ],
      ),
    );
  }
}
