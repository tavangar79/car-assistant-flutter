import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/fuel_payment_method.dart';
import '../../domain/entities/fuel_type.dart';

/// The screen label of a fuel type (segmented control, rows).
String fuelTypeLabel(FuelType type, AppLocalizations l10n) => switch (type) {
  FuelType.regular => l10n.fuelTypeRegular,
  FuelType.superGrade => l10n.fuelTypeSuper,
  FuelType.cng => l10n.fuelTypeCng,
  FuelType.lpg => l10n.fuelTypeLpg,
};

/// The volume unit of a fuel type: litres, cubic metres for CNG.
String fuelUnitLabel(FuelType type, AppLocalizations l10n) =>
    type.isCubicMetres ? l10n.fuelUnitCubicMetre : l10n.fuelUnitLitre;

/// The screen label of a payment method (contract wording).
String fuelPaymentLabel(FuelPaymentMethod method, AppLocalizations l10n) => switch (method) {
  FuelPaymentMethod.personalFuelCard => l10n.fuelPaymentPersonalFuelCard,
  FuelPaymentMethod.stationFuelCard => l10n.fuelPaymentStationFuelCard,
  FuelPaymentMethod.bankCard => l10n.fuelPaymentBankCard,
  FuelPaymentMethod.cash => l10n.fuelPaymentCash,
};

/// A volume or an economy with up to 2 decimals in locale digits, e.g. `۴۸٫۵`.
String formatDecimal(double value, String locale) => NumberFormat('0.##', locale).format(value);
