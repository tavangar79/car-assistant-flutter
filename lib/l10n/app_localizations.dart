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

  /// Tooltip / screen-reader label of the back button.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت'**
  String get back;

  /// Tooltip of the sign-out button on the vehicles page.
  ///
  /// In fa, this message translates to:
  /// **'خروج از حساب'**
  String get logout;

  /// App name in the header of the phone page.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت خودرو'**
  String get authBrandTitle;

  /// Tagline under the app name in the phone page header.
  ///
  /// In fa, this message translates to:
  /// **'دفتر کل اختصاصی هزینه‌های اتومبیل'**
  String get authBrandSubtitle;

  /// Screen-reader label of the logo in the phone page header.
  ///
  /// In fa, this message translates to:
  /// **'نشان‌واره مدیریت خودرو'**
  String get authLogoLabel;

  /// Headline of the phone page.
  ///
  /// In fa, this message translates to:
  /// **'ورود یا ایجاد حساب کاربری'**
  String get authPhoneTitle;

  /// Explanation under the phone page headline.
  ///
  /// In fa, this message translates to:
  /// **'جهت ثبت امن دفترچه خودرو و نگهداری سوابق سرویس‌ها، شماره موبایل خود را وارد کنید.'**
  String get authPhoneSubtitle;

  /// Label of the phone field, also above the number on the code page.
  ///
  /// In fa, this message translates to:
  /// **'شماره تلفن همراه'**
  String get authPhoneLabel;

  /// Placeholder of the phone field: the number after +98, Latin digits as in the design.
  ///
  /// In fa, this message translates to:
  /// **'912 345 6789'**
  String get authPhoneHint;

  /// Iran country calling code shown before the phone field.
  ///
  /// In fa, this message translates to:
  /// **'+98'**
  String get authCountryCode;

  /// Hint under the phone field.
  ///
  /// In fa, this message translates to:
  /// **'ارسال کد تایید پیامکی'**
  String get authSmsCodeHint;

  /// How many digits of the number after +98 are typed.
  ///
  /// In fa, this message translates to:
  /// **'{count} از {total} رقم'**
  String authPhoneDigitsProgress(int count, int total);

  /// Shown when the mobile number is complete. count is the full number length (11).
  ///
  /// In fa, this message translates to:
  /// **'{count} رقم کامل شد'**
  String authPhoneDigitsComplete(int count);

  /// Error when the phone number is not a valid Iranian mobile number.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل معتبر نیست'**
  String get authPhoneInvalid;

  /// Heading above the feature cards on the phone page.
  ///
  /// In fa, this message translates to:
  /// **'مزایای ثبت و مدیریت در سامانه'**
  String get authFeaturesTitle;

  /// Title of the first feature card.
  ///
  /// In fa, this message translates to:
  /// **'یادآور هوشمند سرویس‌ها'**
  String get authFeatureRemindersTitle;

  /// Chip on the first feature card.
  ///
  /// In fa, this message translates to:
  /// **'کیلومتر و تاریخ'**
  String get authFeatureRemindersTag;

  /// Text of the first feature card.
  ///
  /// In fa, this message translates to:
  /// **'هشدار تعویض روغن، تسمه‌تایم، لنت و بیمه‌نامه بر اساس کارکرد واقعی خودرو یا تاریخ سررسید.'**
  String get authFeatureRemindersBody;

  /// Title of the second feature card.
  ///
  /// In fa, this message translates to:
  /// **'ثبت دقیق فاکتورها و هزینه‌ها'**
  String get authFeatureInvoicesTitle;

  /// Chip on the second feature card.
  ///
  /// In fa, this message translates to:
  /// **'بایگانی فاکتور'**
  String get authFeatureInvoicesTag;

  /// Text of the second feature card.
  ///
  /// In fa, this message translates to:
  /// **'بایگانی قطعات مصرفی، دستمزد تعمیرکار، فاکتورهای بنزین، عوارض و خلافی‌ها با محاسبه تومان.'**
  String get authFeatureInvoicesBody;

  /// Title of the third feature card.
  ///
  /// In fa, this message translates to:
  /// **'انتقال آنلاین سوابق خودرو'**
  String get authFeatureTransferTitle;

  /// Chip on the third feature card.
  ///
  /// In fa, this message translates to:
  /// **'هنگام فروش'**
  String get authFeatureTransferTag;

  /// Text of the third feature card.
  ///
  /// In fa, this message translates to:
  /// **'انتقال معتبر و یکپارچه کل شناسنامه سرویس‌ها و هزینه‌ها به مالک یا خریدار جدید در زمان معامله.'**
  String get authFeatureTransferBody;

  /// Primary button on the phone page that sends the SMS code.
  ///
  /// In fa, this message translates to:
  /// **'دریافت کد تایید'**
  String get authSendCode;

  /// Start of the terms sentence under the phone page button.
  ///
  /// In fa, this message translates to:
  /// **'با ورود یا ثبت‌نام در سامانه،'**
  String get authTermsPrefix;

  /// Terms link inside the terms sentence.
  ///
  /// In fa, this message translates to:
  /// **'قوانین و مقررات'**
  String get authTermsLink;

  /// Joins the two links of the terms sentence.
  ///
  /// In fa, this message translates to:
  /// **'و'**
  String get authTermsAnd;

  /// Privacy link inside the terms sentence.
  ///
  /// In fa, this message translates to:
  /// **'حریم خصوصی'**
  String get authPrivacyLink;

  /// End of the terms sentence.
  ///
  /// In fa, this message translates to:
  /// **'را می‌پذیرید.'**
  String get authTermsSuffix;

  /// Headline of the code page.
  ///
  /// In fa, this message translates to:
  /// **'کد تأیید را وارد کنید'**
  String get authOtpTitle;

  /// Shown under the code page headline, above the phone card.
  ///
  /// In fa, this message translates to:
  /// **'کد تأیید {length} رقمی به شماره زیر پیامک شد:'**
  String authOtpSubtitle(int length);

  /// Button on the code page that goes back to fix the number.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش شماره'**
  String get authEditPhone;

  /// Label above the code boxes.
  ///
  /// In fa, this message translates to:
  /// **'کد {length} رقمی ارسالی'**
  String authOtpFieldLabel(int length);

  /// Hint under the code boxes.
  ///
  /// In fa, this message translates to:
  /// **'کد به صورت خودکار شناسایی می‌شود'**
  String get authOtpAutoDetect;

  /// How many code digits are typed.
  ///
  /// In fa, this message translates to:
  /// **'{count} از {length} رقم درج شد'**
  String authOtpProgress(int count, int length);

  /// Text before the countdown on the code page.
  ///
  /// In fa, this message translates to:
  /// **'ارسال مجدد تا'**
  String get authResendIn;

  /// Hint under the resend countdown.
  ///
  /// In fa, this message translates to:
  /// **'پیامک را دریافت نکردید؟ پس از اتمام زمان می‌توانید درخواست ارسال مجدد دهید.'**
  String get authResendHint;

  /// Button that requests a new SMS code.
  ///
  /// In fa, this message translates to:
  /// **'ارسال مجدد کد پیامکی'**
  String get authResend;

  /// Primary button on the code page.
  ///
  /// In fa, this message translates to:
  /// **'تأیید و ادامه'**
  String get authVerify;

  /// Snackbar after a new code was sent.
  ///
  /// In fa, this message translates to:
  /// **'کد جدید پیامک شد'**
  String get authCodeResent;

  /// Error when the entered code is wrong or expired.
  ///
  /// In fa, this message translates to:
  /// **'کد نادرست است یا منقضی شده'**
  String get authInvalidCode;

  /// Error when the server could not send the SMS.
  ///
  /// In fa, this message translates to:
  /// **'ارسال پیامک ممکن نشد، دوباره تلاش کنید'**
  String get authSmsFailed;

  /// Error when codes are requested too often.
  ///
  /// In fa, this message translates to:
  /// **'کمی صبر کنید و دوباره تلاش کنید'**
  String get authTooManyRequests;

  /// Rate-limit error (HTTP 429) with the wait. time is mm:ss, locale-formatted.
  ///
  /// In fa, this message translates to:
  /// **'تعداد درخواست‌ها زیاد است، {time} دیگر دوباره تلاش کنید'**
  String authTooManyRequestsRetryIn(String time);

  /// Generic error, e.g. no internet connection.
  ///
  /// In fa, this message translates to:
  /// **'مشکلی پیش آمد، دوباره تلاش کنید'**
  String get authGenericError;
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
