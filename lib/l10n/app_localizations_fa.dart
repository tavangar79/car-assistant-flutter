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
}
