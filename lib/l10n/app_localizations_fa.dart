// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'دستیار خودرو';

  @override
  String get splashTagline => 'دفترچه اختصاصی';

  @override
  String get splashHeadline => 'مدیریت خودرو';

  @override
  String get splashDescription => 'دفتر کل هزینه‌ها، سرویس‌ها و مدارک اختصاصی خودرو';

  @override
  String get splashLoading => 'در حال دریافت اطلاعات...';

  @override
  String get splashFooter => 'اطلاعات خودرو، همیشه در دسترس شما';

  @override
  String get splashLogoLabel => 'نشان‌واره اپلیکیشن مدیریت خودرو';

  @override
  String get versionLabel => 'نسخه';

  @override
  String get vehiclesLoadError => 'دریافت خودروها ممکن نشد';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String get back => 'بازگشت';

  @override
  String get logout => 'خروج از حساب';

  @override
  String get authBrandTitle => 'مدیریت خودرو';

  @override
  String get authBrandSubtitle => 'دفتر کل اختصاصی هزینه‌های اتومبیل';

  @override
  String get authLogoLabel => 'نشان‌واره مدیریت خودرو';

  @override
  String get authPhoneTitle => 'ورود یا ایجاد حساب کاربری';

  @override
  String get authPhoneSubtitle =>
      'جهت ثبت امن دفترچه خودرو و نگهداری سوابق سرویس‌ها، شماره موبایل خود را وارد کنید.';

  @override
  String get authPhoneLabel => 'شماره تلفن همراه';

  @override
  String get authPhoneHint => '912 345 6789';

  @override
  String get authCountryCode => '+98';

  @override
  String get authSmsCodeHint => 'ارسال کد تایید پیامکی';

  @override
  String authPhoneDigitsProgress(int count, int total) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$countString از $totalString رقم';
  }

  @override
  String authPhoneDigitsComplete(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString رقم کامل شد';
  }

  @override
  String get authPhoneInvalid => 'شماره موبایل معتبر نیست';

  @override
  String get authFeaturesTitle => 'مزایای ثبت و مدیریت در سامانه';

  @override
  String get authFeatureRemindersTitle => 'یادآور هوشمند سرویس‌ها';

  @override
  String get authFeatureRemindersTag => 'کیلومتر و تاریخ';

  @override
  String get authFeatureRemindersBody =>
      'هشدار تعویض روغن، تسمه‌تایم، لنت و بیمه‌نامه بر اساس کارکرد واقعی خودرو یا تاریخ سررسید.';

  @override
  String get authFeatureInvoicesTitle => 'ثبت دقیق فاکتورها و هزینه‌ها';

  @override
  String get authFeatureInvoicesTag => 'بایگانی فاکتور';

  @override
  String get authFeatureInvoicesBody =>
      'بایگانی قطعات مصرفی، دستمزد تعمیرکار، فاکتورهای بنزین، عوارض و خلافی‌ها با محاسبه تومان.';

  @override
  String get authFeatureTransferTitle => 'انتقال آنلاین سوابق خودرو';

  @override
  String get authFeatureTransferTag => 'هنگام فروش';

  @override
  String get authFeatureTransferBody =>
      'انتقال معتبر و یکپارچه کل شناسنامه سرویس‌ها و هزینه‌ها به مالک یا خریدار جدید در زمان معامله.';

  @override
  String get authSendCode => 'دریافت کد تایید';

  @override
  String get authTermsPrefix => 'با ورود یا ثبت‌نام در سامانه،';

  @override
  String get authTermsLink => 'قوانین و مقررات';

  @override
  String get authTermsAnd => 'و';

  @override
  String get authPrivacyLink => 'حریم خصوصی';

  @override
  String get authTermsSuffix => 'را می‌پذیرید.';

  @override
  String get authOtpTitle => 'کد تأیید را وارد کنید';

  @override
  String authOtpSubtitle(int length) {
    final intl.NumberFormat lengthNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String lengthString = lengthNumberFormat.format(length);

    return 'کد تأیید $lengthString رقمی به شماره زیر پیامک شد:';
  }

  @override
  String get authEditPhone => 'ویرایش شماره';

  @override
  String authOtpFieldLabel(int length) {
    final intl.NumberFormat lengthNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String lengthString = lengthNumberFormat.format(length);

    return 'کد $lengthString رقمی ارسالی';
  }

  @override
  String get authOtpAutoDetect => 'کد به صورت خودکار شناسایی می‌شود';

  @override
  String authOtpProgress(int count, int length) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);
    final intl.NumberFormat lengthNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String lengthString = lengthNumberFormat.format(length);

    return '$countString از $lengthString رقم درج شد';
  }

  @override
  String get authResendIn => 'ارسال مجدد تا';

  @override
  String get authResendHint =>
      'پیامک را دریافت نکردید؟ پس از اتمام زمان می‌توانید درخواست ارسال مجدد دهید.';

  @override
  String get authResend => 'ارسال مجدد کد پیامکی';

  @override
  String get authVerify => 'تأیید و ادامه';

  @override
  String get authCodeResent => 'کد جدید پیامک شد';

  @override
  String get authInvalidCode => 'کد نادرست است یا منقضی شده';

  @override
  String get authSmsFailed => 'ارسال پیامک ممکن نشد، دوباره تلاش کنید';

  @override
  String get authTooManyRequests => 'کمی صبر کنید و دوباره تلاش کنید';

  @override
  String authTooManyRequestsRetryIn(String time) {
    return 'تعداد درخواست‌ها زیاد است، $time دیگر دوباره تلاش کنید';
  }

  @override
  String get authGenericError => 'مشکلی پیش آمد، دوباره تلاش کنید';

  @override
  String get profileHeaderTitle => 'تکمیل اطلاعات کاربری';

  @override
  String get profileTitle => 'تکمیل اطلاعات حساب';

  @override
  String get profileDescription =>
      'برای صدور فاکتورها، یادآور تمدید گواهینامه و انتقال رسمی سوابق خودرو، مشخصات فردی خود را وارد نمایید.';

  @override
  String get profileFirstNameLabel => 'نام';

  @override
  String get profileFirstNameHint => 'مثال: علی';

  @override
  String get profileLastNameLabel => 'نام خانوادگی';

  @override
  String get profileLastNameHint => 'مثال: محمدی';

  @override
  String get profileRequiredLabel => 'الزامی';

  @override
  String get profileBirthDateLabel => 'تاریخ تولد';

  @override
  String get profileBirthDatePlaceholder => 'انتخاب تاریخ';

  @override
  String get profileBirthDateChange => 'تغییر تاریخ';

  @override
  String get profileBirthDateHint =>
      'انتخاب تاریخ تولد به صورت سال‌محور در تقویم جلالی انجام می‌شود.';

  @override
  String get profilePhoneLabel => 'شماره تماس مالک';

  @override
  String get profilePhoneVerified => 'تأیید شده';

  @override
  String get profilePrivacyTitle => 'امنیت و حریم شخصی سوابق';

  @override
  String get profilePrivacyBody =>
      'اطلاعات هویتی صرفاً برای بایگانی رسمی فاکتورها، معاینه فنی و انتقال دفترچه سوابق هنگام فروش خودرو نگهداری می‌شود.';

  @override
  String get profileSave => 'تأیید و ذخیره اطلاعات';

  @override
  String get profileFirstNameError => 'نام را وارد کنید (حداکثر ۵۰ حرف)';

  @override
  String get profileLastNameError => 'نام خانوادگی را وارد کنید (حداکثر ۵۰ حرف)';

  @override
  String get profileBirthDateError => 'تاریخ تولد معتبر انتخاب کنید';

  @override
  String get profileSaveInvalid => 'اطلاعات واردشده معتبر نیست، دوباره بررسی کنید';

  @override
  String get profilePickerTitle => 'انتخاب تاریخ تولد (تقویم جلالی)';

  @override
  String get profilePickerDay => 'روز';

  @override
  String get profilePickerMonth => 'ماه';

  @override
  String get profilePickerYear => 'سال';

  @override
  String get profilePickerHint => 'گردونه را جهت تنظیم روز، ماه و سال حرکت دهید';

  @override
  String get profilePickerConfirm => 'تأیید تاریخ تولد';

  @override
  String get profilePickerCancel => 'انصراف';

  @override
  String get profilePickerClose => 'بستن';

  @override
  String profileBirthDateValue(String day, String month, String year) {
    return '$day $month $year';
  }

  @override
  String jalaliMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'فروردین',
      '2': 'اردیبهشت',
      '3': 'خرداد',
      '4': 'تیر',
      '5': 'مرداد',
      '6': 'شهریور',
      '7': 'مهر',
      '8': 'آبان',
      '9': 'آذر',
      '10': 'دی',
      '11': 'بهمن',
      '12': 'اسفند',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get profileAvatarOptional => 'بارگذاری تصویر پرسنلی اختیاری است';

  @override
  String get profileAvatarEdit => 'ویرایش تصویر پروفایل';

  @override
  String get profileAvatarGallery => 'انتخاب از گالری';

  @override
  String get profileAvatarCamera => 'گرفتن عکس';

  @override
  String get profileAvatarRemove => 'حذف تصویر';

  @override
  String get profileAvatarUploading => 'در حال بارگذاری تصویر...';

  @override
  String get profileAvatarInvalid => 'فقط تصویر JPG، PNG یا WebP قابل بارگذاری است';

  @override
  String get profileAvatarTooLarge => 'حجم تصویر باید کمتر از ۲ مگابایت باشد';

  @override
  String get profileAvatarPickFailed => 'دسترسی به تصویر ممکن نشد';

  @override
  String get navHome => 'خانه';

  @override
  String get navGarage => 'گاراژ من';

  @override
  String get navHistory => 'تاریخچه';

  @override
  String get navProfile => 'پروفایل';

  @override
  String get quickAdd => 'ثبت سریع';

  @override
  String get notifications => 'اعلانات';

  @override
  String get accountLabel => 'حساب کاربری';

  @override
  String garageVehicleCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString خودرو';
  }

  @override
  String get emptyGarageTitle => 'یک خودرو اضافه کنید';

  @override
  String get emptyGarageBody =>
      'برای شروع ثبت سرویس‌ها، فاکتورها و یادآورهای دوره‌ای، اولین خودروی خود را به گاراژ اضافه کنید.';

  @override
  String get addVehicle => 'افزودن خودرو';

  @override
  String get garageBenefitsTitle => 'امکانات اختصاصی پرونده خودرو';

  @override
  String garageBenefitsSteps(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString گام اولیه';
  }

  @override
  String get benefitPlateTitle => 'پلاک استاندارد ملی';

  @override
  String get benefitPlateBody => 'ثبت پلاک ایران با فرمت رسمی و استان محل شماره‌گذاری';

  @override
  String get benefitServiceTitle => 'دفترچه سرویس هوشمند';

  @override
  String get benefitServiceBody => 'محاسبه دقیق موعد تعویض روغن، فیلترها و قطعات مصرفی';

  @override
  String get benefitRecordsTitle => 'انتقال سوابق و فاکتورها';

  @override
  String get benefitRecordsBody => 'حفظ شناسنامه مالی کامل هنگام نقل و انتقال یا فروش خودرو';

  @override
  String get comingSoon => 'به‌زودی';

  @override
  String get vehicleFormIntroTitle => 'مشخصات هویتی خودرو';

  @override
  String get vehicleFormIntroBody => 'اطلاعات پرونده فنی خودرو در گاراژ شما';

  @override
  String get vehicleOptional => '(اختیاری)';

  @override
  String get vehicleRequiredLabel => 'الزامی';

  @override
  String get vehiclePhotoLabel => 'تصویر خودرو';

  @override
  String get vehiclePhotoTitle => 'بارگذاری یا عکاسی از خودرو';

  @override
  String vehiclePhotoLimits(int mb) {
    final intl.NumberFormat mbNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String mbString = mbNumberFormat.format(mb);

    return 'حداکثر حجم $mbString مگابایت • فرمت JPG یا PNG';
  }

  @override
  String get vehiclePhotoGalleryChip => 'انتخاب فایل از گالری';

  @override
  String get vehiclePhotoCamera => 'عکاسی با دوربین';

  @override
  String get vehiclePhotoChange => 'تغییر تصویر';

  @override
  String get vehiclePhotoRemove => 'حذف تصویر';

  @override
  String get vehiclePhotoPickFailed => 'باز کردن گالری یا دوربین ممکن نشد';

  @override
  String vehiclePhotoTooLarge(int mb) {
    final intl.NumberFormat mbNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String mbString = mbNumberFormat.format(mb);

    return 'حجم تصویر بیشتر از $mbString مگابایت است';
  }

  @override
  String get vehiclePhotoInvalid => 'فقط تصویر JPG یا PNG پذیرفته می‌شود';

  @override
  String get vehicleNicknameLabel => 'نام مستعار یا عنوان دلخواه';

  @override
  String get vehicleNicknameBadge => 'نمایش در داشبورد';

  @override
  String get vehicleNicknameHint => 'مثلاً: ۲۰۶ خاکستری من، شاهین کاری';

  @override
  String get vehicleNicknameHelp => 'یک نام مشخص برای تفکیک آسان میان خودروهای ثبت‌شده در گاراژ';

  @override
  String vehicleNicknameError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'نام خودرو را وارد کنید (حداکثر $maxString نویسه)';
  }

  @override
  String get vehiclePlateLabel => 'پلاک ملی خودرو';

  @override
  String get vehiclePlateBadge => 'استاندارد راهور';

  @override
  String get vehiclePlateHelp => 'ترتیب درج: دو رقم، حرف الفبا، سه رقم و کد استان دو رقمی معتبر';

  @override
  String get vehiclePlateTwoDigits => 'دو رقم پلاک';

  @override
  String get vehiclePlateLetter => 'حرف الفبای پلاک';

  @override
  String get vehiclePlateThreeDigits => 'سه رقم پلاک';

  @override
  String get vehiclePlateProvince => 'کد استان پلاک';

  @override
  String get vehiclePlateIran => 'ایران';

  @override
  String get vehiclePlateBandTop => 'I.R.';

  @override
  String get vehiclePlateBandBottom => 'IRAN';

  @override
  String get vehiclePlateError => 'پلاک را کامل و درست وارد کنید';

  @override
  String get vehiclePlateTaken => 'این پلاک قبلاً در گاراژ شما ثبت شده است';

  @override
  String get vehicleVinLabel => 'کد شناسایی خودرو (VIN)';

  @override
  String vehicleVinBadge(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString کاراکتر انگلیسی';
  }

  @override
  String get vehicleVinHint => 'NAAM21CA9KK123456';

  @override
  String get vehicleVinHelp => 'کد هفده‌رقمی مندرج در کارت مشخصات خودرو یا لبه شیشه جلو';

  @override
  String vehicleVinError(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'VIN باید $countString حرف انگلیسی یا رقم باشد (بدون I، O و Q)';
  }

  @override
  String get vehicleMakeSectionTitle => 'سازنده و مشخصات فنی';

  @override
  String get vehicleMakeSectionBadge => 'فهرست رسمی کارخانه';

  @override
  String get vehicleMakeLabel => 'برند / سازنده';

  @override
  String get vehicleModelLabel => 'مدل خودرو';

  @override
  String get vehicleTrimLabel => 'تیپ و گیربکس';

  @override
  String get vehicleMakeHint => 'انتخاب برند';

  @override
  String get vehicleModelHint => 'انتخاب مدل';

  @override
  String get vehicleTrimHint => 'انتخاب تیپ';

  @override
  String get vehicleMakeError => 'برند را انتخاب کنید';

  @override
  String get vehicleModelError => 'مدل را انتخاب کنید';

  @override
  String get vehicleTrimError => 'تیپ انتخاب‌شده معتبر نیست';

  @override
  String get vehicleCatalogError => 'دریافت فهرست خودروها ممکن نشد';

  @override
  String get vehicleYearLabel => 'سال ساخت (خورشیدی)';

  @override
  String get vehicleYearBadge => 'تقویم جلالی';

  @override
  String get vehicleYearHint => 'انتخاب سال';

  @override
  String get vehicleYearPickerTitle => 'انتخاب سال ساخت (خورشیدی)';

  @override
  String vehicleYearZeroKm(String year) {
    return '$year (صفر کیلومتر)';
  }

  @override
  String get vehicleYearConfirm => 'تأیید سال';

  @override
  String get vehicleYearClose => 'بستن';

  @override
  String get vehicleYearError => 'سال ساخت را انتخاب کنید';

  @override
  String get vehicleMileageLabel => 'کارکرد فعلی کیلومترشمار';

  @override
  String get vehicleMileageBadge => 'بسیار مهم';

  @override
  String get vehicleMileageUnit => 'کیلومتر';

  @override
  String get vehicleMileageHelp =>
      'مبنای دقیق کلیه هشدارهای دوره‌ای سرویس، روغن موتور، بیمه و محاسبات استهلاک گاراژ';

  @override
  String vehicleMileageError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'کارکرد را بین ۰ تا $maxString کیلومتر وارد کنید';
  }

  @override
  String get vehicleColorLabel => 'رنگ بدنه';

  @override
  String get vehicleColorWhite => 'سفید روغنی';

  @override
  String get vehicleColorBlack => 'مشکی آبنوس';

  @override
  String get vehicleColorSilver => 'نقره‌ای متالیک';

  @override
  String get vehicleColorBlue => 'آبی رویال / کاربنی';

  @override
  String get vehicleColorRed => 'قرمز رژ روناس';

  @override
  String get vehicleColorBeige => 'بژ تیتانیوم';

  @override
  String get vehicleColorError => 'رنگ انتخاب‌شده معتبر نیست';

  @override
  String get vehicleDefaultTitle => 'تنظیم به عنوان خودروی پیش‌فرض';

  @override
  String get vehicleDefaultBody =>
      'ثبت سریع سوخت، سرویس‌ها و داده‌های داشبورد به صورت خودکار برای این خودرو در اولویت قرار می‌گیرد.';

  @override
  String get vehicleSave => 'ثبت و افزودن به گاراژ';

  @override
  String get vehicleSaving => 'در حال ذخیره‌سازی...';

  @override
  String get vehicleCancel => 'انصراف';

  @override
  String get vehicleAdded => 'خودرو اضافه شد';

  @override
  String get vehicleAddedPhotoFailed => 'خودرو اضافه شد، اما بارگذاری تصویر ناموفق بود';

  @override
  String get vehicleSaveInvalid => 'برخی اطلاعات معتبر نیست؛ موارد مشخص‌شده را بررسی کنید';

  @override
  String get vehicleSaveFailed => 'ذخیره خودرو ممکن نشد. دوباره تلاش کنید';

  @override
  String vehiclePlateText(
    String twoDigits,
    String letter,
    String threeDigits,
    String provinceCode,
  ) {
    return '$twoDigits $letter $threeDigits ایران $provinceCode';
  }

  @override
  String vehicleTileSubtitle(String make, String model, String plate) {
    return '$make $model • $plate';
  }

  @override
  String get vehiclePlateLetterHint => 'حرف';
}
