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

  /// Tooltip / screen-reader label of the back button.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت'**
  String get back;

  /// Sign-out button on the profile tab.
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

  /// Title in the top bar of the complete-profile page.
  ///
  /// In fa, this message translates to:
  /// **'تکمیل اطلاعات کاربری'**
  String get profileHeaderTitle;

  /// Heading of the complete-profile page.
  ///
  /// In fa, this message translates to:
  /// **'تکمیل اطلاعات حساب'**
  String get profileTitle;

  /// Text under the complete-profile heading.
  ///
  /// In fa, this message translates to:
  /// **'برای صدور فاکتورها، یادآور تمدید گواهینامه و انتقال رسمی سوابق خودرو، مشخصات فردی خود را وارد نمایید.'**
  String get profileDescription;

  /// Label of the first name field.
  ///
  /// In fa, this message translates to:
  /// **'نام'**
  String get profileFirstNameLabel;

  /// Placeholder of the first name field.
  ///
  /// In fa, this message translates to:
  /// **'مثال: علی'**
  String get profileFirstNameHint;

  /// Label of the last name field.
  ///
  /// In fa, this message translates to:
  /// **'نام خانوادگی'**
  String get profileLastNameLabel;

  /// Placeholder of the last name field.
  ///
  /// In fa, this message translates to:
  /// **'مثال: محمدی'**
  String get profileLastNameHint;

  /// Screen-reader text for the * next to a required field label.
  ///
  /// In fa, this message translates to:
  /// **'الزامی'**
  String get profileRequiredLabel;

  /// Label of the birth date field.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ تولد'**
  String get profileBirthDateLabel;

  /// Birth date field before a date is chosen.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب تاریخ'**
  String get profileBirthDatePlaceholder;

  /// Chip on the birth date field that opens the picker.
  ///
  /// In fa, this message translates to:
  /// **'تغییر تاریخ'**
  String get profileBirthDateChange;

  /// Helper text under the birth date field.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب تاریخ تولد به صورت سال‌محور در تقویم جلالی انجام می‌شود.'**
  String get profileBirthDateHint;

  /// Label of the read-only verified phone row.
  ///
  /// In fa, this message translates to:
  /// **'شماره تماس مالک'**
  String get profilePhoneLabel;

  /// Badge on the verified phone row.
  ///
  /// In fa, this message translates to:
  /// **'تأیید شده'**
  String get profilePhoneVerified;

  /// Title of the privacy note card.
  ///
  /// In fa, this message translates to:
  /// **'امنیت و حریم شخصی سوابق'**
  String get profilePrivacyTitle;

  /// Body of the privacy note card.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات هویتی صرفاً برای بایگانی رسمی فاکتورها، معاینه فنی و انتقال دفترچه سوابق هنگام فروش خودرو نگهداری می‌شود.'**
  String get profilePrivacyBody;

  /// Primary button that saves the profile.
  ///
  /// In fa, this message translates to:
  /// **'تأیید و ذخیره اطلاعات'**
  String get profileSave;

  /// Validation error under the first name field.
  ///
  /// In fa, this message translates to:
  /// **'نام را وارد کنید (حداکثر ۵۰ حرف)'**
  String get profileFirstNameError;

  /// Validation error under the last name field.
  ///
  /// In fa, this message translates to:
  /// **'نام خانوادگی را وارد کنید (حداکثر ۵۰ حرف)'**
  String get profileLastNameError;

  /// Validation error under the birth date field.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ تولد معتبر انتخاب کنید'**
  String get profileBirthDateError;

  /// Server rejected the profile (HTTP 400).
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات واردشده معتبر نیست، دوباره بررسی کنید'**
  String get profileSaveInvalid;

  /// Title of the birth date picker sheet.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب تاریخ تولد (تقویم جلالی)'**
  String get profilePickerTitle;

  /// Day column header in the date picker.
  ///
  /// In fa, this message translates to:
  /// **'روز'**
  String get profilePickerDay;

  /// Month column header in the date picker.
  ///
  /// In fa, this message translates to:
  /// **'ماه'**
  String get profilePickerMonth;

  /// Year column header in the date picker.
  ///
  /// In fa, this message translates to:
  /// **'سال'**
  String get profilePickerYear;

  /// Helper text under the date picker wheels.
  ///
  /// In fa, this message translates to:
  /// **'گردونه را جهت تنظیم روز، ماه و سال حرکت دهید'**
  String get profilePickerHint;

  /// Confirm button of the date picker sheet.
  ///
  /// In fa, this message translates to:
  /// **'تأیید تاریخ تولد'**
  String get profilePickerConfirm;

  /// Cancel button of the date picker sheet.
  ///
  /// In fa, this message translates to:
  /// **'انصراف'**
  String get profilePickerCancel;

  /// Screen-reader label of the close button of the date picker sheet.
  ///
  /// In fa, this message translates to:
  /// **'بستن'**
  String get profilePickerClose;

  /// Chosen Jalali birth date, e.g. ۲۱ آبان ۱۳۷۰. day and year use locale digits.
  ///
  /// In fa, this message translates to:
  /// **'{day} {month} {year}'**
  String profileBirthDateValue(String day, String month, String year);

  /// Name of a Jalali (Persian calendar) month, month is 1–12.
  ///
  /// In fa, this message translates to:
  /// **'{month, select, 1{فروردین} 2{اردیبهشت} 3{خرداد} 4{تیر} 5{مرداد} 6{شهریور} 7{مهر} 8{آبان} 9{آذر} 10{دی} 11{بهمن} 12{اسفند} other{}}'**
  String jalaliMonth(String month);

  /// Hint under the profile photo circle.
  ///
  /// In fa, this message translates to:
  /// **'بارگذاری تصویر پرسنلی اختیاری است'**
  String get profileAvatarOptional;

  /// Screen-reader label of the camera button on the profile photo.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش تصویر پروفایل'**
  String get profileAvatarEdit;

  /// Photo option: pick an existing image.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب از گالری'**
  String get profileAvatarGallery;

  /// Photo option: use the camera.
  ///
  /// In fa, this message translates to:
  /// **'گرفتن عکس'**
  String get profileAvatarCamera;

  /// Photo option: delete the current photo.
  ///
  /// In fa, this message translates to:
  /// **'حذف تصویر'**
  String get profileAvatarRemove;

  /// Screen-reader label while the photo uploads.
  ///
  /// In fa, this message translates to:
  /// **'در حال بارگذاری تصویر...'**
  String get profileAvatarUploading;

  /// Photo rejected: wrong file type (HTTP 400).
  ///
  /// In fa, this message translates to:
  /// **'فقط تصویر JPG، PNG یا WebP قابل بارگذاری است'**
  String get profileAvatarInvalid;

  /// Photo rejected: larger than 2 MB (HTTP 413).
  ///
  /// In fa, this message translates to:
  /// **'حجم تصویر باید کمتر از ۲ مگابایت باشد'**
  String get profileAvatarTooLarge;

  /// The gallery or camera could not be opened.
  ///
  /// In fa, this message translates to:
  /// **'دسترسی به تصویر ممکن نشد'**
  String get profileAvatarPickFailed;

  /// Home tab label in the bottom dock and its app bar title.
  ///
  /// In fa, this message translates to:
  /// **'خانه'**
  String get navHome;

  /// Garage tab label in the bottom dock and its app bar title.
  ///
  /// In fa, this message translates to:
  /// **'گاراژ من'**
  String get navGarage;

  /// History tab label in the bottom dock and its app bar title.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه'**
  String get navHistory;

  /// Profile tab label in the bottom dock and its app bar title.
  ///
  /// In fa, this message translates to:
  /// **'پروفایل'**
  String get navProfile;

  /// Screen-reader label of the raised add button in the bottom dock.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سریع'**
  String get quickAdd;

  /// Tooltip of the notifications button in the app bar.
  ///
  /// In fa, this message translates to:
  /// **'اعلانات'**
  String get notifications;

  /// Screen-reader label of the avatar in the app bar.
  ///
  /// In fa, this message translates to:
  /// **'حساب کاربری'**
  String get accountLabel;

  /// Subtitle under the Garage tab title with the number of vehicles.
  ///
  /// In fa, this message translates to:
  /// **'{count} خودرو'**
  String garageVehicleCount(int count);

  /// Headline of the empty garage card.
  ///
  /// In fa, this message translates to:
  /// **'یک خودرو اضافه کنید'**
  String get emptyGarageTitle;

  /// Description in the empty garage card.
  ///
  /// In fa, this message translates to:
  /// **'برای شروع ثبت سرویس‌ها، فاکتورها و یادآورهای دوره‌ای، اولین خودروی خود را به گاراژ اضافه کنید.'**
  String get emptyGarageBody;

  /// Button that starts adding a vehicle.
  ///
  /// In fa, this message translates to:
  /// **'افزودن خودرو'**
  String get addVehicle;

  /// Heading of the benefits list under the empty garage card.
  ///
  /// In fa, this message translates to:
  /// **'امکانات اختصاصی پرونده خودرو'**
  String get garageBenefitsTitle;

  /// Small label next to the benefits heading.
  ///
  /// In fa, this message translates to:
  /// **'{count} گام اولیه'**
  String garageBenefitsSteps(int count);

  /// Title of the plate benefit tile.
  ///
  /// In fa, this message translates to:
  /// **'پلاک استاندارد ملی'**
  String get benefitPlateTitle;

  /// Description of the plate benefit tile.
  ///
  /// In fa, this message translates to:
  /// **'ثبت پلاک ایران با فرمت رسمی و استان محل شماره‌گذاری'**
  String get benefitPlateBody;

  /// Title of the service book benefit tile.
  ///
  /// In fa, this message translates to:
  /// **'دفترچه سرویس هوشمند'**
  String get benefitServiceTitle;

  /// Description of the service book benefit tile.
  ///
  /// In fa, this message translates to:
  /// **'محاسبه دقیق موعد تعویض روغن، فیلترها و قطعات مصرفی'**
  String get benefitServiceBody;

  /// Title of the records benefit tile.
  ///
  /// In fa, this message translates to:
  /// **'انتقال سوابق و فاکتورها'**
  String get benefitRecordsTitle;

  /// Description of the records benefit tile.
  ///
  /// In fa, this message translates to:
  /// **'حفظ شناسنامه مالی کامل هنگام نقل و انتقال یا فروش خودرو'**
  String get benefitRecordsBody;

  /// Placeholder text on tabs that are not built yet.
  ///
  /// In fa, this message translates to:
  /// **'به‌زودی'**
  String get comingSoon;

  /// Heading of the banner at the top of the vehicle form.
  ///
  /// In fa, this message translates to:
  /// **'مشخصات هویتی خودرو'**
  String get vehicleFormIntroTitle;

  /// Line under the vehicle form banner heading.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات پرونده فنی خودرو در گاراژ شما'**
  String get vehicleFormIntroBody;

  /// Marks an optional field of the vehicle form.
  ///
  /// In fa, this message translates to:
  /// **'(اختیاری)'**
  String get vehicleOptional;

  /// Screen-reader label of the red * on required vehicle fields.
  ///
  /// In fa, this message translates to:
  /// **'الزامی'**
  String get vehicleRequiredLabel;

  /// Label of the vehicle photo section, and of the photo thumbnail.
  ///
  /// In fa, this message translates to:
  /// **'تصویر خودرو'**
  String get vehiclePhotoLabel;

  /// Title inside the empty photo upload tile.
  ///
  /// In fa, this message translates to:
  /// **'بارگذاری یا عکاسی از خودرو'**
  String get vehiclePhotoTitle;

  /// Size and format limits of the vehicle photo.
  ///
  /// In fa, this message translates to:
  /// **'حداکثر حجم {mb} مگابایت • فرمت JPG یا PNG'**
  String vehiclePhotoLimits(int mb);

  /// Chip in the empty photo tile, and the gallery option.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب فایل از گالری'**
  String get vehiclePhotoGalleryChip;

  /// Option that takes the vehicle photo with the camera.
  ///
  /// In fa, this message translates to:
  /// **'عکاسی با دوربین'**
  String get vehiclePhotoCamera;

  /// Shown over the chosen vehicle photo.
  ///
  /// In fa, this message translates to:
  /// **'تغییر تصویر'**
  String get vehiclePhotoChange;

  /// Option that removes the chosen vehicle photo.
  ///
  /// In fa, this message translates to:
  /// **'حذف تصویر'**
  String get vehiclePhotoRemove;

  /// Shown when the image picker fails.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن گالری یا دوربین ممکن نشد'**
  String get vehiclePhotoPickFailed;

  /// Shown when the vehicle photo is too large.
  ///
  /// In fa, this message translates to:
  /// **'حجم تصویر بیشتر از {mb} مگابایت است'**
  String vehiclePhotoTooLarge(int mb);

  /// Shown when the vehicle photo has the wrong type.
  ///
  /// In fa, this message translates to:
  /// **'فقط تصویر JPG یا PNG پذیرفته می‌شود'**
  String get vehiclePhotoInvalid;

  /// Label of the vehicle nickname field.
  ///
  /// In fa, this message translates to:
  /// **'نام مستعار یا عنوان دلخواه'**
  String get vehicleNicknameLabel;

  /// Small note next to the nickname label.
  ///
  /// In fa, this message translates to:
  /// **'نمایش در داشبورد'**
  String get vehicleNicknameBadge;

  /// Placeholder of the nickname field.
  ///
  /// In fa, this message translates to:
  /// **'مثلاً: ۲۰۶ خاکستری من، شاهین کاری'**
  String get vehicleNicknameHint;

  /// Help text under the nickname field.
  ///
  /// In fa, this message translates to:
  /// **'یک نام مشخص برای تفکیک آسان میان خودروهای ثبت‌شده در گاراژ'**
  String get vehicleNicknameHelp;

  /// Error when the nickname is empty or too long.
  ///
  /// In fa, this message translates to:
  /// **'نام خودرو را وارد کنید (حداکثر {max} نویسه)'**
  String vehicleNicknameError(int max);

  /// Label of the plate input.
  ///
  /// In fa, this message translates to:
  /// **'پلاک ملی خودرو'**
  String get vehiclePlateLabel;

  /// Small note next to the plate label.
  ///
  /// In fa, this message translates to:
  /// **'استاندارد راهور'**
  String get vehiclePlateBadge;

  /// Help text under the plate input.
  ///
  /// In fa, this message translates to:
  /// **'ترتیب درج: دو رقم، حرف الفبا، سه رقم و کد استان دو رقمی معتبر'**
  String get vehiclePlateHelp;

  /// Screen-reader label of the plate's two-digit box.
  ///
  /// In fa, this message translates to:
  /// **'دو رقم پلاک'**
  String get vehiclePlateTwoDigits;

  /// Screen-reader label of the plate's letter picker.
  ///
  /// In fa, this message translates to:
  /// **'حرف الفبای پلاک'**
  String get vehiclePlateLetter;

  /// Screen-reader label of the plate's three-digit box.
  ///
  /// In fa, this message translates to:
  /// **'سه رقم پلاک'**
  String get vehiclePlateThreeDigits;

  /// Screen-reader label of the plate's province code box.
  ///
  /// In fa, this message translates to:
  /// **'کد استان پلاک'**
  String get vehiclePlateProvince;

  /// Word printed above the province code on an Iranian plate (as on the real plate).
  ///
  /// In fa, this message translates to:
  /// **'ایران'**
  String get vehiclePlateIran;

  /// First line printed on the blue band of the plate.
  ///
  /// In fa, this message translates to:
  /// **'I.R.'**
  String get vehiclePlateBandTop;

  /// Second line printed on the blue band of the plate.
  ///
  /// In fa, this message translates to:
  /// **'IRAN'**
  String get vehiclePlateBandBottom;

  /// Error when the plate is incomplete or invalid.
  ///
  /// In fa, this message translates to:
  /// **'پلاک را کامل و درست وارد کنید'**
  String get vehiclePlateError;

  /// Error when the plate is already registered (HTTP 409).
  ///
  /// In fa, this message translates to:
  /// **'این پلاک قبلاً در گاراژ شما ثبت شده است'**
  String get vehiclePlateTaken;

  /// Label of the VIN field.
  ///
  /// In fa, this message translates to:
  /// **'کد شناسایی خودرو (VIN)'**
  String get vehicleVinLabel;

  /// Small note next to the VIN label.
  ///
  /// In fa, this message translates to:
  /// **'{count} کاراکتر انگلیسی'**
  String vehicleVinBadge(int count);

  /// Placeholder of the VIN field: a sample valid VIN.
  ///
  /// In fa, this message translates to:
  /// **'NAAM21CA9KK123456'**
  String get vehicleVinHint;

  /// Help text under the VIN field.
  ///
  /// In fa, this message translates to:
  /// **'کد هفده‌رقمی مندرج در کارت مشخصات خودرو یا لبه شیشه جلو'**
  String get vehicleVinHelp;

  /// Error when the VIN is not valid.
  ///
  /// In fa, this message translates to:
  /// **'VIN باید {count} حرف انگلیسی یا رقم باشد (بدون I، O و Q)'**
  String vehicleVinError(int count);

  /// Heading of the make, model and trim section.
  ///
  /// In fa, this message translates to:
  /// **'سازنده و مشخصات فنی'**
  String get vehicleMakeSectionTitle;

  /// Small note next to the make section heading.
  ///
  /// In fa, this message translates to:
  /// **'فهرست رسمی کارخانه'**
  String get vehicleMakeSectionBadge;

  /// Label of the make dropdown.
  ///
  /// In fa, this message translates to:
  /// **'برند / سازنده'**
  String get vehicleMakeLabel;

  /// Label of the model dropdown.
  ///
  /// In fa, this message translates to:
  /// **'مدل خودرو'**
  String get vehicleModelLabel;

  /// Label of the trim dropdown.
  ///
  /// In fa, this message translates to:
  /// **'تیپ و گیربکس'**
  String get vehicleTrimLabel;

  /// Placeholder of the make dropdown.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب برند'**
  String get vehicleMakeHint;

  /// Placeholder of the model dropdown.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب مدل'**
  String get vehicleModelHint;

  /// Placeholder of the trim dropdown.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب تیپ'**
  String get vehicleTrimHint;

  /// Error when no make is chosen.
  ///
  /// In fa, this message translates to:
  /// **'برند را انتخاب کنید'**
  String get vehicleMakeError;

  /// Error when no model is chosen.
  ///
  /// In fa, this message translates to:
  /// **'مدل را انتخاب کنید'**
  String get vehicleModelError;

  /// Error when the server rejects the trim.
  ///
  /// In fa, this message translates to:
  /// **'تیپ انتخاب‌شده معتبر نیست'**
  String get vehicleTrimError;

  /// Shown when the make/model catalog could not be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت فهرست خودروها ممکن نشد'**
  String get vehicleCatalogError;

  /// Label of the model year field.
  ///
  /// In fa, this message translates to:
  /// **'سال ساخت (خورشیدی)'**
  String get vehicleYearLabel;

  /// Small note next to the model year label.
  ///
  /// In fa, this message translates to:
  /// **'تقویم جلالی'**
  String get vehicleYearBadge;

  /// Shown in the model year field before a year is chosen.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب سال'**
  String get vehicleYearHint;

  /// Title of the model year picker sheet.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب سال ساخت (خورشیدی)'**
  String get vehicleYearPickerTitle;

  /// The newest year in the picker. year is already locale-formatted.
  ///
  /// In fa, this message translates to:
  /// **'{year} (صفر کیلومتر)'**
  String vehicleYearZeroKm(String year);

  /// Button that confirms the model year.
  ///
  /// In fa, this message translates to:
  /// **'تأیید سال'**
  String get vehicleYearConfirm;

  /// Tooltip of the button that closes the year picker.
  ///
  /// In fa, this message translates to:
  /// **'بستن'**
  String get vehicleYearClose;

  /// Error when no valid model year is chosen.
  ///
  /// In fa, this message translates to:
  /// **'سال ساخت را انتخاب کنید'**
  String get vehicleYearError;

  /// Label of the odometer field.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد فعلی کیلومترشمار'**
  String get vehicleMileageLabel;

  /// Chip next to the odometer label.
  ///
  /// In fa, this message translates to:
  /// **'بسیار مهم'**
  String get vehicleMileageBadge;

  /// Unit shown inside the odometer field.
  ///
  /// In fa, this message translates to:
  /// **'کیلومتر'**
  String get vehicleMileageUnit;

  /// Help text under the odometer field.
  ///
  /// In fa, this message translates to:
  /// **'مبنای دقیق کلیه هشدارهای دوره‌ای سرویس، روغن موتور، بیمه و محاسبات استهلاک گاراژ'**
  String get vehicleMileageHelp;

  /// Error when the odometer is empty or out of range.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد را بین ۰ تا {max} کیلومتر وارد کنید'**
  String vehicleMileageError(int max);

  /// Label of the colour swatches.
  ///
  /// In fa, this message translates to:
  /// **'رنگ بدنه'**
  String get vehicleColorLabel;

  /// Name of the white body colour.
  ///
  /// In fa, this message translates to:
  /// **'سفید روغنی'**
  String get vehicleColorWhite;

  /// Name of the black body colour.
  ///
  /// In fa, this message translates to:
  /// **'مشکی آبنوس'**
  String get vehicleColorBlack;

  /// Name of the silver body colour.
  ///
  /// In fa, this message translates to:
  /// **'نقره‌ای متالیک'**
  String get vehicleColorSilver;

  /// Name of the blue body colour.
  ///
  /// In fa, this message translates to:
  /// **'آبی رویال / کاربنی'**
  String get vehicleColorBlue;

  /// Name of the red body colour.
  ///
  /// In fa, this message translates to:
  /// **'قرمز رژ روناس'**
  String get vehicleColorRed;

  /// Name of the beige body colour.
  ///
  /// In fa, this message translates to:
  /// **'بژ تیتانیوم'**
  String get vehicleColorBeige;

  /// Error when the server rejects the colour.
  ///
  /// In fa, this message translates to:
  /// **'رنگ انتخاب‌شده معتبر نیست'**
  String get vehicleColorError;

  /// Title of the default-vehicle toggle.
  ///
  /// In fa, this message translates to:
  /// **'تنظیم به عنوان خودروی پیش‌فرض'**
  String get vehicleDefaultTitle;

  /// Description of the default-vehicle toggle.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سریع سوخت، سرویس‌ها و داده‌های داشبورد به صورت خودکار برای این خودرو در اولویت قرار می‌گیرد.'**
  String get vehicleDefaultBody;

  /// Primary button of the add-vehicle form.
  ///
  /// In fa, this message translates to:
  /// **'ثبت و افزودن به گاراژ'**
  String get vehicleSave;

  /// Primary button label while the vehicle is saved.
  ///
  /// In fa, this message translates to:
  /// **'در حال ذخیره‌سازی...'**
  String get vehicleSaving;

  /// Button that leaves the vehicle form without saving.
  ///
  /// In fa, this message translates to:
  /// **'انصراف'**
  String get vehicleCancel;

  /// Shown after a vehicle was added.
  ///
  /// In fa, this message translates to:
  /// **'خودرو اضافه شد'**
  String get vehicleAdded;

  /// Shown when the vehicle was added but its photo upload failed.
  ///
  /// In fa, this message translates to:
  /// **'خودرو اضافه شد، اما بارگذاری تصویر ناموفق بود'**
  String get vehicleAddedPhotoFailed;

  /// Shown when the vehicle form has invalid fields.
  ///
  /// In fa, this message translates to:
  /// **'برخی اطلاعات معتبر نیست؛ موارد مشخص‌شده را بررسی کنید'**
  String get vehicleSaveInvalid;

  /// Shown when saving the vehicle failed for another reason.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره خودرو ممکن نشد. دوباره تلاش کنید'**
  String get vehicleSaveFailed;

  /// A plate written on one line. Digits are already locale-formatted.
  ///
  /// In fa, this message translates to:
  /// **'{twoDigits} {letter} {threeDigits} ایران {provinceCode}'**
  String vehiclePlateText(String twoDigits, String letter, String threeDigits, String provinceCode);

  /// Second line of a vehicle in the garage list.
  ///
  /// In fa, this message translates to:
  /// **'{make} {model} • {plate}'**
  String vehicleTileSubtitle(String make, String model, String plate);

  /// Shown in the plate letter picker before a letter is chosen.
  ///
  /// In fa, this message translates to:
  /// **'حرف'**
  String get vehiclePlateLetterHint;
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
