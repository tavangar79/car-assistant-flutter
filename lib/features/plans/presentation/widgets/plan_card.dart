import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/tone_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../plans_catalog.dart';

/// A plan card (Stitch "پلن‌ها و تعرفه‌ها"): the tag and name with an icon tile, the price for the
/// [cycle] and its note, the features, then "پلن فعلی شما" (disabled) or the upgrade button. The
/// recommended plan carries the "پیشنهاد ما" badge and an amber glow.
class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.plan,
    required this.cycle,
    required this.formattedPrice,
    required this.onUpgrade,
  });

  final PlanInfo plan;
  final BillingCycle cycle;

  /// The price for [cycle] in locale digits, e.g. `۴۹٬۰۰۰`.
  final String formattedPrice;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final recommended = plan.style == PlanStyle.recommended;
    final ToneColors iconTone = switch (plan.style) {
      PlanStyle.basic => tones.neutral,
      PlanStyle.recommended => tones.amber,
      PlanStyle.standard => tones.info,
    };
    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          recommended
              ? BoxShadow(
                  color: scheme.tertiary.withValues(alpha: 0.18),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                )
              : BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 3),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (recommended) const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Tag(label: plan.tag, recommended: recommended),
                    const SizedBox(height: 4),
                    Text(
                      plan.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: recommended ? tones.amber.chipBackground : iconTone.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(plan.icon, size: 24, color: iconTone.foreground),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Price(price: formattedPrice, cycle: plan.isCurrent ? BillingCycle.monthly : cycle),
          if (plan.note(cycle) case final note?) ...[
            const SizedBox(height: 2),
            Text(note, style: theme.textTheme.bodySmall?.copyWith(color: tones.muted)),
          ],
          const SizedBox(height: 16),
          Divider(height: 1, color: scheme.surfaceContainer),
          const SizedBox(height: 16),
          for (final (index, feature) in plan.features.indexed) ...[
            if (index > 0) const SizedBox(height: 10),
            _Feature(
              label: feature,
              emphasized: recommended ? index < 2 : plan.style == PlanStyle.standard && index == 0,
              checkColor: recommended ? scheme.tertiary : scheme.secondary,
            ),
          ],
          const SizedBox(height: 20),
          _Action(plan: plan, onUpgrade: onUpgrade, label: plan.cta ?? l10n.plansCurrent),
        ],
      ),
    );
    if (!recommended) return card;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        PositionedDirectional(top: -14, start: 24, child: _RecommendedBadge()),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.recommended});

  final String label;
  final bool recommended;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: recommended ? tones.amber.background : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: recommended ? tones.amber.chipForeground : scheme.secondary,
          fontWeight: recommended ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

/// "۴۹٬۰۰۰ تومان / ماهانه".
class _Price extends StatelessWidget {
  const _Price({required this.price, required this.cycle});

  final String price;
  final BillingCycle cycle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          price,
          style: theme.textTheme.displaySmall?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            cycle == BillingCycle.yearly ? l10n.plansPerYear : l10n.plansPerMonth,
            style: theme.textTheme.labelLarge?.copyWith(color: scheme.secondary),
          ),
        ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.label, required this.emphasized, required this.checkColor});

  final String label;
  final bool emphasized;
  final Color checkColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, size: 20, color: checkColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: emphasized ? scheme.onSurface : scheme.onSurfaceVariant,
              fontWeight: emphasized ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

/// The disabled "پلن فعلی شما", the navy recommended upgrade, or the grey upgrade with a chevron.
class _Action extends StatelessWidget {
  const _Action({required this.plan, required this.onUpgrade, required this.label});

  final PlanInfo plan;
  final VoidCallback onUpgrade;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textStyle = theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700);
    const size = Size.fromHeight(56);
    if (plan.isCurrent) {
      return FilledButton.icon(
        onPressed: null,
        style: FilledButton.styleFrom(
          minimumSize: size,
          disabledBackgroundColor: scheme.surfaceContainer,
          disabledForegroundColor: scheme.secondary,
          disabledIconColor: scheme.secondary,
          textStyle: textStyle,
        ),
        icon: const Icon(Icons.verified_outlined, size: 18),
        label: Text(label),
      );
    }
    if (plan.style == PlanStyle.recommended) {
      return FilledButton.icon(
        onPressed: onUpgrade,
        style: FilledButton.styleFrom(minimumSize: size, textStyle: textStyle),
        icon: const Icon(Icons.bolt, size: 20),
        label: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: onUpgrade,
      iconAlignment: IconAlignment.end,
      style: FilledButton.styleFrom(
        minimumSize: size,
        backgroundColor: scheme.surfaceContainerHigh,
        foregroundColor: scheme.onSurface,
        textStyle: textStyle,
      ),
      icon: const Icon(Icons.chevron_left, size: 18),
      label: Text(label),
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final amber = AppTones.of(context).amber;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: amber.chipBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 14, color: amber.chipForeground),
          const SizedBox(width: 4),
          Text(
            l10n.plansProBadge,
            style: theme.textTheme.labelSmall?.copyWith(
              color: amber.chipForeground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
