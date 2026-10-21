import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';

/// An integer toman [amount] in locale digits with its unit, e.g. `۴٬۸۵۰٬۰۰۰ تومان`.
String formatToman(int amount, AppLocalizations l10n) =>
    l10n.homeSpendAmount(NumberFormat.decimalPattern(l10n.localeName).format(amount));
