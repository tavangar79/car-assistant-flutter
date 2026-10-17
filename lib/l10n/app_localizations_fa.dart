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
  String get vehiclesTitle => 'خودروهای من';

  @override
  String get vehiclesEmpty => 'هنوز خودرویی ثبت نشده است';

  @override
  String get vehiclesLoadError => 'دریافت خودروها ممکن نشد';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String vehicleTitle(String make, String model, String year) {
    return '$make $model مدل $year';
  }

  @override
  String vehicleMileage(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString کیلومتر';
  }

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
}
