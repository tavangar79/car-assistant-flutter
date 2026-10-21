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
  String get historyAllVehicles => 'همه خودروها';

  @override
  String historyVehicleCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString خودرو';
  }

  @override
  String get historyChooseVehicle => 'انتخاب خودرو';

  @override
  String get historyFilterTooltip => 'فیلتر سوابق';

  @override
  String historyVehicleMeta(String year, int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'مدل $year • کارکرد فعلی $kmString کیلومتر';
  }

  @override
  String get historyGarageTitle => 'همه خودروهای گاراژ';

  @override
  String historySelectedTitle(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString خودروی انتخاب‌شده';
  }

  @override
  String historyGarageMeta(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString خودروی ثبت‌شده';
  }

  @override
  String historySummaryYear(String year) {
    return 'مجموع هزینه‌های سال $year';
  }

  @override
  String get historySummarySixMonths => 'مجموع هزینه‌های ۶ ماه اخیر';

  @override
  String get historySummaryAll => 'مجموع هزینه‌ها';

  @override
  String get historySummaryCustom => 'مجموع هزینه‌های بازه انتخابی';

  @override
  String historySummaryCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString مورد ثبت شده';
  }

  @override
  String get historyToman => 'تومان';

  @override
  String get historyServicesLabel => 'خدمات و بازدید';

  @override
  String historyServicesValue(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString سرویس ثبت‌شده';
  }

  @override
  String get historyFuelLabel => 'مجموع مصرف سوخت';

  @override
  String historyFuelValue(String volume) {
    return '$volume لیتر';
  }

  @override
  String get historyTabAll => 'همه موارد';

  @override
  String get historyTabService => 'سرویس و تعمیر';

  @override
  String get historyTabFuel => 'سوخت‌گیری';

  @override
  String get historyTabExpense => 'هزینه‌های جاری';

  @override
  String get historyInvoiceChip => 'فاکتوردار';

  @override
  String get historyExport => 'خروجی اکسل/PDF';

  @override
  String historyPeriodCurrentYear(String year) {
    return 'سال جاری ($year)';
  }

  @override
  String get historyPeriodSixMonths => '۶ ماه اخیر';

  @override
  String get historyPeriodAll => 'همه زمان‌ها';

  @override
  String get historyPeriodCustom => 'انتخاب دستی';

  @override
  String historyMonthCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString مورد';
  }

  @override
  String historyRowKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString کیلومتر';
  }

  @override
  String historyRowVolume(String volume, String unit) {
    return '$volume $unit';
  }

  @override
  String historyFullFill(String fuel) {
    return '$fuel (باک پر)';
  }

  @override
  String historyEconomy(String value) {
    return '$value لیتر / ۱۰۰ ک‌م';
  }

  @override
  String get historyInvoiceBadge => 'فاکتور';

  @override
  String get historyAttachmentBadge => 'پیوست';

  @override
  String historyExpiresAt(String date) {
    return 'پایان اعتبار: $date';
  }

  @override
  String historyStart(String date) {
    return 'شروع تاریخچه از تاریخ ثبت خودرو ($date)';
  }

  @override
  String get historyEmpty => 'سابقه‌ای با این فیلترها پیدا نشد';

  @override
  String get historyLoadError => 'دریافت تاریخچه ممکن نشد';

  @override
  String get historyLoadMoreError => 'دریافت ادامه تاریخچه ممکن نشد';

  @override
  String get historyFilterTitle => 'فیلتر سوابق';

  @override
  String historyFilterActive(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString فیلتر فعال';
  }

  @override
  String get historyFilterClear => 'پاک کردن';

  @override
  String get historyFilterClose => 'بستن';

  @override
  String get historyFilterVehicles => 'خودرو';

  @override
  String get historyFilterVehiclesHint => '(محدوده جستجو)';

  @override
  String historyFilterSelectedVehicles(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'انتخاب شده: $countString خودرو';
  }

  @override
  String historyFilterMileage(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'آخرین پیمایش: $kmString کیلومتر';
  }

  @override
  String get historyFilterAllVehicles => 'همه خودروهای گاراژ';

  @override
  String historyFilterAllVehiclesHint(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'نمایش جامع تمام $countString خودروی ثبت‌شده';
  }

  @override
  String get historyFilterCategories => 'دسته‌بندی خدمات و هزینه‌ها';

  @override
  String get historyFilterSelectAll => 'انتخاب همه';

  @override
  String get historyCategoryLegal => 'هزینه‌های قانونی';

  @override
  String get historyCategoryLegalHint => 'بیمه، معاینه، عوارض';

  @override
  String get historyFilterDocuments => 'اسناد و مدارک مالی';

  @override
  String get historyFilterAttachmentsOnly => 'فقط سوابق دارای پیوست / فاکتور';

  @override
  String get historyFilterAttachmentsHint => 'تصویر فاکتور رسمی، رسید پرداخت، ضمانت‌نامه';

  @override
  String get historyFilterPeriod => 'بازه زمانی ثبت';

  @override
  String get historyFilterCalendar => 'تقویم جلالی';

  @override
  String historyFilterRange(String from, String to) {
    return '$from تا $to';
  }

  @override
  String get historyFilterFrom => 'از تاریخ';

  @override
  String get historyFilterTo => 'تا تاریخ';

  @override
  String get historyFilterPickDate => 'تأیید تاریخ';

  @override
  String get historyFilterResults => 'تعداد نتایج منطبق با فیلترها:';

  @override
  String historyFilterResultsValue(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString رکورد';
  }

  @override
  String get historyFilterApply => 'اعمال فیلتر';

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
  String get vehicleDefaultLocked => 'برای تغییر خودروی پیش‌فرض، خودروی دیگری را پیش‌فرض کنید.';

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
  String get vehiclePlateLetterHint => 'حرف';

  @override
  String get editVehicle => 'ویرایش خودرو';

  @override
  String get vehicleOptions => 'تنظیمات خودرو';

  @override
  String get vehicleSaveChanges => 'ذخیره تغییرات';

  @override
  String get vehicleUpdated => 'تغییرات خودرو ذخیره شد';

  @override
  String get vehicleUpdatedPhotoFailed => 'تغییرات ذخیره شد، اما تصویر به‌روز نشد';

  @override
  String get odometerTitle => 'بروزرسانی کیلومترشمار';

  @override
  String get odometerSubtitle => 'تنظیم دقیق موعد سرویس‌ها و یادآورهای دوره‌ای';

  @override
  String get odometerClose => 'بستن';

  @override
  String get odometerPickVehicle => 'انتخاب خودرو';

  @override
  String get activeVehicleBadge => 'خودروی فعال';

  @override
  String get odometerCurrentLabel => 'کیلومترشمار فعلی';

  @override
  String odometerLastRecorded(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'آخرین ثبت: $kmString کیلومتر';
  }

  @override
  String odometerDiff(String diff) {
    return '$diff کیلومتر';
  }

  @override
  String get odometerSinceLastUpdate => 'پیمایش از آخرین به‌روزرسانی';

  @override
  String odometerSinceLastUpdateOn(String date) {
    return 'پیمایش از آخرین به‌روزرسانی ($date)';
  }

  @override
  String get odometerReset => 'بازنشانی';

  @override
  String get odometerQuickAdjust => 'تنظیم سریع مقادیر رایج';

  @override
  String get odometerRecordedAtLabel => 'تاریخ و زمان ثبت';

  @override
  String odometerRecordedAtToday(String date, String time) {
    return 'امروز، $date — $time';
  }

  @override
  String odometerRecordedAtValue(String date, String time) {
    return '$date — $time';
  }

  @override
  String get odometerChangeDate => 'تغییر تاریخ';

  @override
  String get odometerSubmit => 'تأیید و ثبت کارکرد';

  @override
  String get odometerCancel => 'انصراف';

  @override
  String odometerBelowCurrent(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'کارکرد نمی‌تواند کمتر از آخرین ثبت ($kmString کیلومتر) باشد';
  }

  @override
  String get odometerSaved => 'کارکرد با موفقیت ثبت شد';

  @override
  String get odometerSaveFailed => 'ثبت کارکرد ممکن نشد، دوباره تلاش کنید';

  @override
  String get vehicleDetailsTitle => 'جزئیات خودرو';

  @override
  String get vehicleDetailsLoadError => 'دریافت اطلاعات خودرو ممکن نشد';

  @override
  String get vehicleDetailsActive => 'فعال در گاراژ';

  @override
  String vehicleDetailsModelYear(String year) {
    return 'مدل $year';
  }

  @override
  String vehicleDetailsVin(String vin) {
    return 'شاسی: $vin';
  }

  @override
  String get vehicleDetailsMileageTitle => 'کارکرد فعلی خودرو';

  @override
  String get vehicleDetailsMileageBadge => 'مبنای یادآوری‌ها';

  @override
  String get vehicleDetailsUpdateMileage => 'بروزرسانی کیلومتر';

  @override
  String get vehicleDetailsDueTitle => 'وضعیت و سرویس‌های پیش‌رو';

  @override
  String get vehicleDetailsDueEmpty => 'هنوز موردی برای پیگیری ثبت نشده است';

  @override
  String get vehicleDetailsHistoryTitle => 'تاریخچه آخرین خدمات و سرویس‌ها';

  @override
  String get vehicleDetailsHistoryEmpty => 'هنوز سرویسی برای این خودرو ثبت نشده است';

  @override
  String get vehicleDetailsExport => 'دریافت کارنامه و گزارش فاکتورها (PDF)';

  @override
  String get quickActionsTitle => 'اقدامات سریع';

  @override
  String get quickActionsClose => 'بستن';

  @override
  String get quickActionsScope => 'عملیات برای این خودرو ثبت می‌شود';

  @override
  String get quickActionOdometerBody => 'تنظیم موعد دقیق یادآور سرویس‌ها بر اساس کارکرد';

  @override
  String get quickActionServiceTitle => 'ثبت سرویس و تعمیرات';

  @override
  String get quickActionServiceBody => 'تعویض روغن، لنت، فیلترها و فاکتور تعمیرگاه';

  @override
  String get quickActionFuelTitle => 'ثبت سوخت‌گیری';

  @override
  String get quickActionFuelBody => 'بنزین معمولی، سوپر یا گاز و محاسبه مصرف صدی';

  @override
  String get quickActionExpenseTitle => 'ثبت هزینه متفرقه';

  @override
  String get quickActionExpenseBody => 'بیمه شخص ثالث، عوارض، جریمه و معاینه فنی';

  @override
  String get quickActionAddVehicleTitle => 'افزودن خودروی جدید';

  @override
  String get quickActionAddVehicleBody => 'ثبت پلاک و باز کردن دفترچه هزینه ماشین جدید';

  @override
  String get quickActionGarageTag => 'گاراژ';

  @override
  String get quickActionUnavailable => 'به‌زودی';

  @override
  String get odometerPickDateTitle => 'تاریخ ثبت کارکرد (تقویم جلالی)';

  @override
  String get odometerPickDateConfirm => 'تأیید تاریخ';

  @override
  String get homeAppName => 'مدیریت خودرو';

  @override
  String get homeFleetManage => 'مدیریت';

  @override
  String get homeCostThisYear => 'هزینه کل امسال';

  @override
  String get currencyToman => 'تومان';

  @override
  String get homeCostFooter => 'فیلتر در تاریخچه ›';

  @override
  String get homeInvoicesTitle => 'فاکتورها';

  @override
  String get homeInvoicesUnit => 'ثبت‌شده';

  @override
  String get homeInvoicesFooter => 'مشاهده اسناد ›';

  @override
  String get homeAttentionTitle => 'نیازمند رسیدگی';

  @override
  String get homeAttentionUnit => 'مورد فوری';

  @override
  String get homeAttentionFooter => 'بررسی موارد ›';

  @override
  String get valueUnavailable => '—';

  @override
  String get notComputable => 'قابل محاسبه نیست';

  @override
  String homeSpendTitle(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'هزینه $countString ماه اخیر';
  }

  @override
  String homeSpendRange(String from, String to, String year) {
    return '$from — $to $year';
  }

  @override
  String homeSpendRangeAcrossYears(String from, String fromYear, String to, String toYear) {
    return '$from $fromYear — $to $toYear';
  }

  @override
  String get homeSpendEmpty => 'هنوز هزینه‌ای ثبت نشده است';

  @override
  String get homeUpdateOdometerHint => 'انتخاب خودرو و ثبت سریع کیلومترشمار فعلی';

  @override
  String homeSpendMonthTotal(String month, String year) {
    return '$month $year (مجموع)';
  }

  @override
  String homeSpendAmount(String amount) {
    return '$amount تومان';
  }

  @override
  String get dashboardLoadError => 'دریافت خلاصه هزینه‌ها ممکن نشد';

  @override
  String profileMemberSince(String month, String year) {
    return 'عضو رسمی از $month $year';
  }

  @override
  String get profileEdit => 'ویرایش پروفایل';

  @override
  String get profileStatVehicles => 'خودرو فعال';

  @override
  String get profileStatServices => 'سرویس ثبت‌شده';

  @override
  String get profileStatsLoadError => 'دریافت آمار ممکن نشد';

  @override
  String get profileSettingsSection => 'تنظیمات و سامانه';

  @override
  String get profileReminders => 'تنظیمات یادآورها';

  @override
  String get profileRemindersHint => 'زمان‌بندی پیام‌های موعد تعویض و بیمه';

  @override
  String get profileSms => 'اطلاع‌رسانی پیامک';

  @override
  String get profileSmsHint => 'مدیریت ارسال پیامک سرویس و سوخت';

  @override
  String get profileSecurity => 'امنیت و رمز عبور';

  @override
  String get profileSecurityHint => 'ورود دوعاملی و احراز هویت بیومتریک';

  @override
  String get profileLegalSection => 'ارتباطات و حقوقی';

  @override
  String get profileSupport => 'پشتیبانی و تماس با ما';

  @override
  String get profileSupportHint => 'پاسخگویی آنلاین و ثبت تیکت پشتیبانی';

  @override
  String get profilePrivacy => 'قوانین و حریم خصوصی';

  @override
  String get profilePrivacyHint => 'شرایط استفاده و حفاظت از داده‌ها';

  @override
  String get profileLogout => 'خروج از حساب کاربری';

  @override
  String profileAppVersion(String version) {
    return 'نسخه اپلیکیشن $version';
  }

  @override
  String get garageHistoryTooltip => 'تاریخچه رویدادها';

  @override
  String get garageMyVehicles => 'خودروهای من';

  @override
  String garageActiveCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString خودرو فعال';
  }

  @override
  String get garageDefaultBadge => 'خودروی پیش‌فرض';

  @override
  String get garageSetDefault => 'انتخاب به عنوان پیش‌فرض';

  @override
  String get garageSetDefaultError => 'تغییر خودروی پیش‌فرض ممکن نشد';

  @override
  String get garageOdometerLabel => 'کیلومترشمار فعلی';

  @override
  String garageLastReading(String when) {
    return 'آخرین ثبت: $when';
  }

  @override
  String relativeDaysAgo(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$daysString روز پیش',
      one: 'دیروز',
      zero: 'امروز',
    );
    return '$_temp0';
  }

  @override
  String get garageServiceStatusTitle => 'وضعیت سرویس‌ها';

  @override
  String get garageActionService => 'ثبت سرویس';

  @override
  String get garageActionOdometer => 'ثبت کیلومتر';

  @override
  String get garageActionRecords => 'دفترچه سوابق';

  @override
  String get garageToolsTitle => 'مدیریت و امکانات گاراژ';

  @override
  String get garageToolsSubtitle => 'خدمات اسناد و انتقال';

  @override
  String get garageToolTransferTitle => 'انتقال مالکیت خودرو';

  @override
  String get garageToolTransferBody => 'انتقال ایمن سوابق فنی به خریدار جدید بدون حذف داده‌ها';

  @override
  String get garageToolDocumentsTitle => 'کیف مدارک و بیمه‌نامه‌ها';

  @override
  String get garageToolDocumentsBody => 'کارت خودرو، برگ سبز، بیمه‌نامه ثالث و معاینه فنی';

  @override
  String get garageToolExportTitle => 'خروجی پرونده و گزارش رسمی';

  @override
  String get garageToolExportBody => 'شناسنامه سوابق تعمیرگاهی و هزینه‌ها جهت فروش و کارشناسی';

  @override
  String get serviceWizardTitle => 'ثبت سرویس جدید';

  @override
  String get serviceStep1Label => 'انتخاب اقلام';

  @override
  String get serviceStep2Label => 'زمان و کارکرد';

  @override
  String get serviceStep3Label => 'جزئیات و هزینه';

  @override
  String serviceStepNumber(int step) {
    final intl.NumberFormat stepNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String stepString = stepNumberFormat.format(step);

    return '$stepString';
  }

  @override
  String serviceSelectedCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString مورد انتخاب شد';
  }

  @override
  String get serviceClearAll => 'پاکسازی همه';

  @override
  String get serviceSearchHint => 'جستجوی سرویس (مثلاً: روغن، لنت، شمع...)';

  @override
  String get serviceSearchEmpty => 'سرویسی با این نام پیدا نشد';

  @override
  String get serviceCatalogLoadError => 'دریافت فهرست سرویس‌ها ممکن نشد';

  @override
  String get serviceFooterLabel => 'اقلام برگزیده برای ثبت:';

  @override
  String serviceFooterCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString سرویس انتخاب شده';
  }

  @override
  String get serviceContinueStep2 => 'ادامه به گام دوم (زمان و کارکرد)';

  @override
  String get serviceSelectedItemsLabel => 'اقلام انتخاب‌شده برای فاکتور:';

  @override
  String get serviceEditItems => 'ویرایش اقلام';

  @override
  String get serviceOdometerTitle => 'کارکرد ثبت فاکتور';

  @override
  String get serviceOdometerBadge => 'مبنای استهلاک';

  @override
  String get serviceOdometerLabel => 'کیلومترشمار در زمان انجام سرویس';

  @override
  String serviceOdometerLastOn(int km, String date, String when) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'آخرین ثبت: $kmString کیلومتر ($date — $when)';
  }

  @override
  String serviceOdometerDiff(String diff) {
    return '$diff کیلومتر پیمایش';
  }

  @override
  String get serviceQuickAdjust => 'تنظیم سریع بر اساس کارکرد:';

  @override
  String get serviceDateTitle => 'تاریخ ثبت فاکتور';

  @override
  String get serviceDateBadge => 'تقویم جلالی';

  @override
  String get serviceDateLabel => 'تاریخ انجام خدمات';

  @override
  String serviceDateValue(String weekday, String date) {
    return '$weekday، $date';
  }

  @override
  String jalaliWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '1': 'شنبه',
      '2': 'یکشنبه',
      '3': 'دوشنبه',
      '4': 'سه‌شنبه',
      '5': 'چهارشنبه',
      '6': 'پنج‌شنبه',
      '7': 'جمعه',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get serviceDateToday => 'امروز';

  @override
  String get serviceDateYesterday => 'دیروز';

  @override
  String get serviceDateLastWeek => 'هفته گذشته';

  @override
  String get serviceDatePick => 'انتخاب از تقویم';

  @override
  String get serviceDatePickTitle => 'تاریخ انجام خدمات (تقویم جلالی)';

  @override
  String get serviceStickerTitle => 'جزئیات برچسب سرویس (اختیاری)';

  @override
  String get serviceStickerBody =>
      'جهت انطباق دقیق، می‌توانید کارکرد پیشنهادی سرویس بعدی درج‌شده روی برچسب تعویض‌روغنی را ثبت کنید.';

  @override
  String get serviceStickerKmLabel => 'پیشنهاد برچسب بعدی';

  @override
  String get serviceVisitTimeLabel => 'ساعت مراجعه';

  @override
  String get serviceVisitTimePickHelp => 'ساعت مراجعه';

  @override
  String get serviceSyncTitle => 'همگام‌سازی فاکتور و قطعات';

  @override
  String serviceSyncBody(String items) {
    return 'این کارکرد و تاریخ به صورت مشترک به عنوان مبنای محاسبه تمام اقلام این فاکتور ($items) ثبت و در تاریخچه خودرو درج خواهند شد.';
  }

  @override
  String get serviceContinueStep3 => 'ادامه به گام سوم (جزئیات و هزینه‌ها)';

  @override
  String get serviceBackToItems => 'بازگشت به انتخاب اقلام';

  @override
  String get serviceDateInFuture => 'تاریخ و ساعت سرویس نمی‌تواند در آینده باشد';

  @override
  String serviceKmValue(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString کیلومتر';
  }

  @override
  String serviceItemIndex(int index, int count) {
    final intl.NumberFormat indexNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String indexString = indexNumberFormat.format(index);
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'قلم $indexString از $countString';
  }

  @override
  String get serviceRemoveItem => 'حذف سرویس';

  @override
  String get serviceCostLabel => 'مبلغ قطعه و اجرت تعویض';

  @override
  String get serviceBrandLabel => 'برند و مشخصات فنی قطعه';

  @override
  String get serviceWorkshopLabel => 'تعمیرگاه / اتوسرویس';

  @override
  String get serviceNotesLabel => 'یادداشت فنی و جزئیات';

  @override
  String get serviceInvoiceLabel => 'تصویر فاکتور و رسید سرویس';

  @override
  String get serviceInvoiceAttach => 'افزودن تصویر فاکتور';

  @override
  String serviceInvoiceAttached(String size) {
    return '$size • الصاق شده';
  }

  @override
  String get serviceInvoiceChange => 'تغییر تصویر';

  @override
  String get serviceInvoiceRemove => 'حذف تصویر';

  @override
  String get serviceInvoiceGallery => 'انتخاب از گالری';

  @override
  String get serviceInvoiceCamera => 'عکس‌برداری با دوربین';

  @override
  String get serviceInvoicePickFailed => 'انتخاب تصویر ممکن نشد';

  @override
  String serviceInvoiceTooLarge(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'حجم تصویر فاکتور بیشتر از $maxString مگابایت است';
  }

  @override
  String get serviceInvoiceInvalid => 'تصویر فاکتور باید JPG، PNG یا WebP باشد';

  @override
  String megabytes(String size) {
    return '$size مگابایت';
  }

  @override
  String get serviceReminderTitle => 'یادآور موعد بعدی';

  @override
  String get serviceReminderHint => 'محاسبه بر اساس نخستین شرط';

  @override
  String get serviceReminderKmLabel => 'کارکرد مجاز بعدی';

  @override
  String get serviceReminderMonthsLabel => 'بازه زمانی مجاز';

  @override
  String get serviceReminderMonthsUnit => 'ماه بعد';

  @override
  String serviceReminderDueKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'سررسید: $kmString ک‌م';
  }

  @override
  String serviceReminderDueDate(String month, String year) {
    return 'سررسید: $month $year';
  }

  @override
  String get serviceReminderNone => 'بدون یادآور';

  @override
  String get serviceAddAnotherItem => 'افزودن یک قلم سرویس دیگر به این فاکتور';

  @override
  String serviceTotalLabel(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'جمع کل فاکتور ($countString قلم)';
  }

  @override
  String get serviceTotalHint => 'شامل اجرت و قطعات مصرفی';

  @override
  String get serviceSubmit => 'ثبت نهایی فاکتور و ذخیره سوابق';

  @override
  String get serviceSaving => 'در حال ثبت...';

  @override
  String serviceWorkshopError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'نام تعمیرگاه را وارد کنید (حداکثر $maxString حرف)';
  }

  @override
  String get serviceLineItemsError => 'مقادیر این قلم نامعتبر است، آن را بررسی کنید';

  @override
  String get serviceSaveInvalid => 'اطلاعات فاکتور نامعتبر است، فیلدها را بررسی کنید';

  @override
  String get serviceSaveFailed => 'ثبت سرویس ممکن نشد، دوباره تلاش کنید';

  @override
  String get serviceSaved => 'سرویس با موفقیت ثبت شد';

  @override
  String get serviceSavedInvoiceFailed => 'سرویس ثبت شد، اما بارگذاری تصویر فاکتور ناموفق بود';

  @override
  String get serviceDetailsEyebrow => 'ثبت مراجعات فنی';

  @override
  String get serviceDetailsTitle => 'جزئیات فاکتور سرویس';

  @override
  String get serviceDetailsOptions => 'گزینه‌های فاکتور';

  @override
  String get serviceDetailsDelete => 'حذف فاکتور';

  @override
  String get serviceDetailsDeleteConfirmTitle => 'حذف این فاکتور؟';

  @override
  String get serviceDetailsDeleteConfirmBody =>
      'تمام اقلام و تصویر فاکتور حذف می‌شود. این کار قابل بازگشت نیست.';

  @override
  String get confirmDelete => 'حذف';

  @override
  String get serviceDetailsDateLabel => 'تاریخ مراجعه';

  @override
  String get serviceDetailsOdometerLabel => 'کیلومترشمار';

  @override
  String get serviceDetailsWorkshopLabel => 'تعمیرگاه / مرکز خدمات';

  @override
  String get serviceDetailsNotesLabel => 'یادداشت';

  @override
  String get serviceDetailsHeaderNote =>
      'اطلاعات سربرگ فاکتور ثابت بوده و ردیف‌های ذیل قابل ویرایش هستند.';

  @override
  String serviceDetailsItemsTitle(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'اقلام انجام‌شده در این مراجعه ($countString مورد)';
  }

  @override
  String get serviceDetailsEditItem => 'ویرایش قلم';

  @override
  String get serviceDetailsDeleteItem => 'حذف قلم';

  @override
  String serviceDetailsReminder(String value) {
    return 'یادآور بعد: $value';
  }

  @override
  String serviceDetailsReminderBoth(int km, String month, String year) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString کیلومتر ($month $year)';
  }

  @override
  String serviceDetailsReminderDate(String month, String year) {
    return '$month $year';
  }

  @override
  String get serviceDetailsAddItem => 'افزودن قلم جدید به این فاکتور';

  @override
  String get serviceDetailsInvoiceTitle => 'تصویر فیزیکی فاکتور / رسید';

  @override
  String serviceDetailsInvoiceUploaded(String date) {
    return 'بارگذاری شده در $date';
  }

  @override
  String get serviceDetailsInvoiceView => 'مشاهده در ابعاد کامل';

  @override
  String get serviceDetailsInvoiceEmpty => 'تصویری از فاکتور الصاق نشده است';

  @override
  String get serviceDetailsInvoiceAttach => 'الصاق تصویر فاکتور';

  @override
  String get serviceDetailsInvoiceLoadError => 'دریافت تصویر فاکتور ممکن نشد';

  @override
  String get serviceDetailsInvoiceSaved => 'تصویر فاکتور الصاق شد';

  @override
  String get serviceDetailsInvoiceSaveFailed => 'بارگذاری تصویر فاکتور ممکن نشد';

  @override
  String get serviceDetailsTotalTitle => 'جمع کل اقلام مصرفی و اجرت:';

  @override
  String get serviceDetailsTotalLabel => 'مبلغ نهایی فاکتور:';

  @override
  String get serviceDetailsPdf => 'دریافت فایل PDF فاکتور';

  @override
  String get serviceDetailsLoadError => 'دریافت اطلاعات فاکتور ممکن نشد';

  @override
  String get serviceDetailsLastItem =>
      'آخرین قلم فاکتور را نمی‌توان حذف کرد؛ به‌جای آن کل فاکتور را حذف کنید';

  @override
  String serviceDetailsDeleteItemConfirmTitle(String item) {
    return 'حذف قلم «$item»؟';
  }

  @override
  String get serviceDetailsDeleteItemConfirmBody =>
      'این قلم از فاکتور حذف و جمع کل بازمحاسبه می‌شود.';

  @override
  String get serviceDetailsUpdated => 'فاکتور به‌روزرسانی شد';

  @override
  String get serviceDetailsUpdateFailed => 'به‌روزرسانی فاکتور ممکن نشد';

  @override
  String get serviceDetailsDeleted => 'فاکتور حذف شد';

  @override
  String get serviceDetailsDeleteFailed => 'حذف فاکتور ممکن نشد';

  @override
  String get serviceEditorTitleEdit => 'ویرایش قلم';

  @override
  String get serviceEditorTitleAdd => 'افزودن قلم';

  @override
  String get serviceEditorSave => 'ذخیره قلم';

  @override
  String get serviceEditorPickItem => 'انتخاب سرویس';

  @override
  String get serviceEditorNoItemsLeft => 'همه اقلام فهرست در این فاکتور ثبت شده‌اند';

  @override
  String get serviceHistoryLoadError => 'دریافت تاریخچه سرویس‌ها ممکن نشد';

  @override
  String serviceHistoryMore(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'و $countString مورد دیگر';
  }

  @override
  String serviceHistoryAmount(int amount) {
    final intl.NumberFormat amountNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString تومان';
  }

  @override
  String get intervalsTitle => 'تنظیم دوره سرویس';

  @override
  String intervalsCurrentMileage(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'کارکرد فعلی: $kmString کیلومتر';
  }

  @override
  String get intervalsSourceNote => 'تنظیمات براساس دفترچه راهنمای سازنده';

  @override
  String get intervalsResetAll => 'بازنشانی همه';

  @override
  String get intervalsResetAllConfirmTitle => 'بازنشانی همه دوره‌ها؟';

  @override
  String get intervalsResetAllConfirmBody =>
      'همه دوره‌ها به پیش‌فرض کارخانه برمی‌گردند و مقادیر سفارشی حذف می‌شوند.';

  @override
  String get intervalsResetConfirm => 'بازنشانی';

  @override
  String get intervalsRuleTitle => 'قانون سررسید اولویت زمانی یا کارکرد';

  @override
  String get intervalsRuleBody =>
      'شمارش معکوس و هشدارهای تعویض قطعات بر اساس هرکدام از شاخص‌ها (پیمایش کیلومتر یا سپری شدن ماه‌ها) که زودتر فرا برسد محاسبه و اعلام می‌گردد.';

  @override
  String intervalsDefault(int km, int months) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String monthsString = monthsNumberFormat.format(months);

    return 'پیش‌فرض کارخانه: $kmString کیلومتر / $monthsString ماه';
  }

  @override
  String get intervalsResetRow => 'بازنشانی این مورد';

  @override
  String get intervalsMonthsUnit => 'ماه';

  @override
  String intervalsKmError(int min, int max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'کیلومتر را بین $minString تا $maxString وارد کنید';
  }

  @override
  String intervalsMonthsError(int min, int max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'ماه را بین $minString تا $maxString وارد کنید';
  }

  @override
  String get intervalsSave => 'ذخیره تنظیمات';

  @override
  String get intervalsSaved => 'تنظیمات دوره‌های سرویس با موفقیت ثبت شد';

  @override
  String get intervalsResetDone => 'تمام مقادیر به پیش‌فرض کارخانه بازگشتند';

  @override
  String get intervalsSaveInvalid => 'مقادیر دوره‌ها نامعتبر است، فیلدها را بررسی کنید';

  @override
  String get intervalsSaveFailed => 'ذخیره تنظیمات ممکن نشد، دوباره تلاش کنید';

  @override
  String get intervalsResetFailed => 'بازنشانی ممکن نشد، دوباره تلاش کنید';

  @override
  String get intervalsLoadError => 'دریافت دوره‌های سرویس ممکن نشد';

  @override
  String get dueTitle => 'سرویس‌های سررسید شده';

  @override
  String get dueSubtitle => 'وضعیت اقلام نیازمند اقدام فوری';

  @override
  String get dueSavedTitle => 'کیلومتر با موفقیت ثبت شد';

  @override
  String dueSavedDate(String date) {
    return 'امروز، $date';
  }

  @override
  String get dueNewMileageBadge => 'کارکرد جدید';

  @override
  String dueDelta(String delta) {
    return '$delta کیلومتر نسبت به ثبت قبل';
  }

  @override
  String get dueNoticeTitle => 'نیاز به بررسی دوره‌ای';

  @override
  String dueNoticeBodyAfterUpdate(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'با این کارکرد جدید، $countString سرویس خودرو به سررسید رسیده‌اند و نیازمند اقدام در تعمیرگاه هستند.';
  }

  @override
  String dueNoticeBody(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString سرویس خودرو به سررسید رسیده‌اند و نیازمند اقدام در تعمیرگاه هستند.';
  }

  @override
  String get dueListTitle => 'اقلام سررسید شده';

  @override
  String get dueListBasis => 'بر اساس پیمایش';

  @override
  String get dueStatusOverdue => 'رسیدگی فوری';

  @override
  String get dueStatusDueSoon => 'نزدیک به موعد';

  @override
  String get dueStatusUpcoming => 'اطلاعیه';

  @override
  String dueOverdueKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString کیلومتر گذشته از موعد';
  }

  @override
  String dueOverdueDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return '$daysString روز گذشته از موعد';
  }

  @override
  String dueSoonKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'تنها $kmString کیلومتر مانده';
  }

  @override
  String dueSoonDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return 'تنها $daysString روز مانده';
  }

  @override
  String dueUpcomingKm(int km, int months) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String monthsString = monthsNumberFormat.format(months);

    return '$kmString کیلومتر مانده (حدود $monthsString ماه)';
  }

  @override
  String dueUpcomingDays(int days, int months) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String monthsString = monthsNumberFormat.format(months);

    return '$daysString روز مانده (حدود $monthsString ماه)';
  }

  @override
  String dueAtKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'مقرر: $kmString کیلومتر';
  }

  @override
  String get dueActionOverdue => 'ثبت فاکتور این سرویس';

  @override
  String get dueActionRecord => 'ثبت این سرویس';

  @override
  String get dueArchiveTitle => 'بایگانی فاکتورها';

  @override
  String get dueArchiveBody => 'پس از انجام سرویس، اقلام را در یک فاکتور تجمیعی ثبت کنید.';

  @override
  String get dueConfirmBack => 'تأیید و بازگشت به داشبورد';

  @override
  String get dueRemindLater => 'بعداً یادآوری کن';

  @override
  String get dueEmpty => 'همه سرویس‌ها به‌موقع هستند';

  @override
  String get dueLoadError => 'دریافت وضعیت سرویس‌ها ممکن نشد';

  @override
  String get vehicleDetailsDueSettings => 'تنظیم';

  @override
  String get serviceSharedCardTitle => 'اطلاعات مشترک فاکتور';

  @override
  String get serviceSharedCardBody => 'تعمیرگاه و تصویر فاکتور برای همه اقلام این مراجعه';

  @override
  String get fuelPageTitle => 'ثبت سوخت‌گیری';

  @override
  String fuelLastFillFull(String date, int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'آخرین سوخت‌گیری: $date • $kmString کیلومتر (باک پر)';
  }

  @override
  String fuelLastFillPartial(String date, int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'آخرین سوخت‌گیری: $date • $kmString کیلومتر';
  }

  @override
  String get fuelNoLastFill => 'هنوز سوخت‌گیری ثبت نشده است';

  @override
  String get fuelDateLabel => 'تاریخ سوخت‌گیری';

  @override
  String get fuelDateOther => 'انتخاب تاریخ دیگر';

  @override
  String get fuelDatePickTitle => 'تاریخ سوخت‌گیری (تقویم جلالی)';

  @override
  String get fuelTimePickHelp => 'ساعت سوخت‌گیری';

  @override
  String get fuelTimeHint => 'تغییر ساعت';

  @override
  String get fuelOdometerLabel => 'کارکرد کیلومترشمار فعلی';

  @override
  String fuelOdometerPrevious(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'سند ثبت‌شده قبلی: $kmString';
  }

  @override
  String fuelOdometerSinceLast(String diff) {
    return '$diff کیلومتر پیمایش از باک قبل';
  }

  @override
  String get fuelTypeLabel => 'نوع سوخت دریافتی';

  @override
  String get fuelTypeRegular => 'معمولی';

  @override
  String get fuelTypeSuper => 'سوپر';

  @override
  String get fuelTypeCng => 'CNG';

  @override
  String get fuelTypeLpg => 'LPG';

  @override
  String get fuelVolumeLabel => 'حجم سوخت‌گیری';

  @override
  String get fuelUnitLitre => 'لیتر';

  @override
  String get fuelUnitCubicMetre => 'متر مکعب';

  @override
  String get fuelTotalCostLabel => 'مبلغ کل پرداختی';

  @override
  String get fuelRateLabel => 'نرخ محاسبه‌شده:';

  @override
  String fuelRateValue(int amount, String unit) {
    final intl.NumberFormat amountNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString تومان / $unit';
  }

  @override
  String get fuelFullFillTitle => 'باک کاملاً پر شد (باک پر)';

  @override
  String get fuelFullFillBody =>
      'جهت محاسبه دقیق مصرف سوخت در ۱۰۰ کیلومتر، فعال‌بودن این گزینه الزامی است.';

  @override
  String get fuelEconomyTitle => 'میانگین مصرف این دوره:';

  @override
  String fuelEconomyUnit(String unit) {
    return '$unit در ۱۰۰ کیلومتر';
  }

  @override
  String fuelEconomyBreakdown(int km, String volume, String unit) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString کیلومتر پیمایش با $volume $unit سوخت (از باک پر قبلی تا الان)';
  }

  @override
  String get fuelEconomyDisclaimer =>
      'اگر این باک کامل پر نشده بود، به جای عدد عبارت «قابل محاسبه نیست» نمایش داده می‌شد.';

  @override
  String get fuelEconomyUnavailable =>
      'برای محاسبه، این باک و باک قبلی باید کامل پر شده و نوع سوخت یکسان باشد.';

  @override
  String get fuelStationLabel => 'جایگاه سوخت';

  @override
  String get fuelPaymentLabel => 'روش پرداخت و سهمیه';

  @override
  String get fuelPaymentPick => 'انتخاب روش پرداخت';

  @override
  String get fuelPaymentPersonalFuelCard => 'کارت‌خوان جایگاه (کارت سوخت شخصی)';

  @override
  String get fuelPaymentStationFuelCard => 'کارت سوخت جایگاه (نرخ آزاد)';

  @override
  String get fuelPaymentBankCard => 'کارت بانکی';

  @override
  String get fuelPaymentCash => 'نقدی';

  @override
  String get fuelNotesLabel => 'یادداشت (اختیاری)';

  @override
  String get fuelNotesHint => 'مثال: استفاده از مکمل سوخت یا وضعیت پمپ...';

  @override
  String get fuelSubmit => 'ثبت سوخت‌گیری و ذخیره';

  @override
  String get fuelCancel => 'انصراف و بازگشت';

  @override
  String get fuelSaved => 'سوخت‌گیری ثبت شد';

  @override
  String get fuelSaveFailed => 'ثبت سوخت‌گیری ممکن نشد';

  @override
  String get fuelSaveInvalid => 'برخی مقادیر نامعتبر است، فرم را بررسی کنید';

  @override
  String get fuelDateInFuture => 'تاریخ و ساعت سوخت‌گیری نمی‌تواند در آینده باشد';

  @override
  String fuelVolumeError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'حجم سوخت را وارد کنید (بیشتر از ۰ و حداکثر $maxString)';
  }

  @override
  String get fuelTotalCostError => 'مبلغ کل پرداختی را وارد کنید';

  @override
  String fuelStationError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'نام جایگاه حداکثر $maxString حرف است';
  }

  @override
  String fuelNotesError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'یادداشت حداکثر $maxString حرف است';
  }

  @override
  String get fuelSectionTitle => 'آخرین سوخت‌گیری‌ها';

  @override
  String get fuelSectionEmpty => 'هنوز سوخت‌گیری برای این خودرو ثبت نشده است';

  @override
  String get fuelSectionLoadError => 'دریافت سوخت‌گیری‌ها ممکن نشد';

  @override
  String fuelRowTitle(String type, String volume, String unit) {
    return '$type • $volume $unit';
  }

  @override
  String fuelRowEconomy(String economy, String unit) {
    return '$economy $unit/۱۰۰ ک‌م';
  }

  @override
  String get expensePageTitle => 'ثبت هزینه';

  @override
  String get expenseManualNotice =>
      'کلیه ردیف‌های این بخش، ثبت دستی اطلاعات توسط کاربر است و ارتباط یا استعلام مستقیمی از سامانه‌های بیرونی انجام نمی‌شود.';

  @override
  String get expenseCategoryLabel => 'انتخاب سرفصل هزینه';

  @override
  String get expenseCategoryBadge => 'دسته‌بندی اصلی';

  @override
  String get expenseCategoryThirdPartyInsurance => 'بیمه شخص ثالث';

  @override
  String get expenseCategoryBodyInsurance => 'بیمه بدنه';

  @override
  String get expenseCategoryFine => 'جریمه رانندگی';

  @override
  String get expenseCategoryToll => 'عوارض و طرح';

  @override
  String get expenseCategoryInspection => 'معاینه فنی';

  @override
  String get expenseCategoryOther => 'سایر هزینه‌ها';

  @override
  String get expenseAmountLabel => 'مبلغ هزینه پرداخت‌شده';

  @override
  String get expenseRequired => 'الزامی';

  @override
  String get expenseRoundAmount => 'رند کردن';

  @override
  String get expenseTitleLabel => 'عنوان هزینه';

  @override
  String get expenseTitleHint => 'عنوان یا سرفصل ثبت‌شده';

  @override
  String get expenseReferenceLabel => 'شماره بیمه‌نامه یا کد یکتا / ارجاع';

  @override
  String get expenseReferenceHint => 'اختیاری - شماره سریال یا ارجاع';

  @override
  String get expensePaidAtLabel => 'تاریخ پرداخت / صدور';

  @override
  String get expenseDatePick => 'انتخاب تاریخ';

  @override
  String get expensePaidAtPickTitle => 'تاریخ پرداخت (تقویم جلالی)';

  @override
  String get expenseExpiryTitle => 'تعیین موعد انقضا یا تمدید بعدی';

  @override
  String get expenseExpiryBody => 'جهت صدور یادآور دوره‌ای';

  @override
  String expenseExpiryOneYear(String date) {
    return '$date (۱ سال بعد)';
  }

  @override
  String get expenseExpiryPick => 'انتخاب تاریخ انقضا';

  @override
  String get expenseExpiryPickTitle => 'تاریخ انقضا (تقویم جلالی)';

  @override
  String expenseDaysLeft(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$daysString روز مانده',
      one: '۱ روز مانده',
      zero: 'امروز',
    );
    return '$_temp0';
  }

  @override
  String get expenseReminderCheck => 'ارسال اعلان یادآور در روزهای ۷، ۱۵ و ۳۰ روز پیش از موعد';

  @override
  String get expenseAttachmentLabel => 'پیوست سند یا فیش پرداخت';

  @override
  String get expenseAttachmentAttached => '۱ فایل پیوست شده';

  @override
  String get expenseAttachmentNone => 'بدون پیوست';

  @override
  String get expenseAttachmentAdd => 'افزودن سند یا فیش پرداخت';

  @override
  String get expenseAttachmentHelp => 'فرمت‌های مجاز: PDF ، JPG و PNG تا سقف ۱۰ مگابایت.';

  @override
  String get expenseAttachmentRemove => 'حذف فایل';

  @override
  String expenseAttachmentMeta(String size, String kind) {
    return '$size • $kind';
  }

  @override
  String get expenseAttachmentPdf => 'سند PDF';

  @override
  String get expenseAttachmentImage => 'تصویر';

  @override
  String get expenseAttachmentPickFailed => 'انتخاب فایل ممکن نشد';

  @override
  String get expenseAttachmentInvalid => 'فقط فایل PDF، JPG یا PNG مجاز است';

  @override
  String expenseAttachmentTooLarge(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'حجم فایل بیشتر از $maxString مگابایت است';
  }

  @override
  String get expensePaymentLabel => 'شیوه پرداخت';

  @override
  String get expensePaymentOnline => 'پرداخت اینترنتی';

  @override
  String get expensePaymentPos => 'کارت‌خوان / پوز';

  @override
  String get expenseIssuerLabel => 'واحد صادرکننده یا نمایندگی';

  @override
  String get expenseIssuerHint => 'نام نمایندگی یا مرکز معاینه';

  @override
  String get expenseSaved => 'هزینه ثبت شد';

  @override
  String get expenseSavedAttachmentFailed => 'هزینه ثبت شد، اما پیوست ذخیره نشد';

  @override
  String get expenseSaveFailed => 'ثبت هزینه ممکن نشد';

  @override
  String get expenseSaveInvalid => 'برخی مقادیر نامعتبر است، فرم را بررسی کنید';

  @override
  String get expenseCategoryError => 'سرفصل هزینه را انتخاب کنید';

  @override
  String get expenseAmountError => 'مبلغ هزینه را وارد کنید';

  @override
  String expenseTitleError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'عنوان حداکثر $maxString حرف است';
  }

  @override
  String expenseReferenceError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'شماره حداکثر $maxString حرف است';
  }

  @override
  String get expensePaidAtError => 'تاریخ پرداخت نمی‌تواند در آینده باشد';

  @override
  String get expenseExpiresAtError => 'تاریخ انقضا باید بعد از تاریخ پرداخت باشد';

  @override
  String expenseIssuerError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'نام صادرکننده حداکثر $maxString حرف است';
  }

  @override
  String get expenseSectionTitle => 'آخرین هزینه‌ها';

  @override
  String get expenseSectionEmpty => 'هنوز هزینه‌ای برای این خودرو ثبت نشده است';

  @override
  String get expenseSectionLoadError => 'دریافت هزینه‌ها ممکن نشد';

  @override
  String notificationsUnreadLabel(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اعلانات، $countString خوانده‌نشده',
      zero: 'اعلانات',
    );
    return '$_temp0';
  }

  @override
  String get notificationsTitle => 'صندوق اعلانات';

  @override
  String notificationsNewCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString اعلان جدید',
      zero: 'اعلان جدیدی نیست',
    );
    return '$_temp0';
  }

  @override
  String get notificationsReadAll => 'خواندن همه';

  @override
  String notificationsFilterAll(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'همه ($countString)';
  }

  @override
  String get notificationsFilterService => 'سرویس و نگهداری';

  @override
  String get notificationsFilterDocuments => 'بیمه و اسناد';

  @override
  String get notificationsFilterSystem => 'سیستمی';

  @override
  String get notificationsEmptyTitle => 'اعلانی در این دسته‌بندی وجود ندارد';

  @override
  String get notificationsEmptyBody => 'تمام رویدادها و هشدارهای جدید در اینجا نمایش داده می‌شوند.';

  @override
  String get notificationsShowAll => 'مشاهده همه اعلان‌ها';

  @override
  String get notificationsRetention => 'تمامی اعلانات به مدت ۹۰ روز در تاریخچه حفظ می‌گردند';

  @override
  String get notificationsLoadError => 'دریافت اعلان‌ها ممکن نشد';

  @override
  String get notificationsActionFailed => 'انجام نشد، دوباره تلاش کنید';

  @override
  String notificationIntervalTitle(String subject, String vehicle) {
    return 'موعد $subject $vehicle';
  }

  @override
  String notificationIntervalMileage(int mileage) {
    final intl.NumberFormat mileageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String mileageString = mileageNumberFormat.format(mileage);

    return 'کارکرد خودرو به $mileageString کیلومتر رسیده است.';
  }

  @override
  String notificationIntervalRemaining(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'تنها $kmString کیلومتر تا سرویس باقی مانده است.';
  }

  @override
  String notificationIntervalOverdueKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString کیلومتر از موعد گذشته است.';
  }

  @override
  String notificationIntervalDueDate(String date) {
    return 'موعد سرویس $date است.';
  }

  @override
  String notificationIntervalOverdueDate(String date) {
    return 'موعد سرویس $date گذشته است.';
  }

  @override
  String get notificationAddService => 'ثبت سرویس';

  @override
  String notificationExpiryTitle(String subject) {
    return 'سررسید $subject';
  }

  @override
  String notificationExpiryBody(String subject, String vehicle, int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return '$subject خودرو $vehicle $daysString روز دیگر به اتمام می‌رسد.';
  }

  @override
  String notificationExpiredBody(String subject, String vehicle) {
    return '$subject خودرو $vehicle منقضی شده است.';
  }

  @override
  String notificationDaysLeft(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return '$daysString روز باقیمانده';
  }

  @override
  String get notificationExpired => 'منقضی شده';

  @override
  String get relativeJustNow => 'همین الان';

  @override
  String relativeMinutesAgo(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString دقیقه پیش';
  }

  @override
  String relativeHoursAgo(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString ساعت پیش';
  }

  @override
  String relativeYesterday(String time) {
    return 'دیروز، $time';
  }

  @override
  String get relativeLastWeek => 'هفته گذشته';

  @override
  String get documentsTitle => 'کیف مدارک خودرو';

  @override
  String get documentsVehicleSubtitle => 'کیف مدارک و یادآورهای هوشمند تمدید';

  @override
  String documentsSecureInfo(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString مدرک ثبت‌شده به‌صورت رمزگذاری‌شده نگهداری می‌شوند.';
  }

  @override
  String get documentsUploadTitle => 'بارگذاری مدرک جدید';

  @override
  String get documentsUploadBody =>
      'تصویر یا فایل PDF (کارت خودرو، بیمه‌نامه، معاینه فنی، برگ سبز یا وکالت)';

  @override
  String get documentsUploadCamera => 'دوربین';

  @override
  String get documentsUploadGallery => 'گالری';

  @override
  String get documentsUploadPdf => 'فایل PDF';

  @override
  String documentsFilterAll(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'همه ($countString)';
  }

  @override
  String documentsGroupInsurance(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'بیمه‌ها ($countString)';
  }

  @override
  String documentsGroupInspection(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'معاینه فنی ($countString)';
  }

  @override
  String documentsGroupIdentity(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'مدارک هویتی ($countString)';
  }

  @override
  String get documentsEmpty => 'هنوز مدرکی برای این خودرو ثبت نشده است';

  @override
  String get documentsFilterEmpty => 'مدرکی در این دسته وجود ندارد';

  @override
  String get documentsLoadError => 'دریافت مدارک ممکن نشد';

  @override
  String get documentTypeThirdPartyInsurance => 'بیمه شخص ثالث';

  @override
  String get documentTypeBodyInsurance => 'بیمه بدنه';

  @override
  String get documentTypeInspection => 'معاینه فنی';

  @override
  String get documentTypeVehicleCard => 'کارت خودرو';

  @override
  String get documentTypeGreenSheet => 'برگ سبز (سند مالکیت)';

  @override
  String get documentTypePowerOfAttorney => 'وکالت‌نامه';

  @override
  String documentStatusExpired(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return 'منقضی شده — $daysString روز گذشته';
  }

  @override
  String documentStatusDueSoon(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return 'موعد نزدیک — $daysString روز مانده';
  }

  @override
  String documentStatusValid(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return 'معتبر — $daysString روز مانده';
  }

  @override
  String get documentStatusPermanent => 'دائمی / بدون انقضا';

  @override
  String documentNumber(String number) {
    return 'شماره: $number';
  }

  @override
  String documentIssuedAt(String date) {
    return 'صدور: $date';
  }

  @override
  String documentExpiresAt(String date) {
    return 'انقضا: $date';
  }

  @override
  String get documentReminderOn => 'یادآور تمدید فعال است';

  @override
  String get documentViewFile => 'مشاهده اصل فایل';

  @override
  String get documentRenew => 'ثبت تمدید جدید';

  @override
  String get documentDetails => 'جزئیات';

  @override
  String documentImageCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString تصویر';
  }

  @override
  String get documentFileOpenFailed => 'باز کردن فایل ممکن نشد';

  @override
  String get documentFormNewTitle => 'ثبت مدرک';

  @override
  String get documentFormEditTitle => 'ویرایش مدرک';

  @override
  String get documentTypeLabel => 'نوع مدرک';

  @override
  String get documentTitleLabel => 'عنوان مدرک';

  @override
  String get documentTitleHint => 'مثلاً گواهی معاینه فنی برتر';

  @override
  String get documentIssuerLabel => 'صادرکننده';

  @override
  String get documentIssuerHint => 'مثلاً بیمه ایران';

  @override
  String get documentNumberLabel => 'شماره مدرک / بیمه‌نامه';

  @override
  String get documentNumberHint => 'مثلاً ۱۲۴/۹۸۷۴۳۲';

  @override
  String get documentIssuedAtLabel => 'تاریخ صدور';

  @override
  String get documentIssuedAtPick => 'انتخاب تاریخ صدور';

  @override
  String get documentIssuedAtPickTitle => 'تاریخ صدور (تقویم جلالی)';

  @override
  String get documentIssuedAtClear => 'حذف تاریخ صدور';

  @override
  String get documentNotesLabel => 'یادداشت';

  @override
  String get documentNotesHint => 'توضیحات تکمیلی (اختیاری)';

  @override
  String get documentFilesLabel => 'فایل‌های مدرک';

  @override
  String documentFilesCount(int count, int max) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return '$countString از $maxString';
  }

  @override
  String get documentFilesAdd => 'افزودن فایل';

  @override
  String documentFilesHelp(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'حداکثر $maxString فایل PDF، JPG یا PNG، هر کدام تا ۱۰ مگابایت.';
  }

  @override
  String documentFileLimit(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'حداکثر $maxString فایل برای هر مدرک';
  }

  @override
  String get documentSave => 'ذخیره مدرک';

  @override
  String get documentSaved => 'مدرک ذخیره شد';

  @override
  String get documentSavedFilesFailed => 'مدرک ذخیره شد، اما بارگذاری فایل انجام نشد';

  @override
  String get documentSaveInvalid => 'اطلاعات مدرک را بررسی کنید';

  @override
  String get documentSaveFailed => 'ذخیره مدرک ممکن نشد';

  @override
  String get documentTypeError => 'نوع مدرک را انتخاب کنید';

  @override
  String documentTitleError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'عنوان حداکثر $maxString حرف است';
  }

  @override
  String documentIssuerError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'صادرکننده حداکثر $maxString حرف است';
  }

  @override
  String documentNumberError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'شماره حداکثر $maxString حرف است';
  }

  @override
  String documentNotesError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'یادداشت حداکثر $maxString حرف است';
  }

  @override
  String get documentExpiresAtError => 'تاریخ انقضا را بعد از تاریخ صدور انتخاب کنید';

  @override
  String get documentDelete => 'حذف مدرک';

  @override
  String get documentDeleteConfirmTitle => 'این مدرک حذف شود؟';

  @override
  String get documentDeleteConfirmBody => 'مدرک و همه فایل‌های آن برای همیشه حذف می‌شوند.';

  @override
  String get documentDeleteCancel => 'انصراف';

  @override
  String get documentDeleted => 'مدرک حذف شد';

  @override
  String get documentDeleteFailed => 'حذف مدرک ممکن نشد';

  @override
  String get documentFileDeleteFailed => 'حذف فایل ممکن نشد';

  @override
  String get profileStatDocuments => 'مدرک در کیف';
}
