// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Car Assistant';

  @override
  String get splashTagline => 'Your private logbook';

  @override
  String get splashHeadline => 'Car Management';

  @override
  String get splashDescription => 'One ledger for your car\'s expenses, services and documents';

  @override
  String get splashLoading => 'Loading your data...';

  @override
  String get splashFooter => 'Your car\'s info, always at hand';

  @override
  String get splashLogoLabel => 'Car Management app logo';

  @override
  String get versionLabel => 'Version';

  @override
  String get vehiclesTitle => 'My Vehicles';

  @override
  String get vehiclesEmpty => 'No vehicles yet';

  @override
  String get vehiclesLoadError => 'Couldn\'t load your vehicles';

  @override
  String get retry => 'Retry';

  @override
  String vehicleTitle(String make, String model, String year) {
    return '$year $make $model';
  }

  @override
  String vehicleMileage(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString km';
  }
}
