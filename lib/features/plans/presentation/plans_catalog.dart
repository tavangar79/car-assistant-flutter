import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// The billing cycle of the plans page toggle.
enum BillingCycle { monthly, yearly }

/// The look of a plan card (Stitch): the free plan, the recommended amber plan, or a plain one.
enum PlanStyle { basic, recommended, standard }

/// One plan of the plans page. Display only: nothing is enforced and nothing can be bought.
class PlanInfo {
  const PlanInfo({
    required this.style,
    required this.icon,
    required this.tag,
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.monthlyNote,
    required this.yearlyNote,
    required this.features,
    required this.cta,
    this.isCurrent = false,
  });

  final PlanStyle style;
  final IconData icon;
  final String tag;
  final String name;

  /// Toman.
  final int monthlyPrice;
  final int yearlyPrice;

  /// The line under the price; `null` for none.
  final String? monthlyNote;
  final String? yearlyNote;
  final List<String> features;

  /// The upgrade button label; `null` for the current plan.
  final String? cta;

  /// "پلن فعلی شما": always the basic plan for now.
  final bool isCurrent;

  int price(BillingCycle cycle) => cycle == BillingCycle.yearly ? yearlyPrice : monthlyPrice;

  String? note(BillingCycle cycle) => cycle == BillingCycle.yearly ? yearlyNote : monthlyNote;
}

/// The plans and prices of Stitch "پلن‌ها و تعرفه‌ها" (`f5d932ab55044100874d23a52a20ede1`), in
/// screen order. [formatAmount] writes the per-month equivalents of the yearly prices.
List<PlanInfo> plansCatalog(AppLocalizations l10n, String Function(int) formatAmount) => [
  PlanInfo(
    style: PlanStyle.basic,
    icon: Icons.directions_car_outlined,
    tag: l10n.plansBasicTag,
    name: l10n.plansBasicName,
    // The free plan keeps its monthly price and unit in both cycles, as in the screen.
    monthlyPrice: 0,
    yearlyPrice: 0,
    monthlyNote: null,
    yearlyNote: null,
    features: [
      l10n.plansBasicFeature1,
      l10n.plansBasicFeature2,
      l10n.plansBasicFeature3,
      l10n.plansBasicFeature4,
    ],
    cta: null,
    isCurrent: true,
  ),
  PlanInfo(
    style: PlanStyle.recommended,
    icon: Icons.verified_user,
    tag: l10n.plansProTag,
    name: l10n.plansProName,
    monthlyPrice: 49000,
    yearlyPrice: 470000,
    monthlyNote: l10n.plansProMonthlyNote,
    yearlyNote: l10n.plansProYearlyNote(formatAmount(39000)),
    features: [
      l10n.plansProFeature1,
      l10n.plansProFeature2,
      l10n.plansProFeature3,
      l10n.plansProFeature4,
      l10n.plansProFeature5,
    ],
    cta: l10n.plansProCta,
  ),
  PlanInfo(
    style: PlanStyle.standard,
    icon: Icons.garage_outlined,
    tag: l10n.plansMasterTag,
    name: l10n.plansMasterName,
    monthlyPrice: 89000,
    yearlyPrice: 850000,
    monthlyNote: l10n.plansMasterMonthlyNote,
    yearlyNote: l10n.plansMasterYearlyNote(formatAmount(70000)),
    features: [
      l10n.plansMasterFeature1,
      l10n.plansMasterFeature2,
      l10n.plansMasterFeature3,
      l10n.plansMasterFeature4,
    ],
    cta: l10n.plansMasterCta,
  ),
];
