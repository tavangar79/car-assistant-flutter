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
  String get authPhoneTitle => 'ورود یا ثبت‌نام';

  @override
  String get authPhoneSubtitle => 'شماره موبایل خود را وارد کنید تا کد تأیید برایتان پیامک شود';

  @override
  String get authPhoneLabel => 'شماره موبایل';

  @override
  String get authPhoneInvalid => 'شماره موبایل معتبر نیست';

  @override
  String get authSendCode => 'دریافت کد تأیید';

  @override
  String get authOtpTitle => 'کد تأیید را وارد کنید';

  @override
  String authOtpSubtitle(String phone) {
    return 'کد تأیید به $phone پیامک شد';
  }

  @override
  String get authEditPhone => 'ویرایش شماره';

  @override
  String get authOtpFieldLabel => 'کد تأیید';

  @override
  String get authVerify => 'تأیید و ورود';

  @override
  String authResendIn(String time) {
    return 'ارسال دوباره کد تا $time';
  }

  @override
  String get authResend => 'ارسال دوباره کد';

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
