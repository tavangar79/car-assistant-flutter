import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('fa')];

  /// App name, used as the OS task title and in the splash header.
  ///
  /// In fa, this message translates to:
  /// **'دستیار خودرو'**
  String get appTitle;

  /// Small label at the top of the splash screen.
  ///
  /// In fa, this message translates to:
  /// **'دفترچه اختصاصی'**
  String get splashTagline;

  /// Large headline in the center of the splash screen.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت خودرو'**
  String get splashHeadline;

  /// Short description under the splash headline.
  ///
  /// In fa, this message translates to:
  /// **'دفتر کل هزینه‌ها، سرویس‌ها و مدارک اختصاصی خودرو'**
  String get splashDescription;

  /// Shown under the splash loading bar.
  ///
  /// In fa, this message translates to:
  /// **'در حال دریافت اطلاعات...'**
  String get splashLoading;

  /// Footer slogan on the splash screen.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات خودرو، همیشه در دسترس شما'**
  String get splashFooter;

  /// Screen-reader label for the app logo on the splash screen.
  ///
  /// In fa, this message translates to:
  /// **'نشان‌واره اپلیکیشن مدیریت خودرو'**
  String get splashLogoLabel;

  /// Word shown before the app version number.
  ///
  /// In fa, this message translates to:
  /// **'نسخه'**
  String get versionLabel;

  /// App bar title of the vehicles list page.
  ///
  /// In fa, this message translates to:
  /// **'خودروهای من'**
  String get vehiclesTitle;

  /// Shown when the user has no vehicles.
  ///
  /// In fa, this message translates to:
  /// **'هنوز خودرویی ثبت نشده است'**
  String get vehiclesEmpty;

  /// Shown when the vehicles list could not be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت خودروها ممکن نشد'**
  String get vehiclesLoadError;

  /// Button that retries a failed action.
  ///
  /// In fa, this message translates to:
  /// **'تلاش دوباره'**
  String get retry;

  /// Vehicle name in the list, e.g. 'Kia Rio model 2021'. year is already locale-formatted.
  ///
  /// In fa, this message translates to:
  /// **'{make} {model} مدل {year}'**
  String vehicleTitle(String make, String model, String year);

  /// Vehicle mileage in kilometers.
  ///
  /// In fa, this message translates to:
  /// **'{km} کیلومتر'**
  String vehicleMileage(int km);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
