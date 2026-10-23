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

  /// App bar vehicle chip of the history page when every vehicle is shown.
  ///
  /// In fa, this message translates to:
  /// **'همه خودروها'**
  String get historyAllVehicles;

  /// App bar vehicle chip of the history page when several vehicles are chosen.
  ///
  /// In fa, this message translates to:
  /// **'{count} خودرو'**
  String historyVehicleCount(int count);

  /// Title of the vehicle sheet of the history page, and the chip semantics label.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب خودرو'**
  String get historyChooseVehicle;

  /// Tooltip of the tune button of the history page.
  ///
  /// In fa, this message translates to:
  /// **'فیلتر سوابق'**
  String get historyFilterTooltip;

  /// Second line of the vehicle ribbon of the history page.
  ///
  /// In fa, this message translates to:
  /// **'مدل {year} • کارکرد فعلی {km} کیلومتر'**
  String historyVehicleMeta(String year, int km);

  /// Vehicle ribbon title of the history page when every vehicle is shown.
  ///
  /// In fa, this message translates to:
  /// **'همه خودروهای گاراژ'**
  String get historyGarageTitle;

  /// Vehicle ribbon title of the history page when several vehicles are chosen.
  ///
  /// In fa, this message translates to:
  /// **'{count} خودروی انتخاب‌شده'**
  String historySelectedTitle(int count);

  /// Vehicle ribbon second line when several vehicles are shown.
  ///
  /// In fa, this message translates to:
  /// **'{count} خودروی ثبت‌شده'**
  String historyGarageMeta(int count);

  /// Summary card title for the current Jalali year.
  ///
  /// In fa, this message translates to:
  /// **'مجموع هزینه‌های سال {year}'**
  String historySummaryYear(String year);

  /// Summary card title for the last six months.
  ///
  /// In fa, this message translates to:
  /// **'مجموع هزینه‌های ۶ ماه اخیر'**
  String get historySummarySixMonths;

  /// Summary card title without a date range.
  ///
  /// In fa, this message translates to:
  /// **'مجموع هزینه‌ها'**
  String get historySummaryAll;

  /// Summary card title for a custom date range.
  ///
  /// In fa, this message translates to:
  /// **'مجموع هزینه‌های بازه انتخابی'**
  String get historySummaryCustom;

  /// Badge of the summary card: how many records match.
  ///
  /// In fa, this message translates to:
  /// **'{count} مورد ثبت شده'**
  String historySummaryCount(int count);

  /// Currency unit after an amount.
  ///
  /// In fa, this message translates to:
  /// **'تومان'**
  String get historyToman;

  /// Label of the service count tile.
  ///
  /// In fa, this message translates to:
  /// **'خدمات و بازدید'**
  String get historyServicesLabel;

  /// Value of the service count tile.
  ///
  /// In fa, this message translates to:
  /// **'{count} سرویس ثبت‌شده'**
  String historyServicesValue(int count);

  /// Label of the fuel volume tile.
  ///
  /// In fa, this message translates to:
  /// **'مجموع مصرف سوخت'**
  String get historyFuelLabel;

  /// Value of the fuel volume tile.
  ///
  /// In fa, this message translates to:
  /// **'{volume} لیتر'**
  String historyFuelValue(String volume);

  /// Type tab: every record.
  ///
  /// In fa, this message translates to:
  /// **'همه موارد'**
  String get historyTabAll;

  /// Type tab: services.
  ///
  /// In fa, this message translates to:
  /// **'سرویس و تعمیر'**
  String get historyTabService;

  /// Type tab: fill-ups.
  ///
  /// In fa, this message translates to:
  /// **'سوخت‌گیری'**
  String get historyTabFuel;

  /// Type tab: expenses.
  ///
  /// In fa, this message translates to:
  /// **'هزینه‌های جاری'**
  String get historyTabExpense;

  /// Chip that keeps only records with an invoice or attachment.
  ///
  /// In fa, this message translates to:
  /// **'فاکتوردار'**
  String get historyInvoiceChip;

  /// Export button of the history page; opens the report export.
  ///
  /// In fa, this message translates to:
  /// **'خروجی اکسل/PDF'**
  String get historyExport;

  /// Period chip: the current Jalali year.
  ///
  /// In fa, this message translates to:
  /// **'سال جاری ({year})'**
  String historyPeriodCurrentYear(String year);

  /// Period chip: the last six months.
  ///
  /// In fa, this message translates to:
  /// **'۶ ماه اخیر'**
  String get historyPeriodSixMonths;

  /// Period chip: no date range.
  ///
  /// In fa, this message translates to:
  /// **'همه زمان‌ها'**
  String get historyPeriodAll;

  /// Period chip: a chosen date range.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب دستی'**
  String get historyPeriodCustom;

  /// Count badge of a month group.
  ///
  /// In fa, this message translates to:
  /// **'{count} مورد'**
  String historyMonthCount(int count);

  /// Mileage in a history row.
  ///
  /// In fa, this message translates to:
  /// **'{km} کیلومتر'**
  String historyRowKm(int km);

  /// Fuel volume in a history row.
  ///
  /// In fa, this message translates to:
  /// **'{volume} {unit}'**
  String historyRowVolume(String volume, String unit);

  /// Title of a full fill-up row.
  ///
  /// In fa, this message translates to:
  /// **'{fuel} (باک پر)'**
  String historyFullFill(String fuel);

  /// Fuel economy chip of a fill-up row.
  ///
  /// In fa, this message translates to:
  /// **'{value} لیتر / ۱۰۰ ک‌م'**
  String historyEconomy(String value);

  /// Badge of a service with an invoice.
  ///
  /// In fa, this message translates to:
  /// **'فاکتور'**
  String get historyInvoiceBadge;

  /// Badge of an expense with an attachment.
  ///
  /// In fa, this message translates to:
  /// **'پیوست'**
  String get historyAttachmentBadge;

  /// Expiry line of an expense row.
  ///
  /// In fa, this message translates to:
  /// **'پایان اعتبار: {date}'**
  String historyExpiresAt(String date);

  /// Footer at the end of the history.
  ///
  /// In fa, this message translates to:
  /// **'شروع تاریخچه از تاریخ ثبت خودرو ({date})'**
  String historyStart(String date);

  /// Empty state of the history page.
  ///
  /// In fa, this message translates to:
  /// **'سابقه‌ای با این فیلترها پیدا نشد'**
  String get historyEmpty;

  /// Load error of the history page.
  ///
  /// In fa, this message translates to:
  /// **'دریافت تاریخچه ممکن نشد'**
  String get historyLoadError;

  /// Error under the list when the next page fails.
  ///
  /// In fa, this message translates to:
  /// **'دریافت ادامه تاریخچه ممکن نشد'**
  String get historyLoadMoreError;

  /// App bar title of the filter page.
  ///
  /// In fa, this message translates to:
  /// **'فیلتر سوابق'**
  String get historyFilterTitle;

  /// Badge of the filter page: how many filters are set.
  ///
  /// In fa, this message translates to:
  /// **'{count} فیلتر فعال'**
  String historyFilterActive(int count);

  /// Resets the filter page.
  ///
  /// In fa, this message translates to:
  /// **'پاک کردن'**
  String get historyFilterClear;

  /// Close button of the filter page.
  ///
  /// In fa, this message translates to:
  /// **'بستن'**
  String get historyFilterClose;

  /// Vehicle section title of the filter page.
  ///
  /// In fa, this message translates to:
  /// **'خودرو'**
  String get historyFilterVehicles;

  /// Hint after the vehicle section title.
  ///
  /// In fa, this message translates to:
  /// **'(محدوده جستجو)'**
  String get historyFilterVehiclesHint;

  /// Badge of the vehicle section.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب شده: {count} خودرو'**
  String historyFilterSelectedVehicles(int count);

  /// Mileage line of a vehicle card of the filter page.
  ///
  /// In fa, this message translates to:
  /// **'آخرین پیمایش: {km} کیلومتر'**
  String historyFilterMileage(int km);

  /// Option of the filter page for every vehicle.
  ///
  /// In fa, this message translates to:
  /// **'همه خودروهای گاراژ'**
  String get historyFilterAllVehicles;

  /// Second line of the every-vehicle option.
  ///
  /// In fa, this message translates to:
  /// **'نمایش جامع تمام {count} خودروی ثبت‌شده'**
  String historyFilterAllVehiclesHint(int count);

  /// Category section title of the filter page.
  ///
  /// In fa, this message translates to:
  /// **'دسته‌بندی خدمات و هزینه‌ها'**
  String get historyFilterCategories;

  /// Selects every category.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب همه'**
  String get historyFilterSelectAll;

  /// Category tile for insurances, inspection, tolls and fines.
  ///
  /// In fa, this message translates to:
  /// **'هزینه‌های قانونی'**
  String get historyCategoryLegal;

  /// Second line of the legal costs tile.
  ///
  /// In fa, this message translates to:
  /// **'بیمه، معاینه، عوارض'**
  String get historyCategoryLegalHint;

  /// Attachment section title of the filter page.
  ///
  /// In fa, this message translates to:
  /// **'اسناد و مدارک مالی'**
  String get historyFilterDocuments;

  /// Attachment-only switch of the filter page.
  ///
  /// In fa, this message translates to:
  /// **'فقط سوابق دارای پیوست / فاکتور'**
  String get historyFilterAttachmentsOnly;

  /// Second line of the attachment-only switch.
  ///
  /// In fa, this message translates to:
  /// **'تصویر فاکتور رسمی، رسید پرداخت، ضمانت‌نامه'**
  String get historyFilterAttachmentsHint;

  /// Period section title of the filter page.
  ///
  /// In fa, this message translates to:
  /// **'بازه زمانی ثبت'**
  String get historyFilterPeriod;

  /// Note next to the period section title.
  ///
  /// In fa, this message translates to:
  /// **'تقویم جلالی'**
  String get historyFilterCalendar;

  /// The chosen custom date range.
  ///
  /// In fa, this message translates to:
  /// **'{from} تا {to}'**
  String historyFilterRange(String from, String to);

  /// Title of the start date picker.
  ///
  /// In fa, this message translates to:
  /// **'از تاریخ'**
  String get historyFilterFrom;

  /// Title of the end date picker.
  ///
  /// In fa, this message translates to:
  /// **'تا تاریخ'**
  String get historyFilterTo;

  /// Confirm button of the date pickers.
  ///
  /// In fa, this message translates to:
  /// **'تأیید تاریخ'**
  String get historyFilterPickDate;

  /// Label of the result count line.
  ///
  /// In fa, this message translates to:
  /// **'تعداد نتایج منطبق با فیلترها:'**
  String get historyFilterResults;

  /// Value of the result count line.
  ///
  /// In fa, this message translates to:
  /// **'{count} رکورد'**
  String historyFilterResultsValue(int count);

  /// Apply button of the filter page.
  ///
  /// In fa, this message translates to:
  /// **'اعمال فیلتر'**
  String get historyFilterApply;

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

  /// Helper under the disabled default switch when editing the current default vehicle.
  ///
  /// In fa, this message translates to:
  /// **'برای تغییر خودروی پیش‌فرض، خودروی دیگری را پیش‌فرض کنید.'**
  String get vehicleDefaultLocked;

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

  /// Shown in the plate letter picker before a letter is chosen.
  ///
  /// In fa, this message translates to:
  /// **'حرف'**
  String get vehiclePlateLetterHint;

  /// Title of the vehicle form in edit mode, and the edit item of a vehicle's options menu.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش خودرو'**
  String get editVehicle;

  /// Tooltip of the options (more) button on a vehicle in the garage list.
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات خودرو'**
  String get vehicleOptions;

  /// Primary button of the vehicle form in edit mode.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره تغییرات'**
  String get vehicleSaveChanges;

  /// Shown after an edited vehicle was saved.
  ///
  /// In fa, this message translates to:
  /// **'تغییرات خودرو ذخیره شد'**
  String get vehicleUpdated;

  /// Shown when the vehicle changes were saved but uploading the new photo or removing the saved one failed.
  ///
  /// In fa, this message translates to:
  /// **'تغییرات ذخیره شد، اما تصویر به‌روز نشد'**
  String get vehicleUpdatedPhotoFailed;

  /// Title of the odometer sheet and of its quick-actions row.
  ///
  /// In fa, this message translates to:
  /// **'بروزرسانی کیلومترشمار'**
  String get odometerTitle;

  /// Subtitle under the odometer sheet title.
  ///
  /// In fa, this message translates to:
  /// **'تنظیم دقیق موعد سرویس‌ها و یادآورهای دوره‌ای'**
  String get odometerSubtitle;

  /// Tooltip of the close button of the odometer sheet.
  ///
  /// In fa, this message translates to:
  /// **'بستن'**
  String get odometerClose;

  /// Label above the vehicle chips of the odometer sheet.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب خودرو'**
  String get odometerPickVehicle;

  /// Badge marking the active vehicle (odometer sheet, quick actions).
  ///
  /// In fa, this message translates to:
  /// **'خودروی فعال'**
  String get activeVehicleBadge;

  /// Label of the odometer input.
  ///
  /// In fa, this message translates to:
  /// **'کیلومترشمار فعلی'**
  String get odometerCurrentLabel;

  /// The vehicle's current mileage above the odometer input.
  ///
  /// In fa, this message translates to:
  /// **'آخرین ثبت: {km} کیلومتر'**
  String odometerLastRecorded(int km);

  /// Distance between the typed value and the last reading. diff is signed and locale-formatted, e.g. +۳۵۰.
  ///
  /// In fa, this message translates to:
  /// **'{diff} کیلومتر'**
  String odometerDiff(String diff);

  /// Shown after the distance when the vehicle has no reading yet.
  ///
  /// In fa, this message translates to:
  /// **'پیمایش از آخرین به‌روزرسانی'**
  String get odometerSinceLastUpdate;

  /// Shown after the distance, with the Jalali date of the latest reading.
  ///
  /// In fa, this message translates to:
  /// **'پیمایش از آخرین به‌روزرسانی ({date})'**
  String odometerSinceLastUpdateOn(String date);

  /// Button that puts the last recorded mileage back in the odometer input.
  ///
  /// In fa, this message translates to:
  /// **'بازنشانی'**
  String get odometerReset;

  /// Label above the quick-adjust buttons (+500, +1000, …).
  ///
  /// In fa, this message translates to:
  /// **'تنظیم سریع مقادیر رایج'**
  String get odometerQuickAdjust;

  /// Label of the reading date row.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ و زمان ثبت'**
  String get odometerRecordedAtLabel;

  /// Reading date when it is today. date is Jalali in words, time is HH:mm in locale digits.
  ///
  /// In fa, this message translates to:
  /// **'امروز، {date} — {time}'**
  String odometerRecordedAtToday(String date, String time);

  /// Reading date on an earlier day.
  ///
  /// In fa, this message translates to:
  /// **'{date} — {time}'**
  String odometerRecordedAtValue(String date, String time);

  /// Button that opens the date picker of the reading.
  ///
  /// In fa, this message translates to:
  /// **'تغییر تاریخ'**
  String get odometerChangeDate;

  /// Primary button of the odometer sheet.
  ///
  /// In fa, this message translates to:
  /// **'تأیید و ثبت کارکرد'**
  String get odometerSubmit;

  /// Secondary button that closes the odometer sheet.
  ///
  /// In fa, this message translates to:
  /// **'انصراف'**
  String get odometerCancel;

  /// Error when the new reading is lower than the vehicle's current mileage.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد نمی‌تواند کمتر از آخرین ثبت ({km} کیلومتر) باشد'**
  String odometerBelowCurrent(int km);

  /// Shown after a reading was saved.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد با موفقیت ثبت شد'**
  String get odometerSaved;

  /// Shown when saving a reading failed for another reason.
  ///
  /// In fa, this message translates to:
  /// **'ثبت کارکرد ممکن نشد، دوباره تلاش کنید'**
  String get odometerSaveFailed;

  /// App bar title of the vehicle details page.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات خودرو'**
  String get vehicleDetailsTitle;

  /// Shown when the vehicle details could not be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت اطلاعات خودرو ممکن نشد'**
  String get vehicleDetailsLoadError;

  /// Screen-reader label of the dot next to the default vehicle's name.
  ///
  /// In fa, this message translates to:
  /// **'فعال در گاراژ'**
  String get vehicleDetailsActive;

  /// Model year in the vehicle summary. year uses locale digits.
  ///
  /// In fa, this message translates to:
  /// **'مدل {year}'**
  String vehicleDetailsModelYear(String year);

  /// The vehicle's VIN in the summary card.
  ///
  /// In fa, this message translates to:
  /// **'شاسی: {vin}'**
  String vehicleDetailsVin(String vin);

  /// Title of the mileage card.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد فعلی خودرو'**
  String get vehicleDetailsMileageTitle;

  /// Small chip on the mileage card.
  ///
  /// In fa, this message translates to:
  /// **'مبنای یادآوری‌ها'**
  String get vehicleDetailsMileageBadge;

  /// Button on the mileage card that opens the odometer sheet.
  ///
  /// In fa, this message translates to:
  /// **'بروزرسانی کیلومتر'**
  String get vehicleDetailsUpdateMileage;

  /// Heading of the upcoming services section.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت و سرویس‌های پیش‌رو'**
  String get vehicleDetailsDueTitle;

  /// Empty state of the upcoming services section.
  ///
  /// In fa, this message translates to:
  /// **'هنوز موردی برای پیگیری ثبت نشده است'**
  String get vehicleDetailsDueEmpty;

  /// Heading of the service history section.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه آخرین خدمات و سرویس‌ها'**
  String get vehicleDetailsHistoryTitle;

  /// Empty state of the service history section.
  ///
  /// In fa, this message translates to:
  /// **'هنوز سرویسی برای این خودرو ثبت نشده است'**
  String get vehicleDetailsHistoryEmpty;

  /// Export button at the end of the vehicle details page; opens the report export.
  ///
  /// In fa, this message translates to:
  /// **'دریافت کارنامه و گزارش فاکتورها (PDF)'**
  String get vehicleDetailsExport;

  /// Title of the quick actions sheet opened from the dock's add button.
  ///
  /// In fa, this message translates to:
  /// **'اقدامات سریع'**
  String get quickActionsTitle;

  /// Tooltip of the close button of the quick actions sheet.
  ///
  /// In fa, this message translates to:
  /// **'بستن'**
  String get quickActionsClose;

  /// Line under the active vehicle in the quick actions sheet.
  ///
  /// In fa, this message translates to:
  /// **'عملیات برای این خودرو ثبت می‌شود'**
  String get quickActionsScope;

  /// Description of the odometer row in quick actions.
  ///
  /// In fa, this message translates to:
  /// **'تنظیم موعد دقیق یادآور سرویس‌ها بر اساس کارکرد'**
  String get quickActionOdometerBody;

  /// Service row title in quick actions.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سرویس و تعمیرات'**
  String get quickActionServiceTitle;

  /// Service row description in quick actions.
  ///
  /// In fa, this message translates to:
  /// **'تعویض روغن، لنت، فیلترها و فاکتور تعمیرگاه'**
  String get quickActionServiceBody;

  /// Fuel row title in quick actions.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سوخت‌گیری'**
  String get quickActionFuelTitle;

  /// Fuel row description in quick actions.
  ///
  /// In fa, this message translates to:
  /// **'بنزین معمولی، سوپر یا گاز و محاسبه مصرف صدی'**
  String get quickActionFuelBody;

  /// Expense row title in quick actions.
  ///
  /// In fa, this message translates to:
  /// **'ثبت هزینه متفرقه'**
  String get quickActionExpenseTitle;

  /// Expense row description in quick actions.
  ///
  /// In fa, this message translates to:
  /// **'بیمه شخص ثالث، عوارض، جریمه و معاینه فنی'**
  String get quickActionExpenseBody;

  /// Add-vehicle row title in quick actions.
  ///
  /// In fa, this message translates to:
  /// **'افزودن خودروی جدید'**
  String get quickActionAddVehicleTitle;

  /// Add-vehicle row description in quick actions.
  ///
  /// In fa, this message translates to:
  /// **'ثبت پلاک و باز کردن دفترچه هزینه ماشین جدید'**
  String get quickActionAddVehicleBody;

  /// Small tag next to the add-vehicle row title.
  ///
  /// In fa, this message translates to:
  /// **'گاراژ'**
  String get quickActionGarageTag;

  /// Screen-reader hint of a quick action that is not available yet.
  ///
  /// In fa, this message translates to:
  /// **'به‌زودی'**
  String get quickActionUnavailable;

  /// Title of the date picker opened from the odometer sheet.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ ثبت کارکرد (تقویم جلالی)'**
  String get odometerPickDateTitle;

  /// Confirm button of the odometer date picker.
  ///
  /// In fa, this message translates to:
  /// **'تأیید تاریخ'**
  String get odometerPickDateConfirm;

  /// Small app name above the Home title in the Home app bar.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت خودرو'**
  String get homeAppName;

  /// Link next to the Home garage strip that opens the Garage tab.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت'**
  String get homeFleetManage;

  /// Home summary tile: total spend this year.
  ///
  /// In fa, this message translates to:
  /// **'هزینه کل امسال'**
  String get homeCostThisYear;

  /// Currency unit, shown after an amount.
  ///
  /// In fa, this message translates to:
  /// **'تومان'**
  String get currencyToman;

  /// Link line of the Home total-cost tile.
  ///
  /// In fa, this message translates to:
  /// **'فیلتر در تاریخچه ›'**
  String get homeCostFooter;

  /// Home summary tile: number of invoices.
  ///
  /// In fa, this message translates to:
  /// **'فاکتورها'**
  String get homeInvoicesTitle;

  /// Unit under the invoice count on Home.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌شده'**
  String get homeInvoicesUnit;

  /// Link line of the Home invoices tile.
  ///
  /// In fa, this message translates to:
  /// **'مشاهده اسناد ›'**
  String get homeInvoicesFooter;

  /// Home summary tile: number of due items.
  ///
  /// In fa, this message translates to:
  /// **'نیازمند رسیدگی'**
  String get homeAttentionTitle;

  /// Unit under the due-item count on Home.
  ///
  /// In fa, this message translates to:
  /// **'مورد فوری'**
  String get homeAttentionUnit;

  /// Link line of the Home due-items tile.
  ///
  /// In fa, this message translates to:
  /// **'بررسی موارد ›'**
  String get homeAttentionFooter;

  /// Shown in place of a number that can't be computed yet.
  ///
  /// In fa, this message translates to:
  /// **'—'**
  String get valueUnavailable;

  /// Screen-reader text and message for a value that can't be computed.
  ///
  /// In fa, this message translates to:
  /// **'قابل محاسبه نیست'**
  String get notComputable;

  /// Title of the Home spend chart.
  ///
  /// In fa, this message translates to:
  /// **'هزینه {count} ماه اخیر'**
  String homeSpendTitle(int count);

  /// Month range of the Home spend chart within one Jalali year.
  ///
  /// In fa, this message translates to:
  /// **'{from} — {to} {year}'**
  String homeSpendRange(String from, String to, String year);

  /// Month range of the Home spend chart across two Jalali years.
  ///
  /// In fa, this message translates to:
  /// **'{from} {fromYear} — {to} {toYear}'**
  String homeSpendRangeAcrossYears(String from, String fromYear, String to, String toYear);

  /// Shown in the Home spend chart while there are no costs.
  ///
  /// In fa, this message translates to:
  /// **'هنوز هزینه‌ای ثبت نشده است'**
  String get homeSpendEmpty;

  /// Caption under the Home update-mileage button.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب خودرو و ثبت سریع کیلومترشمار فعلی'**
  String get homeUpdateOdometerHint;

  /// Header of the selected month's breakdown in the Home spend chart.
  ///
  /// In fa, this message translates to:
  /// **'{month} {year} (مجموع)'**
  String homeSpendMonthTotal(String month, String year);

  /// A toman amount in the Home dashboard.
  ///
  /// In fa, this message translates to:
  /// **'{amount} تومان'**
  String homeSpendAmount(String amount);

  /// Error when the Home dashboard figures could not be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت خلاصه هزینه‌ها ممکن نشد'**
  String get dashboardLoadError;

  /// Profile card line: the Jalali month and year the account was created.
  ///
  /// In fa, this message translates to:
  /// **'عضو رسمی از {month} {year}'**
  String profileMemberSince(String month, String year);

  /// Tooltip of the edit button on the profile card.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش پروفایل'**
  String get profileEdit;

  /// Profile stat tile: number of vehicles.
  ///
  /// In fa, this message translates to:
  /// **'خودرو فعال'**
  String get profileStatVehicles;

  /// Profile stat tile: number of service visits.
  ///
  /// In fa, this message translates to:
  /// **'سرویس ثبت‌شده'**
  String get profileStatServices;

  /// Error when the profile stats could not be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت آمار ممکن نشد'**
  String get profileStatsLoadError;

  /// Profile section title for settings rows.
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات و سامانه'**
  String get profileSettingsSection;

  /// Profile settings row title.
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات یادآورها'**
  String get profileReminders;

  /// Profile settings row subtitle.
  ///
  /// In fa, this message translates to:
  /// **'زمان‌بندی پیام‌های موعد تعویض و بیمه'**
  String get profileRemindersHint;

  /// Profile settings row title.
  ///
  /// In fa, this message translates to:
  /// **'اطلاع‌رسانی پیامک'**
  String get profileSms;

  /// Profile settings row subtitle.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت ارسال پیامک سرویس و سوخت'**
  String get profileSmsHint;

  /// Profile settings row title.
  ///
  /// In fa, this message translates to:
  /// **'امنیت و رمز عبور'**
  String get profileSecurity;

  /// Profile settings row subtitle.
  ///
  /// In fa, this message translates to:
  /// **'ورود دوعاملی و احراز هویت بیومتریک'**
  String get profileSecurityHint;

  /// Profile section title for support and legal rows.
  ///
  /// In fa, this message translates to:
  /// **'ارتباطات و حقوقی'**
  String get profileLegalSection;

  /// Profile row title.
  ///
  /// In fa, this message translates to:
  /// **'پشتیبانی و تماس با ما'**
  String get profileSupport;

  /// Profile row subtitle.
  ///
  /// In fa, this message translates to:
  /// **'پاسخگویی آنلاین و ثبت تیکت پشتیبانی'**
  String get profileSupportHint;

  /// Profile row title.
  ///
  /// In fa, this message translates to:
  /// **'قوانین و حریم خصوصی'**
  String get profilePrivacy;

  /// Profile row subtitle.
  ///
  /// In fa, this message translates to:
  /// **'شرایط استفاده و حفاظت از داده‌ها'**
  String get profilePrivacyHint;

  /// Sign-out button on the profile page.
  ///
  /// In fa, this message translates to:
  /// **'خروج از حساب کاربری'**
  String get profileLogout;

  /// App version line at the bottom of the profile page.
  ///
  /// In fa, this message translates to:
  /// **'نسخه اپلیکیشن {version}'**
  String profileAppVersion(String version);

  /// Tooltip of the history button in the Garage app bar.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه رویدادها'**
  String get garageHistoryTooltip;

  /// Heading above the vehicle cards in the Garage tab.
  ///
  /// In fa, this message translates to:
  /// **'خودروهای من'**
  String get garageMyVehicles;

  /// Badge next to the Garage heading with the number of vehicles.
  ///
  /// In fa, this message translates to:
  /// **'{count} خودرو فعال'**
  String garageActiveCount(int count);

  /// Badge on the default vehicle's card.
  ///
  /// In fa, this message translates to:
  /// **'خودروی پیش‌فرض'**
  String get garageDefaultBadge;

  /// Button on a vehicle card that makes it the default vehicle.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب به عنوان پیش‌فرض'**
  String get garageSetDefault;

  /// Shown when setting the default vehicle fails.
  ///
  /// In fa, this message translates to:
  /// **'تغییر خودروی پیش‌فرض ممکن نشد'**
  String get garageSetDefaultError;

  /// Label of the mileage row on a garage vehicle card.
  ///
  /// In fa, this message translates to:
  /// **'کیلومترشمار فعلی'**
  String get garageOdometerLabel;

  /// When the latest odometer reading was taken, on a garage vehicle card.
  ///
  /// In fa, this message translates to:
  /// **'آخرین ثبت: {when}'**
  String garageLastReading(String when);

  /// A past day relative to today.
  ///
  /// In fa, this message translates to:
  /// **'{days, plural, =0{امروز} =1{دیروز} other{{days} روز پیش}}'**
  String relativeDaysAgo(int days);

  /// Title of the service status banner on a garage vehicle card.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت سرویس‌ها'**
  String get garageServiceStatusTitle;

  /// Shortcut on a garage vehicle card.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سرویس'**
  String get garageActionService;

  /// Shortcut on a garage vehicle card that opens the odometer sheet.
  ///
  /// In fa, this message translates to:
  /// **'ثبت کیلومتر'**
  String get garageActionOdometer;

  /// Shortcut on a garage vehicle card.
  ///
  /// In fa, this message translates to:
  /// **'دفترچه سوابق'**
  String get garageActionRecords;

  /// Heading of the garage-level tools section.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت و امکانات گاراژ'**
  String get garageToolsTitle;

  /// Caption next to the garage tools heading.
  ///
  /// In fa, this message translates to:
  /// **'خدمات اسناد و انتقال'**
  String get garageToolsSubtitle;

  /// Garage tool row title.
  ///
  /// In fa, this message translates to:
  /// **'انتقال مالکیت خودرو'**
  String get garageToolTransferTitle;

  /// Garage tool row description.
  ///
  /// In fa, this message translates to:
  /// **'انتقال ایمن سوابق فنی به خریدار جدید بدون حذف داده‌ها'**
  String get garageToolTransferBody;

  /// Garage tool row title.
  ///
  /// In fa, this message translates to:
  /// **'کیف مدارک و بیمه‌نامه‌ها'**
  String get garageToolDocumentsTitle;

  /// Garage tool row description.
  ///
  /// In fa, this message translates to:
  /// **'کارت خودرو، برگ سبز، بیمه‌نامه ثالث و معاینه فنی'**
  String get garageToolDocumentsBody;

  /// Garage tool row title.
  ///
  /// In fa, this message translates to:
  /// **'خروجی پرونده و گزارش رسمی'**
  String get garageToolExportTitle;

  /// Garage tool row description.
  ///
  /// In fa, this message translates to:
  /// **'شناسنامه سوابق تعمیرگاهی و هزینه‌ها جهت فروش و کارشناسی'**
  String get garageToolExportBody;

  /// App bar title of the 3-step service wizard.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سرویس جدید'**
  String get serviceWizardTitle;

  /// Stepper label of step 1.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب اقلام'**
  String get serviceStep1Label;

  /// Stepper label of step 2.
  ///
  /// In fa, this message translates to:
  /// **'زمان و کارکرد'**
  String get serviceStep2Label;

  /// Stepper label of step 3.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات و هزینه'**
  String get serviceStep3Label;

  /// Step number inside the stepper circle, in locale digits.
  ///
  /// In fa, this message translates to:
  /// **'{step}'**
  String serviceStepNumber(int step);

  /// Amber badge of step 1 with the number of selected items.
  ///
  /// In fa, this message translates to:
  /// **'{count} مورد انتخاب شد'**
  String serviceSelectedCount(int count);

  /// Step 1 button that clears the selection.
  ///
  /// In fa, this message translates to:
  /// **'پاکسازی همه'**
  String get serviceClearAll;

  /// Placeholder of the step 1 search field.
  ///
  /// In fa, this message translates to:
  /// **'جستجوی سرویس (مثلاً: روغن، لنت، شمع...)'**
  String get serviceSearchHint;

  /// Step 1 message when the search matches nothing.
  ///
  /// In fa, this message translates to:
  /// **'سرویسی با این نام پیدا نشد'**
  String get serviceSearchEmpty;

  /// Error when the service catalog can't be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت فهرست سرویس‌ها ممکن نشد'**
  String get serviceCatalogLoadError;

  /// Label in the step 1 footer, before the count.
  ///
  /// In fa, this message translates to:
  /// **'اقلام برگزیده برای ثبت:'**
  String get serviceFooterLabel;

  /// Count in the step 1 footer.
  ///
  /// In fa, this message translates to:
  /// **'{count} سرویس انتخاب شده'**
  String serviceFooterCount(int count);

  /// Primary button of step 1.
  ///
  /// In fa, this message translates to:
  /// **'ادامه به گام دوم (زمان و کارکرد)'**
  String get serviceContinueStep2;

  /// Heading of the selected-items chips on step 2.
  ///
  /// In fa, this message translates to:
  /// **'اقلام انتخاب‌شده برای فاکتور:'**
  String get serviceSelectedItemsLabel;

  /// Step 2 link back to step 1.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش اقلام'**
  String get serviceEditItems;

  /// Heading of the odometer card on step 2.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد ثبت فاکتور'**
  String get serviceOdometerTitle;

  /// Badge next to the odometer card heading.
  ///
  /// In fa, this message translates to:
  /// **'مبنای استهلاک'**
  String get serviceOdometerBadge;

  /// Label over the odometer input on step 2.
  ///
  /// In fa, this message translates to:
  /// **'کیلومترشمار در زمان انجام سرویس'**
  String get serviceOdometerLabel;

  /// Hint under the odometer input: the vehicle's last reading, its Jalali date and how long ago.
  ///
  /// In fa, this message translates to:
  /// **'آخرین ثبت: {km} کیلومتر ({date} — {when})'**
  String serviceOdometerLastOn(int km, String date, String when);

  /// Chip with the distance between the input and the last reading, signed.
  ///
  /// In fa, this message translates to:
  /// **'{diff} کیلومتر پیمایش'**
  String serviceOdometerDiff(String diff);

  /// Label over the quick-adjust buttons on step 2.
  ///
  /// In fa, this message translates to:
  /// **'تنظیم سریع بر اساس کارکرد:'**
  String get serviceQuickAdjust;

  /// Heading of the date card on step 2.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ ثبت فاکتور'**
  String get serviceDateTitle;

  /// Small label next to the date card heading.
  ///
  /// In fa, this message translates to:
  /// **'تقویم جلالی'**
  String get serviceDateBadge;

  /// Label over the chosen date on step 2.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ انجام خدمات'**
  String get serviceDateLabel;

  /// The chosen date with its weekday, e.g. جمعه، ۲۵ آبان ۱۴۰۳.
  ///
  /// In fa, this message translates to:
  /// **'{weekday}، {date}'**
  String serviceDateValue(String weekday, String date);

  /// Name of a weekday, 1 = Saturday … 7 = Friday (shamsi_date order).
  ///
  /// In fa, this message translates to:
  /// **'{day, select, 1{شنبه} 2{یکشنبه} 3{دوشنبه} 4{سه‌شنبه} 5{چهارشنبه} 6{پنج‌شنبه} 7{جمعه} other{}}'**
  String jalaliWeekday(String day);

  /// Date chip: today.
  ///
  /// In fa, this message translates to:
  /// **'امروز'**
  String get serviceDateToday;

  /// Date chip: yesterday.
  ///
  /// In fa, this message translates to:
  /// **'دیروز'**
  String get serviceDateYesterday;

  /// Date chip: seven days ago.
  ///
  /// In fa, this message translates to:
  /// **'هفته گذشته'**
  String get serviceDateLastWeek;

  /// Date chip that opens the Jalali picker.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب از تقویم'**
  String get serviceDatePick;

  /// Title of the Jalali picker sheet on step 2.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ انجام خدمات (تقویم جلالی)'**
  String get serviceDatePickTitle;

  /// Heading of the sticker card on step 2.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات برچسب سرویس (اختیاری)'**
  String get serviceStickerTitle;

  /// Explanation in the sticker card.
  ///
  /// In fa, this message translates to:
  /// **'جهت انطباق دقیق، می‌توانید کارکرد پیشنهادی سرویس بعدی درج‌شده روی برچسب تعویض‌روغنی را ثبت کنید.'**
  String get serviceStickerBody;

  /// Label of the next-service km field (absolute km on the sticker).
  ///
  /// In fa, this message translates to:
  /// **'پیشنهاد برچسب بعدی'**
  String get serviceStickerKmLabel;

  /// Label of the visit time field.
  ///
  /// In fa, this message translates to:
  /// **'ساعت مراجعه'**
  String get serviceVisitTimeLabel;

  /// Title of the time picker dialog.
  ///
  /// In fa, this message translates to:
  /// **'ساعت مراجعه'**
  String get serviceVisitTimePickHelp;

  /// Heading of the info card at the end of step 2.
  ///
  /// In fa, this message translates to:
  /// **'همگام‌سازی فاکتور و قطعات'**
  String get serviceSyncTitle;

  /// Body of the info card; items is the selected item titles joined with و.
  ///
  /// In fa, this message translates to:
  /// **'این کارکرد و تاریخ به صورت مشترک به عنوان مبنای محاسبه تمام اقلام این فاکتور ({items}) ثبت و در تاریخچه خودرو درج خواهند شد.'**
  String serviceSyncBody(String items);

  /// Primary button of step 2.
  ///
  /// In fa, this message translates to:
  /// **'ادامه به گام سوم (جزئیات و هزینه‌ها)'**
  String get serviceContinueStep3;

  /// Secondary button of step 2.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت به انتخاب اقلام'**
  String get serviceBackToItems;

  /// Error when the visit date and time are after now (client check or a 400 on serviceDate).
  ///
  /// In fa, this message translates to:
  /// **'تاریخ و ساعت سرویس نمی‌تواند در آینده باشد'**
  String get serviceDateInFuture;

  /// A distance with its unit, e.g. in the step 3 summary pill.
  ///
  /// In fa, this message translates to:
  /// **'{km} کیلومتر'**
  String serviceKmValue(int km);

  /// Position pill on a step 3 card.
  ///
  /// In fa, this message translates to:
  /// **'قلم {index} از {count}'**
  String serviceItemIndex(int index, int count);

  /// Tooltip of the delete button on a step 3 card.
  ///
  /// In fa, this message translates to:
  /// **'حذف سرویس'**
  String get serviceRemoveItem;

  /// Label of the cost field on step 3.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ قطعه و اجرت تعویض'**
  String get serviceCostLabel;

  /// Label of the brand field on step 3.
  ///
  /// In fa, this message translates to:
  /// **'برند و مشخصات فنی قطعه'**
  String get serviceBrandLabel;

  /// Label of the workshop field on step 3.
  ///
  /// In fa, this message translates to:
  /// **'تعمیرگاه / اتوسرویس'**
  String get serviceWorkshopLabel;

  /// Label of the notes field on step 3.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت فنی و جزئیات'**
  String get serviceNotesLabel;

  /// Label of the invoice attachment on the first step 3 card.
  ///
  /// In fa, this message translates to:
  /// **'تصویر فاکتور و رسید سرویس'**
  String get serviceInvoiceLabel;

  /// Attachment tile when no invoice was picked yet.
  ///
  /// In fa, this message translates to:
  /// **'افزودن تصویر فاکتور'**
  String get serviceInvoiceAttach;

  /// Under the file name of the picked invoice.
  ///
  /// In fa, this message translates to:
  /// **'{size} • الصاق شده'**
  String serviceInvoiceAttached(String size);

  /// Tooltip of the change-invoice button.
  ///
  /// In fa, this message translates to:
  /// **'تغییر تصویر'**
  String get serviceInvoiceChange;

  /// Tooltip of the remove-invoice button.
  ///
  /// In fa, this message translates to:
  /// **'حذف تصویر'**
  String get serviceInvoiceRemove;

  /// Invoice source option.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب از گالری'**
  String get serviceInvoiceGallery;

  /// Invoice source option.
  ///
  /// In fa, this message translates to:
  /// **'عکس‌برداری با دوربین'**
  String get serviceInvoiceCamera;

  /// Error when the gallery or camera is unavailable.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب تصویر ممکن نشد'**
  String get serviceInvoicePickFailed;

  /// Error when the invoice is above the size limit.
  ///
  /// In fa, this message translates to:
  /// **'حجم تصویر فاکتور بیشتر از {max} مگابایت است'**
  String serviceInvoiceTooLarge(int max);

  /// Error when the invoice is not an accepted image.
  ///
  /// In fa, this message translates to:
  /// **'تصویر فاکتور باید JPG، PNG یا WebP باشد'**
  String get serviceInvoiceInvalid;

  /// A file size in megabytes with one decimal, locale digits.
  ///
  /// In fa, this message translates to:
  /// **'{size} مگابایت'**
  String megabytes(String size);

  /// Heading of the reminder box on a step 3 card.
  ///
  /// In fa, this message translates to:
  /// **'یادآور موعد بعدی'**
  String get serviceReminderTitle;

  /// Hint next to the reminder heading.
  ///
  /// In fa, this message translates to:
  /// **'محاسبه بر اساس نخستین شرط'**
  String get serviceReminderHint;

  /// Label of the reminder km field (km after this visit).
  ///
  /// In fa, this message translates to:
  /// **'کارکرد مجاز بعدی'**
  String get serviceReminderKmLabel;

  /// Label of the reminder months field.
  ///
  /// In fa, this message translates to:
  /// **'بازه زمانی مجاز'**
  String get serviceReminderMonthsLabel;

  /// Unit after the reminder months field.
  ///
  /// In fa, this message translates to:
  /// **'ماه بعد'**
  String get serviceReminderMonthsUnit;

  /// The odometer at which the reminder is due.
  ///
  /// In fa, this message translates to:
  /// **'سررسید: {km} ک‌م'**
  String serviceReminderDueKm(int km);

  /// The Jalali month and year at which the reminder is due.
  ///
  /// In fa, this message translates to:
  /// **'سررسید: {month} {year}'**
  String serviceReminderDueDate(String month, String year);

  /// Shown in the reminder slots when nothing is set.
  ///
  /// In fa, this message translates to:
  /// **'بدون یادآور'**
  String get serviceReminderNone;

  /// Button under the step 3 cards that returns to step 1.
  ///
  /// In fa, this message translates to:
  /// **'افزودن یک قلم سرویس دیگر به این فاکتور'**
  String get serviceAddAnotherItem;

  /// Label of the running total in the step 3 footer.
  ///
  /// In fa, this message translates to:
  /// **'جمع کل فاکتور ({count} قلم)'**
  String serviceTotalLabel(int count);

  /// Hint under the running total label.
  ///
  /// In fa, this message translates to:
  /// **'شامل اجرت و قطعات مصرفی'**
  String get serviceTotalHint;

  /// Primary button of step 3.
  ///
  /// In fa, this message translates to:
  /// **'ثبت نهایی فاکتور و ذخیره سوابق'**
  String get serviceSubmit;

  /// Primary button label while the visit is being saved.
  ///
  /// In fa, this message translates to:
  /// **'در حال ثبت...'**
  String get serviceSaving;

  /// Inline error of the workshop field.
  ///
  /// In fa, this message translates to:
  /// **'نام تعمیرگاه را وارد کنید (حداکثر {max} حرف)'**
  String serviceWorkshopError(int max);

  /// Inline error on the step 3 cards when the line items are rejected.
  ///
  /// In fa, this message translates to:
  /// **'مقادیر این قلم نامعتبر است، آن را بررسی کنید'**
  String get serviceLineItemsError;

  /// Snackbar when the server rejects the visit (400).
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات فاکتور نامعتبر است، فیلدها را بررسی کنید'**
  String get serviceSaveInvalid;

  /// Snackbar when saving the visit fails for another reason.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سرویس ممکن نشد، دوباره تلاش کنید'**
  String get serviceSaveFailed;

  /// Snackbar after the visit is saved.
  ///
  /// In fa, this message translates to:
  /// **'سرویس با موفقیت ثبت شد'**
  String get serviceSaved;

  /// Snackbar when the visit is saved but the invoice upload failed.
  ///
  /// In fa, this message translates to:
  /// **'سرویس ثبت شد، اما بارگذاری تصویر فاکتور ناموفق بود'**
  String get serviceSavedInvoiceFailed;

  /// Small label over the service details title.
  ///
  /// In fa, this message translates to:
  /// **'ثبت مراجعات فنی'**
  String get serviceDetailsEyebrow;

  /// App bar title of the service details page.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات فاکتور سرویس'**
  String get serviceDetailsTitle;

  /// Tooltip of the options menu on the service details page.
  ///
  /// In fa, this message translates to:
  /// **'گزینه‌های فاکتور'**
  String get serviceDetailsOptions;

  /// Menu entry that deletes the visit.
  ///
  /// In fa, this message translates to:
  /// **'حذف فاکتور'**
  String get serviceDetailsDelete;

  /// Title of the delete-visit confirmation.
  ///
  /// In fa, this message translates to:
  /// **'حذف این فاکتور؟'**
  String get serviceDetailsDeleteConfirmTitle;

  /// Body of the delete-visit confirmation.
  ///
  /// In fa, this message translates to:
  /// **'تمام اقلام و تصویر فاکتور حذف می‌شود. این کار قابل بازگشت نیست.'**
  String get serviceDetailsDeleteConfirmBody;

  /// Destructive confirm button.
  ///
  /// In fa, this message translates to:
  /// **'حذف'**
  String get confirmDelete;

  /// Label of the visit date in the header card.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ مراجعه'**
  String get serviceDetailsDateLabel;

  /// Label of the odometer chip in the header card.
  ///
  /// In fa, this message translates to:
  /// **'کیلومترشمار'**
  String get serviceDetailsOdometerLabel;

  /// Label of the workshop in the header card.
  ///
  /// In fa, this message translates to:
  /// **'تعمیرگاه / مرکز خدمات'**
  String get serviceDetailsWorkshopLabel;

  /// Label of the visit notes in the header card.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت'**
  String get serviceDetailsNotesLabel;

  /// Note under the header card.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات سربرگ فاکتور ثابت بوده و ردیف‌های ذیل قابل ویرایش هستند.'**
  String get serviceDetailsHeaderNote;

  /// Heading of the items section.
  ///
  /// In fa, this message translates to:
  /// **'اقلام انجام‌شده در این مراجعه ({count} مورد)'**
  String serviceDetailsItemsTitle(int count);

  /// Tooltip of the edit button on an item row.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش قلم'**
  String get serviceDetailsEditItem;

  /// Tooltip of the delete button on an item row.
  ///
  /// In fa, this message translates to:
  /// **'حذف قلم'**
  String get serviceDetailsDeleteItem;

  /// Reminder line of an item row.
  ///
  /// In fa, this message translates to:
  /// **'یادآور بعد: {value}'**
  String serviceDetailsReminder(String value);

  /// Reminder value with the due odometer and the due month.
  ///
  /// In fa, this message translates to:
  /// **'{km} کیلومتر ({month} {year})'**
  String serviceDetailsReminderBoth(int km, String month, String year);

  /// Reminder value with only the due month.
  ///
  /// In fa, this message translates to:
  /// **'{month} {year}'**
  String serviceDetailsReminderDate(String month, String year);

  /// Dashed button under the item rows.
  ///
  /// In fa, this message translates to:
  /// **'افزودن قلم جدید به این فاکتور'**
  String get serviceDetailsAddItem;

  /// Heading of the invoice card.
  ///
  /// In fa, this message translates to:
  /// **'تصویر فیزیکی فاکتور / رسید'**
  String get serviceDetailsInvoiceTitle;

  /// Under the file name on the invoice image.
  ///
  /// In fa, this message translates to:
  /// **'بارگذاری شده در {date}'**
  String serviceDetailsInvoiceUploaded(String date);

  /// Button that opens the full-screen invoice viewer.
  ///
  /// In fa, this message translates to:
  /// **'مشاهده در ابعاد کامل'**
  String get serviceDetailsInvoiceView;

  /// Invoice card body when there is no invoice.
  ///
  /// In fa, this message translates to:
  /// **'تصویری از فاکتور الصاق نشده است'**
  String get serviceDetailsInvoiceEmpty;

  /// Button that attaches an invoice to a saved visit.
  ///
  /// In fa, this message translates to:
  /// **'الصاق تصویر فاکتور'**
  String get serviceDetailsInvoiceAttach;

  /// Invoice card body when the image can't be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت تصویر فاکتور ممکن نشد'**
  String get serviceDetailsInvoiceLoadError;

  /// Snackbar after an invoice upload.
  ///
  /// In fa, this message translates to:
  /// **'تصویر فاکتور الصاق شد'**
  String get serviceDetailsInvoiceSaved;

  /// Snackbar when an invoice upload fails.
  ///
  /// In fa, this message translates to:
  /// **'بارگذاری تصویر فاکتور ممکن نشد'**
  String get serviceDetailsInvoiceSaveFailed;

  /// Heading of the totals card.
  ///
  /// In fa, this message translates to:
  /// **'جمع کل اقلام مصرفی و اجرت:'**
  String get serviceDetailsTotalTitle;

  /// Label before the final amount.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ نهایی فاکتور:'**
  String get serviceDetailsTotalLabel;

  /// Disabled footer button (export is not available yet).
  ///
  /// In fa, this message translates to:
  /// **'دریافت فایل PDF فاکتور'**
  String get serviceDetailsPdf;

  /// Error when the visit can't be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت اطلاعات فاکتور ممکن نشد'**
  String get serviceDetailsLoadError;

  /// Snackbar when deleting the only item.
  ///
  /// In fa, this message translates to:
  /// **'آخرین قلم فاکتور را نمی‌توان حذف کرد؛ به‌جای آن کل فاکتور را حذف کنید'**
  String get serviceDetailsLastItem;

  /// Title of the delete-item confirmation.
  ///
  /// In fa, this message translates to:
  /// **'حذف قلم «{item}»؟'**
  String serviceDetailsDeleteItemConfirmTitle(String item);

  /// Body of the delete-item confirmation.
  ///
  /// In fa, this message translates to:
  /// **'این قلم از فاکتور حذف و جمع کل بازمحاسبه می‌شود.'**
  String get serviceDetailsDeleteItemConfirmBody;

  /// Snackbar after the items are saved.
  ///
  /// In fa, this message translates to:
  /// **'فاکتور به‌روزرسانی شد'**
  String get serviceDetailsUpdated;

  /// Snackbar when saving the items fails.
  ///
  /// In fa, this message translates to:
  /// **'به‌روزرسانی فاکتور ممکن نشد'**
  String get serviceDetailsUpdateFailed;

  /// Snackbar after the visit is deleted.
  ///
  /// In fa, this message translates to:
  /// **'فاکتور حذف شد'**
  String get serviceDetailsDeleted;

  /// Snackbar when deleting the visit fails.
  ///
  /// In fa, this message translates to:
  /// **'حذف فاکتور ممکن نشد'**
  String get serviceDetailsDeleteFailed;

  /// Title of the line-item editor sheet in edit mode.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش قلم'**
  String get serviceEditorTitleEdit;

  /// Title of the line-item editor sheet in add mode.
  ///
  /// In fa, this message translates to:
  /// **'افزودن قلم'**
  String get serviceEditorTitleAdd;

  /// Primary button of the line-item editor sheet.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره قلم'**
  String get serviceEditorSave;

  /// Title of the item picker sheet.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب سرویس'**
  String get serviceEditorPickItem;

  /// Item picker body when every catalog item is already in the visit.
  ///
  /// In fa, this message translates to:
  /// **'همه اقلام فهرست در این فاکتور ثبت شده‌اند'**
  String get serviceEditorNoItemsLeft;

  /// Error in the vehicle details history section.
  ///
  /// In fa, this message translates to:
  /// **'دریافت تاریخچه سرویس‌ها ممکن نشد'**
  String get serviceHistoryLoadError;

  /// After the first item title of a history row.
  ///
  /// In fa, this message translates to:
  /// **'و {count} مورد دیگر'**
  String serviceHistoryMore(int count);

  /// Total cost of a history row.
  ///
  /// In fa, this message translates to:
  /// **'{amount} تومان'**
  String serviceHistoryAmount(int amount);

  /// App bar title of the service intervals page.
  ///
  /// In fa, this message translates to:
  /// **'تنظیم دوره سرویس'**
  String get intervalsTitle;

  /// Current mileage line under the vehicle name.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد فعلی: {km} کیلومتر'**
  String intervalsCurrentMileage(int km);

  /// Note next to the reset-all button.
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات براساس دفترچه راهنمای سازنده'**
  String get intervalsSourceNote;

  /// Button that resets every interval to the factory default.
  ///
  /// In fa, this message translates to:
  /// **'بازنشانی همه'**
  String get intervalsResetAll;

  /// Title of the reset-all confirmation.
  ///
  /// In fa, this message translates to:
  /// **'بازنشانی همه دوره‌ها؟'**
  String get intervalsResetAllConfirmTitle;

  /// Body of the reset-all confirmation.
  ///
  /// In fa, this message translates to:
  /// **'همه دوره‌ها به پیش‌فرض کارخانه برمی‌گردند و مقادیر سفارشی حذف می‌شوند.'**
  String get intervalsResetAllConfirmBody;

  /// Confirm button of the reset-all dialog.
  ///
  /// In fa, this message translates to:
  /// **'بازنشانی'**
  String get intervalsResetConfirm;

  /// Heading of the info banner.
  ///
  /// In fa, this message translates to:
  /// **'قانون سررسید اولویت زمانی یا کارکرد'**
  String get intervalsRuleTitle;

  /// Body of the info banner.
  ///
  /// In fa, this message translates to:
  /// **'شمارش معکوس و هشدارهای تعویض قطعات بر اساس هرکدام از شاخص‌ها (پیمایش کیلومتر یا سپری شدن ماه‌ها) که زودتر فرا برسد محاسبه و اعلام می‌گردد.'**
  String get intervalsRuleBody;

  /// Factory default line of an interval card.
  ///
  /// In fa, this message translates to:
  /// **'پیش‌فرض کارخانه: {km} کیلومتر / {months} ماه'**
  String intervalsDefault(int km, int months);

  /// Tooltip of the per-card reset button.
  ///
  /// In fa, this message translates to:
  /// **'بازنشانی این مورد'**
  String get intervalsResetRow;

  /// Unit after the months input.
  ///
  /// In fa, this message translates to:
  /// **'ماه'**
  String get intervalsMonthsUnit;

  /// Inline error of the km input.
  ///
  /// In fa, this message translates to:
  /// **'کیلومتر را بین {min} تا {max} وارد کنید'**
  String intervalsKmError(int min, int max);

  /// Inline error of the months input.
  ///
  /// In fa, this message translates to:
  /// **'ماه را بین {min} تا {max} وارد کنید'**
  String intervalsMonthsError(int min, int max);

  /// Primary button of the intervals page.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره تنظیمات'**
  String get intervalsSave;

  /// Snackbar after saving.
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات دوره‌های سرویس با موفقیت ثبت شد'**
  String get intervalsSaved;

  /// Snackbar after resetting all.
  ///
  /// In fa, this message translates to:
  /// **'تمام مقادیر به پیش‌فرض کارخانه بازگشتند'**
  String get intervalsResetDone;

  /// Snackbar when the server rejects the values (400).
  ///
  /// In fa, this message translates to:
  /// **'مقادیر دوره‌ها نامعتبر است، فیلدها را بررسی کنید'**
  String get intervalsSaveInvalid;

  /// Snackbar when saving fails.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره تنظیمات ممکن نشد، دوباره تلاش کنید'**
  String get intervalsSaveFailed;

  /// Snackbar when resetting fails.
  ///
  /// In fa, this message translates to:
  /// **'بازنشانی ممکن نشد، دوباره تلاش کنید'**
  String get intervalsResetFailed;

  /// Error when the intervals can't be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت دوره‌های سرویس ممکن نشد'**
  String get intervalsLoadError;

  /// App bar title of the due page.
  ///
  /// In fa, this message translates to:
  /// **'سرویس‌های سررسید شده'**
  String get dueTitle;

  /// App bar subtitle of the due page.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت اقلام نیازمند اقدام فوری'**
  String get dueSubtitle;

  /// Heading of the success card after an odometer update.
  ///
  /// In fa, this message translates to:
  /// **'کیلومتر با موفقیت ثبت شد'**
  String get dueSavedTitle;

  /// Date line of the success card.
  ///
  /// In fa, this message translates to:
  /// **'امروز، {date}'**
  String dueSavedDate(String date);

  /// Badge next to the vehicle name in the success card.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد جدید'**
  String get dueNewMileageBadge;

  /// Emerald chip with the signed distance since the previous reading.
  ///
  /// In fa, this message translates to:
  /// **'{delta} کیلومتر نسبت به ثبت قبل'**
  String dueDelta(String delta);

  /// Heading of the amber notice.
  ///
  /// In fa, this message translates to:
  /// **'نیاز به بررسی دوره‌ای'**
  String get dueNoticeTitle;

  /// Body of the amber notice after an odometer update.
  ///
  /// In fa, this message translates to:
  /// **'با این کارکرد جدید، {count} سرویس خودرو به سررسید رسیده‌اند و نیازمند اقدام در تعمیرگاه هستند.'**
  String dueNoticeBodyAfterUpdate(int count);

  /// Body of the amber notice when opened without an odometer update.
  ///
  /// In fa, this message translates to:
  /// **'{count} سرویس خودرو به سررسید رسیده‌اند و نیازمند اقدام در تعمیرگاه هستند.'**
  String dueNoticeBody(int count);

  /// Heading of the due list.
  ///
  /// In fa, this message translates to:
  /// **'اقلام سررسید شده'**
  String get dueListTitle;

  /// Label at the end of the due list heading.
  ///
  /// In fa, this message translates to:
  /// **'بر اساس پیمایش'**
  String get dueListBasis;

  /// Status badge: overdue.
  ///
  /// In fa, this message translates to:
  /// **'رسیدگی فوری'**
  String get dueStatusOverdue;

  /// Status badge: due soon.
  ///
  /// In fa, this message translates to:
  /// **'نزدیک به موعد'**
  String get dueStatusDueSoon;

  /// Status badge: upcoming.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعیه'**
  String get dueStatusUpcoming;

  /// Remaining line when past due by distance.
  ///
  /// In fa, this message translates to:
  /// **'{km} کیلومتر گذشته از موعد'**
  String dueOverdueKm(int km);

  /// Remaining line when past due by time.
  ///
  /// In fa, this message translates to:
  /// **'{days} روز گذشته از موعد'**
  String dueOverdueDays(int days);

  /// Remaining line when due soon by distance.
  ///
  /// In fa, this message translates to:
  /// **'تنها {km} کیلومتر مانده'**
  String dueSoonKm(int km);

  /// Remaining line when due soon by time.
  ///
  /// In fa, this message translates to:
  /// **'تنها {days} روز مانده'**
  String dueSoonDays(int days);

  /// Remaining line when upcoming by distance.
  ///
  /// In fa, this message translates to:
  /// **'{km} کیلومتر مانده (حدود {months} ماه)'**
  String dueUpcomingKm(int km, int months);

  /// Remaining line when upcoming by time.
  ///
  /// In fa, this message translates to:
  /// **'{days} روز مانده (حدود {months} ماه)'**
  String dueUpcomingDays(int days, int months);

  /// The odometer at which the item is due.
  ///
  /// In fa, this message translates to:
  /// **'مقرر: {km} کیلومتر'**
  String dueAtKm(int km);

  /// Action button of an overdue item.
  ///
  /// In fa, this message translates to:
  /// **'ثبت فاکتور این سرویس'**
  String get dueActionOverdue;

  /// Action button of a due-soon or upcoming item.
  ///
  /// In fa, this message translates to:
  /// **'ثبت این سرویس'**
  String get dueActionRecord;

  /// Heading of the archive hint card.
  ///
  /// In fa, this message translates to:
  /// **'بایگانی فاکتورها'**
  String get dueArchiveTitle;

  /// Body of the archive hint card.
  ///
  /// In fa, this message translates to:
  /// **'پس از انجام سرویس، اقلام را در یک فاکتور تجمیعی ثبت کنید.'**
  String get dueArchiveBody;

  /// Primary footer button of the due page.
  ///
  /// In fa, this message translates to:
  /// **'تأیید و بازگشت به داشبورد'**
  String get dueConfirmBack;

  /// Secondary footer button of the due page.
  ///
  /// In fa, this message translates to:
  /// **'بعداً یادآوری کن'**
  String get dueRemindLater;

  /// Due page body when every interval is ok.
  ///
  /// In fa, this message translates to:
  /// **'همه سرویس‌ها به‌موقع هستند'**
  String get dueEmpty;

  /// Error when the due items can't be loaded.
  ///
  /// In fa, this message translates to:
  /// **'دریافت وضعیت سرویس‌ها ممکن نشد'**
  String get dueLoadError;

  /// Action on the due section header that opens the intervals page.
  ///
  /// In fa, this message translates to:
  /// **'تنظیم'**
  String get vehicleDetailsDueSettings;

  /// Heading of the shared card at the top of step 3.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات مشترک فاکتور'**
  String get serviceSharedCardTitle;

  /// Subtitle of the shared card at the top of step 3.
  ///
  /// In fa, this message translates to:
  /// **'تعمیرگاه و تصویر فاکتور برای همه اقلام این مراجعه'**
  String get serviceSharedCardBody;

  /// App bar title of the new fuel log page.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سوخت‌گیری'**
  String get fuelPageTitle;

  /// Header line of the fuel page when the last log was a full fill.
  ///
  /// In fa, this message translates to:
  /// **'آخرین سوخت‌گیری: {date} • {km} کیلومتر (باک پر)'**
  String fuelLastFillFull(String date, int km);

  /// Header line of the fuel page when the last log was a partial fill.
  ///
  /// In fa, this message translates to:
  /// **'آخرین سوخت‌گیری: {date} • {km} کیلومتر'**
  String fuelLastFillPartial(String date, int km);

  /// Header line of the fuel page when the vehicle has no fuel log.
  ///
  /// In fa, this message translates to:
  /// **'هنوز سوخت‌گیری ثبت نشده است'**
  String get fuelNoLastFill;

  /// Label of the date card on the fuel page.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ سوخت‌گیری'**
  String get fuelDateLabel;

  /// Chip that opens the Jalali date picker on the fuel page.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب تاریخ دیگر'**
  String get fuelDateOther;

  /// Title of the date picker sheet on the fuel page.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ سوخت‌گیری (تقویم جلالی)'**
  String get fuelDatePickTitle;

  /// Help text of the time picker on the fuel page.
  ///
  /// In fa, this message translates to:
  /// **'ساعت سوخت‌گیری'**
  String get fuelTimePickHelp;

  /// Tooltip of the time on the fuel date card.
  ///
  /// In fa, this message translates to:
  /// **'تغییر ساعت'**
  String get fuelTimeHint;

  /// Label of the odometer card on the fuel page.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد کیلومترشمار فعلی'**
  String get fuelOdometerLabel;

  /// Trailing hint of the odometer card: the vehicle's current mileage.
  ///
  /// In fa, this message translates to:
  /// **'سند ثبت‌شده قبلی: {km}'**
  String fuelOdometerPrevious(int km);

  /// Distance between the entered odometer and the last fuel log's odometer, with its sign.
  ///
  /// In fa, this message translates to:
  /// **'{diff} کیلومتر پیمایش از باک قبل'**
  String fuelOdometerSinceLast(String diff);

  /// Label of the fuel type segmented control.
  ///
  /// In fa, this message translates to:
  /// **'نوع سوخت دریافتی'**
  String get fuelTypeLabel;

  /// Fuel type `regular`.
  ///
  /// In fa, this message translates to:
  /// **'معمولی'**
  String get fuelTypeRegular;

  /// Fuel type `super`.
  ///
  /// In fa, this message translates to:
  /// **'سوپر'**
  String get fuelTypeSuper;

  /// Fuel type `cng`.
  ///
  /// In fa, this message translates to:
  /// **'CNG'**
  String get fuelTypeCng;

  /// Fuel type `lpg`.
  ///
  /// In fa, this message translates to:
  /// **'LPG'**
  String get fuelTypeLpg;

  /// Label of the volume field.
  ///
  /// In fa, this message translates to:
  /// **'حجم سوخت‌گیری'**
  String get fuelVolumeLabel;

  /// Volume unit for liquid fuels.
  ///
  /// In fa, this message translates to:
  /// **'لیتر'**
  String get fuelUnitLitre;

  /// Volume unit for CNG.
  ///
  /// In fa, this message translates to:
  /// **'متر مکعب'**
  String get fuelUnitCubicMetre;

  /// Label of the total cost field.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ کل پرداختی'**
  String get fuelTotalCostLabel;

  /// Label of the computed price per unit row.
  ///
  /// In fa, this message translates to:
  /// **'نرخ محاسبه‌شده:'**
  String get fuelRateLabel;

  /// Price per unit, computed from the total cost and the volume.
  ///
  /// In fa, this message translates to:
  /// **'{amount} تومان / {unit}'**
  String fuelRateValue(int amount, String unit);

  /// Title of the full-fill toggle.
  ///
  /// In fa, this message translates to:
  /// **'باک کاملاً پر شد (باک پر)'**
  String get fuelFullFillTitle;

  /// Body of the full-fill toggle.
  ///
  /// In fa, this message translates to:
  /// **'جهت محاسبه دقیق مصرف سوخت در ۱۰۰ کیلومتر، فعال‌بودن این گزینه الزامی است.'**
  String get fuelFullFillBody;

  /// Title of the economy preview card.
  ///
  /// In fa, this message translates to:
  /// **'میانگین مصرف این دوره:'**
  String get fuelEconomyTitle;

  /// Unit after the economy figure.
  ///
  /// In fa, this message translates to:
  /// **'{unit} در ۱۰۰ کیلومتر'**
  String fuelEconomyUnit(String unit);

  /// How the preview was computed.
  ///
  /// In fa, this message translates to:
  /// **'{km} کیلومتر پیمایش با {volume} {unit} سوخت (از باک پر قبلی تا الان)'**
  String fuelEconomyBreakdown(int km, String volume, String unit);

  /// Footnote of the economy preview card when computable.
  ///
  /// In fa, this message translates to:
  /// **'اگر این باک کامل پر نشده بود، به جای عدد عبارت «قابل محاسبه نیست» نمایش داده می‌شد.'**
  String get fuelEconomyDisclaimer;

  /// Footnote of the economy preview card when not computable.
  ///
  /// In fa, this message translates to:
  /// **'برای محاسبه، این باک و باک قبلی باید کامل پر شده و نوع سوخت یکسان باشد.'**
  String get fuelEconomyUnavailable;

  /// Label of the station field.
  ///
  /// In fa, this message translates to:
  /// **'جایگاه سوخت'**
  String get fuelStationLabel;

  /// Label of the payment method picker.
  ///
  /// In fa, this message translates to:
  /// **'روش پرداخت و سهمیه'**
  String get fuelPaymentLabel;

  /// Placeholder of the payment method picker.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب روش پرداخت'**
  String get fuelPaymentPick;

  /// Payment method `personal_fuel_card`.
  ///
  /// In fa, this message translates to:
  /// **'کارت‌خوان جایگاه (کارت سوخت شخصی)'**
  String get fuelPaymentPersonalFuelCard;

  /// Payment method `station_fuel_card`.
  ///
  /// In fa, this message translates to:
  /// **'کارت سوخت جایگاه (نرخ آزاد)'**
  String get fuelPaymentStationFuelCard;

  /// Payment method `bank_card`.
  ///
  /// In fa, this message translates to:
  /// **'کارت بانکی'**
  String get fuelPaymentBankCard;

  /// Payment method `cash`.
  ///
  /// In fa, this message translates to:
  /// **'نقدی'**
  String get fuelPaymentCash;

  /// Label of the notes field.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت (اختیاری)'**
  String get fuelNotesLabel;

  /// Placeholder of the notes field.
  ///
  /// In fa, this message translates to:
  /// **'مثال: استفاده از مکمل سوخت یا وضعیت پمپ...'**
  String get fuelNotesHint;

  /// Primary button of the fuel page.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سوخت‌گیری و ذخیره'**
  String get fuelSubmit;

  /// Secondary button of the fuel page.
  ///
  /// In fa, this message translates to:
  /// **'انصراف و بازگشت'**
  String get fuelCancel;

  /// Snackbar after a fuel log is saved.
  ///
  /// In fa, this message translates to:
  /// **'سوخت‌گیری ثبت شد'**
  String get fuelSaved;

  /// Snackbar when saving the fuel log fails.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سوخت‌گیری ممکن نشد'**
  String get fuelSaveFailed;

  /// Snackbar when the fuel log was rejected for invalid fields.
  ///
  /// In fa, this message translates to:
  /// **'برخی مقادیر نامعتبر است، فرم را بررسی کنید'**
  String get fuelSaveInvalid;

  /// Error when the fill-up date is after now.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ و ساعت سوخت‌گیری نمی‌تواند در آینده باشد'**
  String get fuelDateInFuture;

  /// Inline error of the volume field.
  ///
  /// In fa, this message translates to:
  /// **'حجم سوخت را وارد کنید (بیشتر از ۰ و حداکثر {max})'**
  String fuelVolumeError(int max);

  /// Inline error of the total cost field.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ کل پرداختی را وارد کنید'**
  String get fuelTotalCostError;

  /// Inline error of the station field.
  ///
  /// In fa, this message translates to:
  /// **'نام جایگاه حداکثر {max} حرف است'**
  String fuelStationError(int max);

  /// Inline error of the notes field.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت حداکثر {max} حرف است'**
  String fuelNotesError(int max);

  /// Heading of the fuel section on the vehicle details page.
  ///
  /// In fa, this message translates to:
  /// **'آخرین سوخت‌گیری‌ها'**
  String get fuelSectionTitle;

  /// Empty state of the fuel section.
  ///
  /// In fa, this message translates to:
  /// **'هنوز سوخت‌گیری برای این خودرو ثبت نشده است'**
  String get fuelSectionEmpty;

  /// Error of the fuel section.
  ///
  /// In fa, this message translates to:
  /// **'دریافت سوخت‌گیری‌ها ممکن نشد'**
  String get fuelSectionLoadError;

  /// Title of a fuel row: type, volume and unit.
  ///
  /// In fa, this message translates to:
  /// **'{type} • {volume} {unit}'**
  String fuelRowTitle(String type, String volume, String unit);

  /// Economy badge of a fuel row.
  ///
  /// In fa, this message translates to:
  /// **'{economy} {unit}/۱۰۰ ک‌م'**
  String fuelRowEconomy(String economy, String unit);

  /// App bar title and submit label of the new expense page.
  ///
  /// In fa, this message translates to:
  /// **'ثبت هزینه'**
  String get expensePageTitle;

  /// Notice at the top of the expense page.
  ///
  /// In fa, this message translates to:
  /// **'کلیه ردیف‌های این بخش، ثبت دستی اطلاعات توسط کاربر است و ارتباط یا استعلام مستقیمی از سامانه‌های بیرونی انجام نمی‌شود.'**
  String get expenseManualNotice;

  /// Label of the category grid.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب سرفصل هزینه'**
  String get expenseCategoryLabel;

  /// Trailing hint of the category grid.
  ///
  /// In fa, this message translates to:
  /// **'دسته‌بندی اصلی'**
  String get expenseCategoryBadge;

  /// Category `third_party_insurance`.
  ///
  /// In fa, this message translates to:
  /// **'بیمه شخص ثالث'**
  String get expenseCategoryThirdPartyInsurance;

  /// Category `body_insurance`.
  ///
  /// In fa, this message translates to:
  /// **'بیمه بدنه'**
  String get expenseCategoryBodyInsurance;

  /// Category `fine`.
  ///
  /// In fa, this message translates to:
  /// **'جریمه رانندگی'**
  String get expenseCategoryFine;

  /// Category `toll`.
  ///
  /// In fa, this message translates to:
  /// **'عوارض و طرح'**
  String get expenseCategoryToll;

  /// Category `inspection`.
  ///
  /// In fa, this message translates to:
  /// **'معاینه فنی'**
  String get expenseCategoryInspection;

  /// Category `other`.
  ///
  /// In fa, this message translates to:
  /// **'سایر هزینه‌ها'**
  String get expenseCategoryOther;

  /// Label of the amount field.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ هزینه پرداخت‌شده'**
  String get expenseAmountLabel;

  /// Trailing hint of a required field.
  ///
  /// In fa, this message translates to:
  /// **'الزامی'**
  String get expenseRequired;

  /// Chip that rounds the amount to the nearest 50,000.
  ///
  /// In fa, this message translates to:
  /// **'رند کردن'**
  String get expenseRoundAmount;

  /// Label of the title field.
  ///
  /// In fa, this message translates to:
  /// **'عنوان هزینه'**
  String get expenseTitleLabel;

  /// Placeholder of the title field.
  ///
  /// In fa, this message translates to:
  /// **'عنوان یا سرفصل ثبت‌شده'**
  String get expenseTitleHint;

  /// Label of the reference number field.
  ///
  /// In fa, this message translates to:
  /// **'شماره بیمه‌نامه یا کد یکتا / ارجاع'**
  String get expenseReferenceLabel;

  /// Placeholder of the reference number field.
  ///
  /// In fa, this message translates to:
  /// **'اختیاری - شماره سریال یا ارجاع'**
  String get expenseReferenceHint;

  /// Label of the paid date card.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ پرداخت / صدور'**
  String get expensePaidAtLabel;

  /// Chip that opens the Jalali date picker on the expense page.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب تاریخ'**
  String get expenseDatePick;

  /// Title of the paid date picker sheet.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ پرداخت (تقویم جلالی)'**
  String get expensePaidAtPickTitle;

  /// Title of the expiry toggle card.
  ///
  /// In fa, this message translates to:
  /// **'تعیین موعد انقضا یا تمدید بعدی'**
  String get expenseExpiryTitle;

  /// Subtitle of the expiry toggle card.
  ///
  /// In fa, this message translates to:
  /// **'جهت صدور یادآور دوره‌ای'**
  String get expenseExpiryBody;

  /// The expiry date when it is exactly one year after the paid date.
  ///
  /// In fa, this message translates to:
  /// **'{date} (۱ سال بعد)'**
  String expenseExpiryOneYear(String date);

  /// Placeholder of the expiry row when no date is chosen.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب تاریخ انقضا'**
  String get expenseExpiryPick;

  /// Title of the expiry date picker sheet.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ انقضا (تقویم جلالی)'**
  String get expenseExpiryPickTitle;

  /// Pill next to the expiry date: days from today.
  ///
  /// In fa, this message translates to:
  /// **'{days, plural, =0{امروز} =1{۱ روز مانده} other{{days} روز مانده}}'**
  String expenseDaysLeft(int days);

  /// Label of the reminder checkbox.
  ///
  /// In fa, this message translates to:
  /// **'ارسال اعلان یادآور در روزهای ۷، ۱۵ و ۳۰ روز پیش از موعد'**
  String get expenseReminderCheck;

  /// Label of the attachment card.
  ///
  /// In fa, this message translates to:
  /// **'پیوست سند یا فیش پرداخت'**
  String get expenseAttachmentLabel;

  /// Trailing hint of the attachment card when a file is chosen.
  ///
  /// In fa, this message translates to:
  /// **'۱ فایل پیوست شده'**
  String get expenseAttachmentAttached;

  /// Trailing hint of the attachment card when no file is chosen.
  ///
  /// In fa, this message translates to:
  /// **'بدون پیوست'**
  String get expenseAttachmentNone;

  /// Tile that opens the file picker.
  ///
  /// In fa, this message translates to:
  /// **'افزودن سند یا فیش پرداخت'**
  String get expenseAttachmentAdd;

  /// Help line under the attachment card.
  ///
  /// In fa, this message translates to:
  /// **'فرمت‌های مجاز: PDF ، JPG و PNG تا سقف ۱۰ مگابایت.'**
  String get expenseAttachmentHelp;

  /// Tooltip of the remove button of the attachment.
  ///
  /// In fa, this message translates to:
  /// **'حذف فایل'**
  String get expenseAttachmentRemove;

  /// Second line of the attached file: size and kind.
  ///
  /// In fa, this message translates to:
  /// **'{size} • {kind}'**
  String expenseAttachmentMeta(String size, String kind);

  /// Kind of a PDF attachment.
  ///
  /// In fa, this message translates to:
  /// **'سند PDF'**
  String get expenseAttachmentPdf;

  /// Kind of an image attachment.
  ///
  /// In fa, this message translates to:
  /// **'تصویر'**
  String get expenseAttachmentImage;

  /// Error when the file picker fails.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب فایل ممکن نشد'**
  String get expenseAttachmentPickFailed;

  /// Error when the attachment has another type.
  ///
  /// In fa, this message translates to:
  /// **'فقط فایل PDF، JPG یا PNG مجاز است'**
  String get expenseAttachmentInvalid;

  /// Error when the attachment is above the size limit.
  ///
  /// In fa, this message translates to:
  /// **'حجم فایل بیشتر از {max} مگابایت است'**
  String expenseAttachmentTooLarge(int max);

  /// Label of the payment method buttons.
  ///
  /// In fa, this message translates to:
  /// **'شیوه پرداخت'**
  String get expensePaymentLabel;

  /// Payment method `online`.
  ///
  /// In fa, this message translates to:
  /// **'پرداخت اینترنتی'**
  String get expensePaymentOnline;

  /// Payment method `pos`.
  ///
  /// In fa, this message translates to:
  /// **'کارت‌خوان / پوز'**
  String get expensePaymentPos;

  /// Label of the issuer field.
  ///
  /// In fa, this message translates to:
  /// **'واحد صادرکننده یا نمایندگی'**
  String get expenseIssuerLabel;

  /// Placeholder of the issuer field.
  ///
  /// In fa, this message translates to:
  /// **'نام نمایندگی یا مرکز معاینه'**
  String get expenseIssuerHint;

  /// Snackbar after an expense is saved.
  ///
  /// In fa, this message translates to:
  /// **'هزینه ثبت شد'**
  String get expenseSaved;

  /// Snackbar when the expense is saved and its attachment upload fails.
  ///
  /// In fa, this message translates to:
  /// **'هزینه ثبت شد، اما پیوست ذخیره نشد'**
  String get expenseSavedAttachmentFailed;

  /// Snackbar when saving the expense fails.
  ///
  /// In fa, this message translates to:
  /// **'ثبت هزینه ممکن نشد'**
  String get expenseSaveFailed;

  /// Snackbar when the expense was rejected for invalid fields.
  ///
  /// In fa, this message translates to:
  /// **'برخی مقادیر نامعتبر است، فرم را بررسی کنید'**
  String get expenseSaveInvalid;

  /// Error when no category is chosen.
  ///
  /// In fa, this message translates to:
  /// **'سرفصل هزینه را انتخاب کنید'**
  String get expenseCategoryError;

  /// Inline error of the amount field.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ هزینه را وارد کنید'**
  String get expenseAmountError;

  /// Inline error of the title field.
  ///
  /// In fa, this message translates to:
  /// **'عنوان حداکثر {max} حرف است'**
  String expenseTitleError(int max);

  /// Inline error of the reference number field.
  ///
  /// In fa, this message translates to:
  /// **'شماره حداکثر {max} حرف است'**
  String expenseReferenceError(int max);

  /// Error when the paid date is after today.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ پرداخت نمی‌تواند در آینده باشد'**
  String get expensePaidAtError;

  /// Error when the expiry is missing or not after the paid date.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ انقضا باید بعد از تاریخ پرداخت باشد'**
  String get expenseExpiresAtError;

  /// Inline error of the issuer field.
  ///
  /// In fa, this message translates to:
  /// **'نام صادرکننده حداکثر {max} حرف است'**
  String expenseIssuerError(int max);

  /// Heading of the expense section on the vehicle details page.
  ///
  /// In fa, this message translates to:
  /// **'آخرین هزینه‌ها'**
  String get expenseSectionTitle;

  /// Empty state of the expense section.
  ///
  /// In fa, this message translates to:
  /// **'هنوز هزینه‌ای برای این خودرو ثبت نشده است'**
  String get expenseSectionEmpty;

  /// Error of the expense section.
  ///
  /// In fa, this message translates to:
  /// **'دریافت هزینه‌ها ممکن نشد'**
  String get expenseSectionLoadError;

  /// Tooltip of the app-bar bell with the unread count.
  ///
  /// In fa, this message translates to:
  /// **'{count, plural, =0{اعلانات} other{اعلانات، {count} خوانده‌نشده}}'**
  String notificationsUnreadLabel(int count);

  /// Title of the notifications page.
  ///
  /// In fa, this message translates to:
  /// **'صندوق اعلانات'**
  String get notificationsTitle;

  /// Unread count line at the top of the notifications page.
  ///
  /// In fa, this message translates to:
  /// **'{count, plural, =0{اعلان جدیدی نیست} other{{count} اعلان جدید}}'**
  String notificationsNewCount(int count);

  /// Button that marks every notification read.
  ///
  /// In fa, this message translates to:
  /// **'خواندن همه'**
  String get notificationsReadAll;

  /// Filter chip with every notification and its count.
  ///
  /// In fa, this message translates to:
  /// **'همه ({count})'**
  String notificationsFilterAll(int count);

  /// Filter chip of service reminders.
  ///
  /// In fa, this message translates to:
  /// **'سرویس و نگهداری'**
  String get notificationsFilterService;

  /// Filter chip of expiry reminders.
  ///
  /// In fa, this message translates to:
  /// **'بیمه و اسناد'**
  String get notificationsFilterDocuments;

  /// Filter chip of system notifications.
  ///
  /// In fa, this message translates to:
  /// **'سیستمی'**
  String get notificationsFilterSystem;

  /// Title of the empty state of a filter.
  ///
  /// In fa, this message translates to:
  /// **'اعلانی در این دسته‌بندی وجود ندارد'**
  String get notificationsEmptyTitle;

  /// Body of the empty state of a filter.
  ///
  /// In fa, this message translates to:
  /// **'تمام رویدادها و هشدارهای جدید در اینجا نمایش داده می‌شوند.'**
  String get notificationsEmptyBody;

  /// Button of the empty state that selects the All chip.
  ///
  /// In fa, this message translates to:
  /// **'مشاهده همه اعلان‌ها'**
  String get notificationsShowAll;

  /// Footer line of the notifications page.
  ///
  /// In fa, this message translates to:
  /// **'تمامی اعلانات به مدت ۹۰ روز در تاریخچه حفظ می‌گردند'**
  String get notificationsRetention;

  /// Load error of the notifications page.
  ///
  /// In fa, this message translates to:
  /// **'دریافت اعلان‌ها ممکن نشد'**
  String get notificationsLoadError;

  /// Snackbar when marking notifications read fails.
  ///
  /// In fa, this message translates to:
  /// **'انجام نشد، دوباره تلاش کنید'**
  String get notificationsActionFailed;

  /// Title of a service reminder: the interval title and the vehicle name.
  ///
  /// In fa, this message translates to:
  /// **'موعد {subject} {vehicle}'**
  String notificationIntervalTitle(String subject, String vehicle);

  /// First sentence of a service reminder.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد خودرو به {mileage} کیلومتر رسیده است.'**
  String notificationIntervalMileage(int mileage);

  /// Second sentence of a due-soon service reminder.
  ///
  /// In fa, this message translates to:
  /// **'تنها {km} کیلومتر تا سرویس باقی مانده است.'**
  String notificationIntervalRemaining(int km);

  /// Second sentence of an overdue service reminder.
  ///
  /// In fa, this message translates to:
  /// **'{km} کیلومتر از موعد گذشته است.'**
  String notificationIntervalOverdueKm(int km);

  /// Body of a date-only due-soon service reminder.
  ///
  /// In fa, this message translates to:
  /// **'موعد سرویس {date} است.'**
  String notificationIntervalDueDate(String date);

  /// Body of a date-only overdue service reminder.
  ///
  /// In fa, this message translates to:
  /// **'موعد سرویس {date} گذشته است.'**
  String notificationIntervalOverdueDate(String date);

  /// Action of a service reminder: opens the service wizard.
  ///
  /// In fa, this message translates to:
  /// **'ثبت سرویس'**
  String get notificationAddService;

  /// Title of an expiry reminder.
  ///
  /// In fa, this message translates to:
  /// **'سررسید {subject}'**
  String notificationExpiryTitle(String subject);

  /// Body of an expiry reminder; days counted from today.
  ///
  /// In fa, this message translates to:
  /// **'{subject} خودرو {vehicle} {days} روز دیگر به اتمام می‌رسد.'**
  String notificationExpiryBody(String subject, String vehicle, int days);

  /// Body of an expiry reminder once the date has passed.
  ///
  /// In fa, this message translates to:
  /// **'{subject} خودرو {vehicle} منقضی شده است.'**
  String notificationExpiredBody(String subject, String vehicle);

  /// Chip of an expiry reminder.
  ///
  /// In fa, this message translates to:
  /// **'{days} روز باقیمانده'**
  String notificationDaysLeft(int days);

  /// Chip of an expiry reminder once the date has passed.
  ///
  /// In fa, this message translates to:
  /// **'منقضی شده'**
  String get notificationExpired;

  /// Relative time under a minute.
  ///
  /// In fa, this message translates to:
  /// **'همین الان'**
  String get relativeJustNow;

  /// Relative time in minutes.
  ///
  /// In fa, this message translates to:
  /// **'{count} دقیقه پیش'**
  String relativeMinutesAgo(int count);

  /// Relative time in hours (same day).
  ///
  /// In fa, this message translates to:
  /// **'{count} ساعت پیش'**
  String relativeHoursAgo(int count);

  /// Relative time for yesterday with the clock time.
  ///
  /// In fa, this message translates to:
  /// **'دیروز، {time}'**
  String relativeYesterday(String time);

  /// Relative time 7 to 13 days ago.
  ///
  /// In fa, this message translates to:
  /// **'هفته گذشته'**
  String get relativeLastWeek;

  /// Title of the documents page.
  ///
  /// In fa, this message translates to:
  /// **'کیف مدارک خودرو'**
  String get documentsTitle;

  /// Line under the vehicle name on the documents page.
  ///
  /// In fa, this message translates to:
  /// **'کیف مدارک و یادآورهای هوشمند تمدید'**
  String get documentsVehicleSubtitle;

  /// Encryption note with the number of documents.
  ///
  /// In fa, this message translates to:
  /// **'{count} مدرک ثبت‌شده به‌صورت رمزگذاری‌شده نگهداری می‌شوند.'**
  String documentsSecureInfo(int count);

  /// Title of the upload card.
  ///
  /// In fa, this message translates to:
  /// **'بارگذاری مدرک جدید'**
  String get documentsUploadTitle;

  /// Body of the upload card.
  ///
  /// In fa, this message translates to:
  /// **'تصویر یا فایل PDF (کارت خودرو، بیمه‌نامه، معاینه فنی، برگ سبز یا وکالت)'**
  String get documentsUploadBody;

  /// Upload from the camera.
  ///
  /// In fa, this message translates to:
  /// **'دوربین'**
  String get documentsUploadCamera;

  /// Upload from the gallery.
  ///
  /// In fa, this message translates to:
  /// **'گالری'**
  String get documentsUploadGallery;

  /// Upload a PDF file.
  ///
  /// In fa, this message translates to:
  /// **'فایل PDF'**
  String get documentsUploadPdf;

  /// Filter chip with every document.
  ///
  /// In fa, this message translates to:
  /// **'همه ({count})'**
  String documentsFilterAll(int count);

  /// Filter chip of insurance documents.
  ///
  /// In fa, this message translates to:
  /// **'بیمه‌ها ({count})'**
  String documentsGroupInsurance(int count);

  /// Filter chip of inspection documents.
  ///
  /// In fa, this message translates to:
  /// **'معاینه فنی ({count})'**
  String documentsGroupInspection(int count);

  /// Filter chip of identity documents.
  ///
  /// In fa, this message translates to:
  /// **'مدارک هویتی ({count})'**
  String documentsGroupIdentity(int count);

  /// Empty documents list.
  ///
  /// In fa, this message translates to:
  /// **'هنوز مدرکی برای این خودرو ثبت نشده است'**
  String get documentsEmpty;

  /// Empty result of a filter chip.
  ///
  /// In fa, this message translates to:
  /// **'مدرکی در این دسته وجود ندارد'**
  String get documentsFilterEmpty;

  /// Load error of the documents page.
  ///
  /// In fa, this message translates to:
  /// **'دریافت مدارک ممکن نشد'**
  String get documentsLoadError;

  /// Document type.
  ///
  /// In fa, this message translates to:
  /// **'بیمه شخص ثالث'**
  String get documentTypeThirdPartyInsurance;

  /// Document type.
  ///
  /// In fa, this message translates to:
  /// **'بیمه بدنه'**
  String get documentTypeBodyInsurance;

  /// Document type.
  ///
  /// In fa, this message translates to:
  /// **'معاینه فنی'**
  String get documentTypeInspection;

  /// Document type.
  ///
  /// In fa, this message translates to:
  /// **'کارت خودرو'**
  String get documentTypeVehicleCard;

  /// Document type.
  ///
  /// In fa, this message translates to:
  /// **'برگ سبز (سند مالکیت)'**
  String get documentTypeGreenSheet;

  /// Document type.
  ///
  /// In fa, this message translates to:
  /// **'وکالت‌نامه'**
  String get documentTypePowerOfAttorney;

  /// Status pill of an expired document.
  ///
  /// In fa, this message translates to:
  /// **'منقضی شده — {days} روز گذشته'**
  String documentStatusExpired(int days);

  /// Status pill of a document expiring within 15 days.
  ///
  /// In fa, this message translates to:
  /// **'موعد نزدیک — {days} روز مانده'**
  String documentStatusDueSoon(int days);

  /// Status pill of a valid document.
  ///
  /// In fa, this message translates to:
  /// **'معتبر — {days} روز مانده'**
  String documentStatusValid(int days);

  /// Status pill of a document without expiry.
  ///
  /// In fa, this message translates to:
  /// **'دائمی / بدون انقضا'**
  String get documentStatusPermanent;

  /// The document number on its card.
  ///
  /// In fa, this message translates to:
  /// **'شماره: {number}'**
  String documentNumber(String number);

  /// Issue date on a document card.
  ///
  /// In fa, this message translates to:
  /// **'صدور: {date}'**
  String documentIssuedAt(String date);

  /// Expiry date on a document card.
  ///
  /// In fa, this message translates to:
  /// **'انقضا: {date}'**
  String documentExpiresAt(String date);

  /// Footer of a document card with a reminder.
  ///
  /// In fa, this message translates to:
  /// **'یادآور تمدید فعال است'**
  String get documentReminderOn;

  /// Opens the first file of a document.
  ///
  /// In fa, this message translates to:
  /// **'مشاهده اصل فایل'**
  String get documentViewFile;

  /// Opens the form for a renewal of an expired document.
  ///
  /// In fa, this message translates to:
  /// **'ثبت تمدید جدید'**
  String get documentRenew;

  /// Semantics of the chevron of a document card.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات'**
  String get documentDetails;

  /// File badge of a document with several images.
  ///
  /// In fa, this message translates to:
  /// **'{count} تصویر'**
  String documentImageCount(int count);

  /// Snackbar when a file can't be loaded.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن فایل ممکن نشد'**
  String get documentFileOpenFailed;

  /// Title of the new document form and its submit button.
  ///
  /// In fa, this message translates to:
  /// **'ثبت مدرک'**
  String get documentFormNewTitle;

  /// Title of the edit document form.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش مدرک'**
  String get documentFormEditTitle;

  /// Label of the type grid.
  ///
  /// In fa, this message translates to:
  /// **'نوع مدرک'**
  String get documentTypeLabel;

  /// Label of the title field.
  ///
  /// In fa, this message translates to:
  /// **'عنوان مدرک'**
  String get documentTitleLabel;

  /// Hint of the title field.
  ///
  /// In fa, this message translates to:
  /// **'مثلاً گواهی معاینه فنی برتر'**
  String get documentTitleHint;

  /// Label of the issuer field.
  ///
  /// In fa, this message translates to:
  /// **'صادرکننده'**
  String get documentIssuerLabel;

  /// Hint of the issuer field.
  ///
  /// In fa, this message translates to:
  /// **'مثلاً بیمه ایران'**
  String get documentIssuerHint;

  /// Label of the number field.
  ///
  /// In fa, this message translates to:
  /// **'شماره مدرک / بیمه‌نامه'**
  String get documentNumberLabel;

  /// Hint of the number field.
  ///
  /// In fa, this message translates to:
  /// **'مثلاً ۱۲۴/۹۸۷۴۳۲'**
  String get documentNumberHint;

  /// Label of the issue date row.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ صدور'**
  String get documentIssuedAtLabel;

  /// Issue date row before a date is chosen.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب تاریخ صدور'**
  String get documentIssuedAtPick;

  /// Title of the issue date picker.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ صدور (تقویم جلالی)'**
  String get documentIssuedAtPickTitle;

  /// Clears the issue date.
  ///
  /// In fa, this message translates to:
  /// **'حذف تاریخ صدور'**
  String get documentIssuedAtClear;

  /// Label of the notes field.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت'**
  String get documentNotesLabel;

  /// Hint of the notes field.
  ///
  /// In fa, this message translates to:
  /// **'توضیحات تکمیلی (اختیاری)'**
  String get documentNotesHint;

  /// Label of the files card.
  ///
  /// In fa, this message translates to:
  /// **'فایل‌های مدرک'**
  String get documentFilesLabel;

  /// Number of files out of the maximum.
  ///
  /// In fa, this message translates to:
  /// **'{count} از {max}'**
  String documentFilesCount(int count, int max);

  /// Adds a file to the document.
  ///
  /// In fa, this message translates to:
  /// **'افزودن فایل'**
  String get documentFilesAdd;

  /// Help line of the files card.
  ///
  /// In fa, this message translates to:
  /// **'حداکثر {max} فایل PDF، JPG یا PNG، هر کدام تا ۱۰ مگابایت.'**
  String documentFilesHelp(int max);

  /// Error when too many files are attached.
  ///
  /// In fa, this message translates to:
  /// **'حداکثر {max} فایل برای هر مدرک'**
  String documentFileLimit(int max);

  /// Submit button of the edit form.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره مدرک'**
  String get documentSave;

  /// Snackbar after saving.
  ///
  /// In fa, this message translates to:
  /// **'مدرک ذخیره شد'**
  String get documentSaved;

  /// Snackbar when the document is saved but a file is not.
  ///
  /// In fa, this message translates to:
  /// **'مدرک ذخیره شد، اما بارگذاری فایل انجام نشد'**
  String get documentSavedFilesFailed;

  /// Snackbar of a rejected document.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات مدرک را بررسی کنید'**
  String get documentSaveInvalid;

  /// Snackbar of a failed save.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره مدرک ممکن نشد'**
  String get documentSaveFailed;

  /// Error of the type grid.
  ///
  /// In fa, this message translates to:
  /// **'نوع مدرک را انتخاب کنید'**
  String get documentTypeError;

  /// Error of the title field.
  ///
  /// In fa, this message translates to:
  /// **'عنوان حداکثر {max} حرف است'**
  String documentTitleError(int max);

  /// Error of the issuer field.
  ///
  /// In fa, this message translates to:
  /// **'صادرکننده حداکثر {max} حرف است'**
  String documentIssuerError(int max);

  /// Error of the number field.
  ///
  /// In fa, this message translates to:
  /// **'شماره حداکثر {max} حرف است'**
  String documentNumberError(int max);

  /// Error of the notes field.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت حداکثر {max} حرف است'**
  String documentNotesError(int max);

  /// Error of the expiry row.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ انقضا را بعد از تاریخ صدور انتخاب کنید'**
  String get documentExpiresAtError;

  /// Delete action of the edit form.
  ///
  /// In fa, this message translates to:
  /// **'حذف مدرک'**
  String get documentDelete;

  /// Title of the delete confirmation.
  ///
  /// In fa, this message translates to:
  /// **'این مدرک حذف شود؟'**
  String get documentDeleteConfirmTitle;

  /// Body of the delete confirmation.
  ///
  /// In fa, this message translates to:
  /// **'مدرک و همه فایل‌های آن برای همیشه حذف می‌شوند.'**
  String get documentDeleteConfirmBody;

  /// Cancel of the delete confirmation.
  ///
  /// In fa, this message translates to:
  /// **'انصراف'**
  String get documentDeleteCancel;

  /// Snackbar after deleting.
  ///
  /// In fa, this message translates to:
  /// **'مدرک حذف شد'**
  String get documentDeleted;

  /// Snackbar of a failed delete.
  ///
  /// In fa, this message translates to:
  /// **'حذف مدرک ممکن نشد'**
  String get documentDeleteFailed;

  /// Snackbar of a failed file removal.
  ///
  /// In fa, this message translates to:
  /// **'حذف فایل ممکن نشد'**
  String get documentFileDeleteFailed;

  /// Profile stat tile: documents across all vehicles.
  ///
  /// In fa, this message translates to:
  /// **'مدرک در کیف'**
  String get profileStatDocuments;

  /// Title of the report export page.
  ///
  /// In fa, this message translates to:
  /// **'خروجی گزارش'**
  String get reportExportTitle;

  /// Heading of the vehicle scope card.
  ///
  /// In fa, this message translates to:
  /// **'دامنه خودروی گزارش'**
  String get reportScopeTitle;

  /// Chip next to the vehicle scope heading.
  ///
  /// In fa, this message translates to:
  /// **'قابل تغییر'**
  String get reportScopeChangeable;

  /// Scope segment for every vehicle of the garage.
  ///
  /// In fa, this message translates to:
  /// **'همه خودروها ({count})'**
  String reportScopeAll(int count);

  /// Heading of the date range card.
  ///
  /// In fa, this message translates to:
  /// **'بازه زمانی گزارش'**
  String get reportPeriodTitle;

  /// Note next to the date range heading.
  ///
  /// In fa, this message translates to:
  /// **'تقویم جلالی'**
  String get reportJalaliCalendar;

  /// Quick range pill.
  ///
  /// In fa, this message translates to:
  /// **'۳ ماه اخیر'**
  String get reportPeriodThreeMonths;

  /// Quick range pill.
  ///
  /// In fa, this message translates to:
  /// **'۶ ماه گذشته'**
  String get reportPeriodSixMonths;

  /// Quick range pill with the current Jalali year.
  ///
  /// In fa, this message translates to:
  /// **'سال جاری ({year})'**
  String reportPeriodCurrentYear(String year);

  /// Quick range pill without a start date; also the PDF range start.
  ///
  /// In fa, this message translates to:
  /// **'کل سوابق'**
  String get reportPeriodAll;

  /// Label of the start date field.
  ///
  /// In fa, this message translates to:
  /// **'از تاریخ'**
  String get reportFrom;

  /// Label of the end date field.
  ///
  /// In fa, this message translates to:
  /// **'تا تاریخ'**
  String get reportTo;

  /// Date field value when the range has no start.
  ///
  /// In fa, this message translates to:
  /// **'—'**
  String get reportDateUnset;

  /// Heading of the content card.
  ///
  /// In fa, this message translates to:
  /// **'محتوای گزارش خروجی'**
  String get reportContentTitle;

  /// Toggles every content box.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب همه'**
  String get reportSelectAll;

  /// Content box: service visits.
  ///
  /// In fa, this message translates to:
  /// **'سرویس‌ها و تعمیرات'**
  String get reportContentServices;

  /// Subtitle of the services box.
  ///
  /// In fa, this message translates to:
  /// **'فاکتورها، قطعات مصرفی، اجرت تعمیرگاه'**
  String get reportContentServicesHint;

  /// Content box: fuel logs.
  ///
  /// In fa, this message translates to:
  /// **'سوابق سوخت‌گیری'**
  String get reportContentFuel;

  /// Subtitle of the fuel box.
  ///
  /// In fa, this message translates to:
  /// **'لیتر، هزینه، جایگاه‌ها و محاسبه مصرف میانگین'**
  String get reportContentFuelHint;

  /// Content box: expenses.
  ///
  /// In fa, this message translates to:
  /// **'هزینه‌های جانبی'**
  String get reportContentExpenses;

  /// Subtitle of the expenses box.
  ///
  /// In fa, this message translates to:
  /// **'بیمه شخص ثالث، عوارض سالیانه، خلافی، معاینه فنی'**
  String get reportContentExpensesHint;

  /// Content box: append attachment images to the PDF; also the PDF attachments heading.
  ///
  /// In fa, this message translates to:
  /// **'تصاویر پیوست فاکتورها'**
  String get reportContentImages;

  /// Subtitle of the images box.
  ///
  /// In fa, this message translates to:
  /// **'ضمیمه کردن تصاویر مدارک در انتهای فایل PDF'**
  String get reportContentImagesHint;

  /// Label of the preview card.
  ///
  /// In fa, this message translates to:
  /// **'پیش‌نمایش خروجی مدنظر'**
  String get reportPreviewTitle;

  /// Preview line, before the record count.
  ///
  /// In fa, this message translates to:
  /// **'شامل'**
  String get reportPreviewIncludes;

  /// Preview line, after the record count.
  ///
  /// In fa, this message translates to:
  /// **'رکورد ثبت‌شده'**
  String get reportPreviewRecords;

  /// Preview line, before the total cost.
  ///
  /// In fa, this message translates to:
  /// **'مجموع:'**
  String get reportPreviewTotal;

  /// Preview card when the report request fails.
  ///
  /// In fa, this message translates to:
  /// **'محاسبه پیش‌نمایش ممکن نشد'**
  String get reportPreviewError;

  /// Preview card when the server refuses a too-large report (422).
  ///
  /// In fa, this message translates to:
  /// **'بازه گزارش بیش از حد بزرگ است'**
  String get reportTooLarge;

  /// Preview card when no content box is checked.
  ///
  /// In fa, this message translates to:
  /// **'حداقل یک مورد را برای گزارش انتخاب کنید'**
  String get reportNoContent;

  /// PDF download button.
  ///
  /// In fa, this message translates to:
  /// **'دریافت خروجی PDF رسمی'**
  String get reportDownloadPdf;

  /// CSV download button.
  ///
  /// In fa, this message translates to:
  /// **'دریافت فایل اکسل (Excel / CSV)'**
  String get reportDownloadCsv;

  /// Toast after a PDF export.
  ///
  /// In fa, this message translates to:
  /// **'فایل PDF رسمی سوابق با موفقیت ایجاد شد.'**
  String get reportPdfDone;

  /// Toast after a CSV export.
  ///
  /// In fa, this message translates to:
  /// **'فایل اکسل محاسباتی آماده بارگیری گردید.'**
  String get reportCsvDone;

  /// Snackbar when building or saving the file fails.
  ///
  /// In fa, this message translates to:
  /// **'ساخت فایل گزارش ممکن نشد'**
  String get reportExportFailed;

  /// Close button of the export toast.
  ///
  /// In fa, this message translates to:
  /// **'بستن'**
  String get reportToastClose;

  /// CSV/PDF type column: service visit.
  ///
  /// In fa, this message translates to:
  /// **'سرویس'**
  String get reportTypeService;

  /// CSV/PDF type column: fill-up.
  ///
  /// In fa, this message translates to:
  /// **'سوخت'**
  String get reportTypeFuel;

  /// CSV/PDF type column: expense.
  ///
  /// In fa, this message translates to:
  /// **'هزینه'**
  String get reportTypeExpense;

  /// CSV/PDF column.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ'**
  String get reportColumnDate;

  /// CSV/PDF column.
  ///
  /// In fa, this message translates to:
  /// **'خودرو'**
  String get reportColumnVehicle;

  /// CSV/PDF column.
  ///
  /// In fa, this message translates to:
  /// **'پلاک'**
  String get reportColumnPlate;

  /// CSV/PDF column.
  ///
  /// In fa, this message translates to:
  /// **'نوع'**
  String get reportColumnType;

  /// CSV/PDF column.
  ///
  /// In fa, this message translates to:
  /// **'شرح'**
  String get reportColumnDescription;

  /// CSV/PDF column.
  ///
  /// In fa, this message translates to:
  /// **'کیلومتر'**
  String get reportColumnKm;

  /// CSV/PDF column.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ (تومان)'**
  String get reportColumnAmount;

  /// Last CSV row and PDF table total row.
  ///
  /// In fa, this message translates to:
  /// **'جمع کل'**
  String get reportTotalRow;

  /// PDF header: the Jalali date range.
  ///
  /// In fa, this message translates to:
  /// **'بازه گزارش: {from} تا {to}'**
  String reportPdfRange(String from, String to);

  /// PDF header: the vehicle nicknames.
  ///
  /// In fa, this message translates to:
  /// **'خودرو: {vehicles}'**
  String reportPdfVehicles(String vehicles);

  /// PDF header: the creation date.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ تهیه: {date}'**
  String reportPdfGeneratedAt(String date);

  /// PDF summary label.
  ///
  /// In fa, this message translates to:
  /// **'تعداد رکورد'**
  String get reportPdfEntryCount;

  /// PDF summary label.
  ///
  /// In fa, this message translates to:
  /// **'مجموع هزینه'**
  String get reportPdfTotalCost;

  /// PDF summary label.
  ///
  /// In fa, this message translates to:
  /// **'تعداد سرویس'**
  String get reportPdfServiceCount;

  /// PDF summary label.
  ///
  /// In fa, this message translates to:
  /// **'سوخت (لیتر)'**
  String get reportPdfFuelVolume;

  /// PDF summary amount.
  ///
  /// In fa, this message translates to:
  /// **'{amount} تومان'**
  String reportPdfToman(String amount);

  /// PDF heading of the non-image attachments.
  ///
  /// In fa, this message translates to:
  /// **'سایر فایل‌های پیوست'**
  String get reportPdfOtherFiles;

  /// Title of the plans page.
  ///
  /// In fa, this message translates to:
  /// **'اشتراک و پلن‌ها'**
  String get plansTitle;

  /// Badge of the plans hero banner.
  ///
  /// In fa, this message translates to:
  /// **'شفاف، بدون تعهد و قابل لغو در هر زمان'**
  String get plansHeroBadge;

  /// Title of the plans hero banner.
  ///
  /// In fa, this message translates to:
  /// **'پلن‌ها و اشتراک‌ها'**
  String get plansHeroTitle;

  /// Body of the plans hero banner.
  ///
  /// In fa, this message translates to:
  /// **'امکانات نامحدود برای ثبت دقیق هزینه‌ها، سوابق فنی و ارتقای ارزش خودرو'**
  String get plansHeroBody;

  /// Billing toggle: monthly.
  ///
  /// In fa, this message translates to:
  /// **'ماهانه'**
  String get plansMonthly;

  /// Billing toggle: yearly.
  ///
  /// In fa, this message translates to:
  /// **'سالیانه'**
  String get plansYearly;

  /// Discount chip of the yearly toggle.
  ///
  /// In fa, this message translates to:
  /// **'۲۰٪ تخفیف'**
  String get plansYearlyDiscount;

  /// Price unit, monthly.
  ///
  /// In fa, this message translates to:
  /// **'تومان / ماهانه'**
  String get plansPerMonth;

  /// Price unit, yearly.
  ///
  /// In fa, this message translates to:
  /// **'تومان / سالانه'**
  String get plansPerYear;

  /// Disabled button of the current plan.
  ///
  /// In fa, this message translates to:
  /// **'پلن فعلی شما'**
  String get plansCurrent;

  /// Tag of the basic plan.
  ///
  /// In fa, this message translates to:
  /// **'شروع استاندارد'**
  String get plansBasicTag;

  /// Name of the basic plan.
  ///
  /// In fa, this message translates to:
  /// **'پایه (همیشه رایگان)'**
  String get plansBasicName;

  /// Basic plan feature.
  ///
  /// In fa, this message translates to:
  /// **'حداکثر ۱ خودرو در گاراژ'**
  String get plansBasicFeature1;

  /// Basic plan feature.
  ///
  /// In fa, this message translates to:
  /// **'ثبت نامحدود سرویس و سوخت'**
  String get plansBasicFeature2;

  /// Basic plan feature.
  ///
  /// In fa, this message translates to:
  /// **'یادآور درون‌برنامه‌ای (بدون پیامک)'**
  String get plansBasicFeature3;

  /// Basic plan feature.
  ///
  /// In fa, this message translates to:
  /// **'خروجی گزارش ساده متنی'**
  String get plansBasicFeature4;

  /// Badge above the pro plan card.
  ///
  /// In fa, this message translates to:
  /// **'پیشنهاد ما'**
  String get plansProBadge;

  /// Tag of the pro plan.
  ///
  /// In fa, this message translates to:
  /// **'بیشترین انتخاب مالکان'**
  String get plansProTag;

  /// Name of the pro plan.
  ///
  /// In fa, this message translates to:
  /// **'حرفه‌ای (پلاس)'**
  String get plansProName;

  /// Pro plan subtitle, monthly.
  ///
  /// In fa, this message translates to:
  /// **'تسویه‌حساب ماهانه بدون تعهد زمانی'**
  String get plansProMonthlyNote;

  /// Pro plan subtitle, yearly.
  ///
  /// In fa, this message translates to:
  /// **'معادل {amount} تومان در ماه (۲۰٪ صرفه‌جویی)'**
  String plansProYearlyNote(String amount);

  /// Pro plan feature.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت همزمان تا ۳ خودرو در یک گاراژ'**
  String get plansProFeature1;

  /// Pro plan feature.
  ///
  /// In fa, this message translates to:
  /// **'یادآور پیامکی تمدید بیمه، معاینه و سرویس دوره'**
  String get plansProFeature2;

  /// Pro plan feature.
  ///
  /// In fa, this message translates to:
  /// **'خروجی شناسنامه سلامت فنی خودرو (PDF رسمی و اکسل)'**
  String get plansProFeature3;

  /// Pro plan feature.
  ///
  /// In fa, this message translates to:
  /// **'کیف مدارک نامحدود با فضای امن ابری'**
  String get plansProFeature4;

  /// Pro plan feature.
  ///
  /// In fa, this message translates to:
  /// **'انتقال دیجیتال سوابق سرویس به خریدار هنگام فروش'**
  String get plansProFeature5;

  /// Upgrade button of the pro plan.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب و ارتقا به حرفه‌ای'**
  String get plansProCta;

  /// Tag of the unlimited plan.
  ///
  /// In fa, this message translates to:
  /// **'ناوگان و خانواده'**
  String get plansMasterTag;

  /// Name of the unlimited plan.
  ///
  /// In fa, this message translates to:
  /// **'گاراژ نامحدود'**
  String get plansMasterName;

  /// Unlimited plan subtitle, monthly.
  ///
  /// In fa, this message translates to:
  /// **'برای مجموعه‌داران و مدیران چند خودرو'**
  String get plansMasterMonthlyNote;

  /// Unlimited plan subtitle, yearly.
  ///
  /// In fa, this message translates to:
  /// **'معادل {amount} تومان در ماه با اولویت کامل'**
  String plansMasterYearlyNote(String amount);

  /// Unlimited plan feature.
  ///
  /// In fa, this message translates to:
  /// **'خودرو نامحدود در پنل اصلی'**
  String get plansMasterFeature1;

  /// Unlimited plan feature.
  ///
  /// In fa, this message translates to:
  /// **'ارسال پیامک یادآور به چند شماره مجزا (رانندگان)'**
  String get plansMasterFeature2;

  /// Unlimited plan feature.
  ///
  /// In fa, this message translates to:
  /// **'پشتیبانی تلفنی اختصاصی و آنی'**
  String get plansMasterFeature3;

  /// Unlimited plan feature.
  ///
  /// In fa, this message translates to:
  /// **'خروجی مالی جامع برای امور مالیاتی و بیمه'**
  String get plansMasterFeature4;

  /// Upgrade button of the unlimited plan.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب پلن نامحدود'**
  String get plansMasterCta;

  /// Heading of the guarantee card.
  ///
  /// In fa, this message translates to:
  /// **'تضمین شفافیت و رضایت'**
  String get plansGuaranteeTitle;

  /// Body of the guarantee card.
  ///
  /// In fa, this message translates to:
  /// **'تمدید خودکار ناخواسته در این سیستم وجود ندارد. تا ۷ روز پس از خرید اشتراک، در صورت عدم رضایت کامل، وجه پرداختی بدون پرسش به حساب بانکی شما بازگردانده می‌شود.'**
  String get plansGuaranteeBody;

  /// Guarantee card note.
  ///
  /// In fa, this message translates to:
  /// **'درگاه پرداخت امن شاپرک'**
  String get plansSecurePayment;

  /// Guarantee card note.
  ///
  /// In fa, this message translates to:
  /// **'پشتیبانی ۷ روز هفته'**
  String get plansSupport;

  /// Profile subscription card: the current plan.
  ///
  /// In fa, this message translates to:
  /// **'اشتراک پایه'**
  String get profilePlanTitle;

  /// Profile subscription card: the plan chip.
  ///
  /// In fa, this message translates to:
  /// **'رایگان'**
  String get profilePlanBadge;

  /// Profile subscription card: subtitle.
  ///
  /// In fa, this message translates to:
  /// **'پلن فعلی شما • همیشه رایگان'**
  String get profilePlanHint;

  /// Profile subscription card: opens the plans page.
  ///
  /// In fa, this message translates to:
  /// **'ارتقا یا تمدید'**
  String get profilePlanUpgrade;

  /// Vehicle options menu: opens the ownership transfer page.
  ///
  /// In fa, this message translates to:
  /// **'انتقال مالکیت'**
  String get vehicleTransfer;

  /// Title of the transfer page.
  ///
  /// In fa, this message translates to:
  /// **'انتقال مالکیت خودرو'**
  String get transferTitle;

  /// Chip on the vehicle card of the transfer page.
  ///
  /// In fa, this message translates to:
  /// **'فعال در گاراژ'**
  String get transferActiveInGarage;

  /// Mileage label on the vehicle card of the transfer page.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد جاری:'**
  String get transferMileage;

  /// Unit after the mileage.
  ///
  /// In fa, this message translates to:
  /// **'کیلومتر'**
  String get transferKm;

  /// Heading of the phone card.
  ///
  /// In fa, this message translates to:
  /// **'شماره تلفن همراه مالک جدید (خریدار)'**
  String get transferPhoneTitle;

  /// Subtitle of the phone card (replaces Stitch's SMS sentence: no SMS is sent).
  ///
  /// In fa, this message translates to:
  /// **'درخواست انتقال در حساب کاربری این شماره نمایش داده می‌شود و پس از تایید خریدار انجام می‌شود.'**
  String get transferPhoneHint;

  /// Semantics label of the phone field.
  ///
  /// In fa, this message translates to:
  /// **'شماره همراه خریدار'**
  String get transferPhoneLabel;

  /// Info note under the phone field (Stitch's note without the SMS part).
  ///
  /// In fa, this message translates to:
  /// **'مالک جدید باید در سامانه «مدیریت خودرو» با همین شماره همراه حساب کاربری داشته باشد یا ثبت‌نام کند تا درخواست را ببیند.'**
  String get transferPhoneNote;

  /// Heading of the transferred items card.
  ///
  /// In fa, this message translates to:
  /// **'اقلامی که به مالک جدید منتقل می‌شوند'**
  String get transferItemsTitle;

  /// Transferred item.
  ///
  /// In fa, this message translates to:
  /// **'سوابق کامل سرویس‌ها و فاکتورها'**
  String get transferItemServices;

  /// Transferred item hint.
  ///
  /// In fa, this message translates to:
  /// **'تمام جزئیات مراجعات به تعمیرگاه، قطعات مصرفی و تعویض‌شده'**
  String get transferItemServicesHint;

  /// Transferred item.
  ///
  /// In fa, this message translates to:
  /// **'دوره‌های سرویس و کیلومتر جاری'**
  String get transferItemIntervals;

  /// Transferred item hint.
  ///
  /// In fa, this message translates to:
  /// **'فواصل استاندارد نگهداری، روغن موتور، تسمه‌تایم و فیلترها'**
  String get transferItemIntervalsHint;

  /// Transferred item.
  ///
  /// In fa, this message translates to:
  /// **'تصاویر اسناد فنی و گارانتی فعال'**
  String get transferItemDocuments;

  /// Transferred item hint.
  ///
  /// In fa, this message translates to:
  /// **'فاکتورهای رسمی و مهلت‌های باقی‌مانده از دفترچه گارانتی'**
  String get transferItemDocumentsHint;

  /// Transferred item.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه هزینه‌های سوخت'**
  String get transferItemFuel;

  /// Transferred item hint.
  ///
  /// In fa, this message translates to:
  /// **'گزارش میانگین مصرف در هر ۱۰۰ کیلومتر و نوع سوخت ثبت‌شده'**
  String get transferItemFuelHint;

  /// Item that is not transferred.
  ///
  /// In fa, this message translates to:
  /// **'مدارک هویتی و خصوصی مالک پیشین (منتقل نمی‌شود)'**
  String get transferItemPrivate;

  /// Hint of the item that is not transferred.
  ///
  /// In fa, this message translates to:
  /// **'تصویر کارت ملی، اسناد مالکیت شخصی و تراکنش‌های بانکی به صورت خودکار حذف می‌گردند.'**
  String get transferItemPrivateHint;

  /// Heading of the rules card.
  ///
  /// In fa, this message translates to:
  /// **'قوانین حفظ حریم خصوصی و نگهداری سوابق'**
  String get transferRulesTitle;

  /// Intro of the rules.
  ///
  /// In fa, this message translates to:
  /// **'پس از تایید و پذیرش نهایی انتقال توسط خریدار:'**
  String get transferRulesIntro;

  /// Rule 1.
  ///
  /// In fa, this message translates to:
  /// **'این خودرو از گاراژ فعال شما خارج شده و کلیه دسترسی‌های مدیریتی و ویرایش آن بلافاصله سلب خواهد شد.'**
  String get transferRule1;

  /// Rule 2.
  ///
  /// In fa, this message translates to:
  /// **'پیش از ارسال درخواست، در صورت نیاز از صفحه «خروجی گزارش» یک نسخه PDF یا اکسل از سوابق تهیه کنید.'**
  String get transferRule2;

  /// Link under rule 2 to the report export page.
  ///
  /// In fa, this message translates to:
  /// **'رفتن به خروجی گزارش'**
  String get transferRule2Link;

  /// Rule 3.
  ///
  /// In fa, this message translates to:
  /// **'مالک جدید به هیچ عنوان امکان تغییر، دستکاری یا حذف اطلاعات ثبت‌شده در دوران مالکیت شما را نخواهد داشت.'**
  String get transferRule3;

  /// Consent checkbox.
  ///
  /// In fa, this message translates to:
  /// **'صحت شماره تلفن همراه خریدار و واگذاری کامل کنترل فنی و فاکتورهای خودرو را تایید می‌نمایم.'**
  String get transferConsent;

  /// Submit button.
  ///
  /// In fa, this message translates to:
  /// **'تایید نهایی و ارسال درخواست انتقال'**
  String get transferSubmit;

  /// Secondary button.
  ///
  /// In fa, this message translates to:
  /// **'انصراف و بازگشت به گاراژ'**
  String get transferBack;

  /// Title of the final confirmation.
  ///
  /// In fa, this message translates to:
  /// **'درخواست انتقال ارسال شود؟'**
  String get transferConfirmTitle;

  /// Body of the final confirmation.
  ///
  /// In fa, this message translates to:
  /// **'«{vehicle}» پس از تایید صاحب شماره {phone} از گاراژ شما خارج می‌شود.'**
  String transferConfirmBody(String vehicle, String phone);

  /// Confirm button of the final confirmation.
  ///
  /// In fa, this message translates to:
  /// **'ارسال درخواست'**
  String get transferConfirmSend;

  /// Snackbar after sending.
  ///
  /// In fa, this message translates to:
  /// **'درخواست انتقال ارسال شد'**
  String get transferSent;

  /// Snackbar for an invalid phone (400).
  ///
  /// In fa, this message translates to:
  /// **'شماره همراه معتبر نیست'**
  String get transferInvalidPhone;

  /// Snackbar for a self transfer (422).
  ///
  /// In fa, this message translates to:
  /// **'نمی‌توانید خودرو را به شماره خودتان منتقل کنید'**
  String get transferSelf;

  /// Snackbar for a duplicate request (409).
  ///
  /// In fa, this message translates to:
  /// **'برای این خودرو یک درخواست انتقال در انتظار وجود دارد'**
  String get transferAlreadyPending;

  /// Snackbar for another failure.
  ///
  /// In fa, this message translates to:
  /// **'ارسال درخواست ممکن نشد'**
  String get transferFailed;

  /// Heading of the pending transfer card.
  ///
  /// In fa, this message translates to:
  /// **'درخواست انتقال در انتظار تایید خریدار'**
  String get transferPendingTitle;

  /// Pending transfer: the phone.
  ///
  /// In fa, this message translates to:
  /// **'شماره خریدار: {phone}'**
  String transferPendingPhone(String phone);

  /// Pending transfer: the date.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ ارسال: {date}'**
  String transferPendingDate(String date);

  /// Cancels the pending transfer.
  ///
  /// In fa, this message translates to:
  /// **'لغو درخواست'**
  String get transferCancelRequest;

  /// Snackbar after cancelling.
  ///
  /// In fa, this message translates to:
  /// **'درخواست انتقال لغو شد'**
  String get transferCancelled;

  /// Snackbar of a failed cancel.
  ///
  /// In fa, this message translates to:
  /// **'لغو درخواست ممکن نشد'**
  String get transferCancelFailed;

  /// Error of the transfers load.
  ///
  /// In fa, this message translates to:
  /// **'بارگذاری درخواست‌های انتقال ممکن نشد'**
  String get transfersLoadError;

  /// Banner and card title for an incoming transfer.
  ///
  /// In fa, this message translates to:
  /// **'درخواست انتقال خودرو'**
  String get incomingTransferTitle;

  /// Banner and card body.
  ///
  /// In fa, this message translates to:
  /// **'{sender} می‌خواهد «{vehicle}» را به گاراژ شما منتقل کند.'**
  String incomingTransferBody(String sender, String vehicle);

  /// Sender when the seller has no name.
  ///
  /// In fa, this message translates to:
  /// **'یک کاربر'**
  String get incomingTransferUnknownSender;

  /// Opens the incoming transfer sheet.
  ///
  /// In fa, this message translates to:
  /// **'بررسی'**
  String get incomingTransferReview;

  /// Title of the incoming transfer sheet.
  ///
  /// In fa, this message translates to:
  /// **'انتقال مالکیت به شما'**
  String get incomingTransferSheetTitle;

  /// Sheet: the seller.
  ///
  /// In fa, this message translates to:
  /// **'فرستنده: {sender}'**
  String incomingTransferFrom(String sender);

  /// Sheet: the vehicle mileage.
  ///
  /// In fa, this message translates to:
  /// **'کارکرد: {km} کیلومتر'**
  String incomingTransferMileage(String km);

  /// Sheet: what accepting does.
  ///
  /// In fa, this message translates to:
  /// **'با پذیرش، خودرو و سوابق آن به گاراژ شما منتقل می‌شود. سوابق مالک قبلی قابل ویرایش نیستند.'**
  String get incomingTransferNote;

  /// Sheet: accept.
  ///
  /// In fa, this message translates to:
  /// **'پذیرش'**
  String get incomingTransferAccept;

  /// Sheet: reject.
  ///
  /// In fa, this message translates to:
  /// **'رد درخواست'**
  String get incomingTransferReject;

  /// Snackbar after accepting.
  ///
  /// In fa, this message translates to:
  /// **'خودرو به گاراژ شما اضافه شد'**
  String get incomingTransferAccepted;

  /// Snackbar after rejecting.
  ///
  /// In fa, this message translates to:
  /// **'درخواست انتقال رد شد'**
  String get incomingTransferRejected;

  /// Snackbar of a failed accept or reject.
  ///
  /// In fa, this message translates to:
  /// **'انجام درخواست ممکن نشد'**
  String get incomingTransferFailed;

  /// Chip on a record from before the ownership transfer.
  ///
  /// In fa, this message translates to:
  /// **'مالک قبلی'**
  String get recordLockedLabel;

  /// Note on a locked record.
  ///
  /// In fa, this message translates to:
  /// **'این رکورد مربوط به مالک قبلی است و قابل ویرایش نیست'**
  String get recordLockedHint;
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
