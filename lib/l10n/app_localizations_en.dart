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
  String get authPhoneTitle => 'Sign in or sign up';

  @override
  String get authPhoneSubtitle => 'Enter your mobile number and we\'ll text you a code';

  @override
  String get authPhoneLabel => 'Mobile number';

  @override
  String get authPhoneInvalid => 'Enter a valid mobile number';

  @override
  String get authSendCode => 'Get code';

  @override
  String get authOtpTitle => 'Enter the code';

  @override
  String authOtpSubtitle(String phone) {
    return 'We texted a code to $phone';
  }

  @override
  String get authEditPhone => 'Change number';

  @override
  String get authOtpFieldLabel => 'Verification code';

  @override
  String get authVerify => 'Verify and sign in';

  @override
  String authResendIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String get authResend => 'Resend code';

  @override
  String get authCodeResent => 'A new code is on its way';

  @override
  String get authInvalidCode => 'Invalid or expired code';

  @override
  String get authSmsFailed => 'Couldn\'t send the SMS, try again';

  @override
  String get authTooManyRequests => 'Please wait a moment and try again';

  @override
  String authTooManyRequestsRetryIn(String time) {
    return 'Too many tries, try again in $time';
  }

  @override
  String get authGenericError => 'Something went wrong, try again';
}
