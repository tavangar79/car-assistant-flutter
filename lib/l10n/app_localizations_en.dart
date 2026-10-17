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

  @override
  String get back => 'Back';

  @override
  String get logout => 'Sign out';

  @override
  String get authBrandTitle => 'Car Management';

  @override
  String get authBrandSubtitle => 'Your private car expense ledger';

  @override
  String get authLogoLabel => 'Car Management logo';

  @override
  String get authPhoneTitle => 'Sign in or create an account';

  @override
  String get authPhoneSubtitle =>
      'Enter your mobile number to securely keep your car logbook and service history.';

  @override
  String get authPhoneLabel => 'Mobile number';

  @override
  String get authPhoneHint => '912 345 6789';

  @override
  String get authCountryCode => '+98';

  @override
  String get authSmsCodeHint => 'A verification code is sent by SMS';

  @override
  String authPhoneDigitsProgress(int count, int total) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$countString of $totalString digits';
  }

  @override
  String authPhoneDigitsComplete(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'All $countString digits entered';
  }

  @override
  String get authPhoneInvalid => 'This mobile number is not valid';

  @override
  String get authFeaturesTitle => 'Why sign up';

  @override
  String get authFeatureRemindersTitle => 'Smart service reminders';

  @override
  String get authFeatureRemindersTag => 'Mileage & date';

  @override
  String get authFeatureRemindersBody =>
      'Alerts for oil, timing belt, brake pads and insurance based on real mileage or due date.';

  @override
  String get authFeatureInvoicesTitle => 'Track invoices and costs';

  @override
  String get authFeatureInvoicesTag => 'Invoice archive';

  @override
  String get authFeatureInvoicesBody =>
      'Archive parts, labor, fuel, tolls and fines, totaled in toman.';

  @override
  String get authFeatureTransferTitle => 'Transfer your car\'s history';

  @override
  String get authFeatureTransferTag => 'When selling';

  @override
  String get authFeatureTransferBody =>
      'Hand the complete service and cost record to the new owner when you sell.';

  @override
  String get authSendCode => 'Get verification code';

  @override
  String get authTermsPrefix => 'By signing in or signing up, you agree that the';

  @override
  String get authTermsLink => 'Terms of Service';

  @override
  String get authTermsAnd => 'and';

  @override
  String get authPrivacyLink => 'Privacy Policy';

  @override
  String get authTermsSuffix => 'apply.';

  @override
  String get authOtpTitle => 'Enter the verification code';

  @override
  String authOtpSubtitle(int length) {
    final intl.NumberFormat lengthNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String lengthString = lengthNumberFormat.format(length);

    return 'A $lengthString-digit code was sent by SMS to:';
  }

  @override
  String get authEditPhone => 'Edit number';

  @override
  String authOtpFieldLabel(int length) {
    final intl.NumberFormat lengthNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String lengthString = lengthNumberFormat.format(length);

    return '$lengthString-digit code';
  }

  @override
  String get authOtpAutoDetect => 'The code is detected automatically';

  @override
  String authOtpProgress(int count, int length) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);
    final intl.NumberFormat lengthNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String lengthString = lengthNumberFormat.format(length);

    return '$countString of $lengthString digits entered';
  }

  @override
  String get authResendIn => 'Resend in';

  @override
  String get authResendHint =>
      'Didn\'t get the SMS? You can request a new code when the timer ends.';

  @override
  String get authResend => 'Resend SMS code';

  @override
  String get authVerify => 'Verify and continue';

  @override
  String get authCodeResent => 'A new code was sent';

  @override
  String get authInvalidCode => 'The code is wrong or expired';

  @override
  String get authSmsFailed => 'Couldn\'t send the SMS, please try again';

  @override
  String get authTooManyRequests => 'Please wait a moment and try again';

  @override
  String authTooManyRequestsRetryIn(String time) {
    return 'Too many attempts, try again in $time';
  }

  @override
  String get authGenericError => 'Something went wrong, please try again';
}
