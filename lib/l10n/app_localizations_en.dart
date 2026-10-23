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
  String get vehiclesLoadError => 'Couldn\'t load your vehicles';

  @override
  String get retry => 'Retry';

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

  @override
  String get profileHeaderTitle => 'Complete your profile';

  @override
  String get profileTitle => 'Complete your account';

  @override
  String get profileDescription =>
      'Enter your personal details for invoices, licence renewal reminders and official transfer of your car\'s records.';

  @override
  String get profileFirstNameLabel => 'First name';

  @override
  String get profileFirstNameHint => 'e.g. Ali';

  @override
  String get profileLastNameLabel => 'Last name';

  @override
  String get profileLastNameHint => 'e.g. Mohammadi';

  @override
  String get profileRequiredLabel => 'required';

  @override
  String get profileBirthDateLabel => 'Date of birth';

  @override
  String get profileBirthDatePlaceholder => 'Select a date';

  @override
  String get profileBirthDateChange => 'Change';

  @override
  String get profileBirthDateHint =>
      'Pick your birth date year-first on the Jalali (Persian) calendar.';

  @override
  String get profilePhoneLabel => 'Owner\'s phone number';

  @override
  String get profilePhoneVerified => 'Verified';

  @override
  String get profilePrivacyTitle => 'Records security and privacy';

  @override
  String get profilePrivacyBody =>
      'Your identity details are kept only for official invoice records, technical inspections and transferring the logbook when you sell the car.';

  @override
  String get profileSave => 'Confirm and save';

  @override
  String get profileFirstNameError => 'Enter your first name (up to 50 characters)';

  @override
  String get profileLastNameError => 'Enter your last name (up to 50 characters)';

  @override
  String get profileBirthDateError => 'Choose a valid date of birth';

  @override
  String get profileSaveInvalid => 'Some details are not valid, please check them';

  @override
  String get profilePickerTitle => 'Date of birth (Jalali calendar)';

  @override
  String get profilePickerDay => 'Day';

  @override
  String get profilePickerMonth => 'Month';

  @override
  String get profilePickerYear => 'Year';

  @override
  String get profilePickerHint => 'Scroll the wheels to set the day, month and year';

  @override
  String get profilePickerConfirm => 'Confirm date';

  @override
  String get profilePickerCancel => 'Cancel';

  @override
  String get profilePickerClose => 'Close';

  @override
  String profileBirthDateValue(String day, String month, String year) {
    return '$day $month $year';
  }

  @override
  String jalaliMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      '1': 'Farvardin',
      '2': 'Ordibehesht',
      '3': 'Khordad',
      '4': 'Tir',
      '5': 'Mordad',
      '6': 'Shahrivar',
      '7': 'Mehr',
      '8': 'Aban',
      '9': 'Azar',
      '10': 'Dey',
      '11': 'Bahman',
      '12': 'Esfand',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get profileAvatarOptional => 'Adding a profile photo is optional';

  @override
  String get profileAvatarEdit => 'Edit profile photo';

  @override
  String get profileAvatarGallery => 'Choose from gallery';

  @override
  String get profileAvatarCamera => 'Take a photo';

  @override
  String get profileAvatarRemove => 'Remove photo';

  @override
  String get profileAvatarUploading => 'Uploading photo...';

  @override
  String get profileAvatarInvalid => 'Only JPG, PNG or WebP images can be uploaded';

  @override
  String get profileAvatarTooLarge => 'The photo must be smaller than 2 MB';

  @override
  String get profileAvatarPickFailed => 'Couldn\'t open the photo';

  @override
  String get navHome => 'Home';

  @override
  String get navGarage => 'My Garage';

  @override
  String get navHistory => 'History';

  @override
  String get historyAllVehicles => 'All vehicles';

  @override
  String historyVehicleCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString vehicles';
  }

  @override
  String get historyChooseVehicle => 'Choose a vehicle';

  @override
  String get historyFilterTooltip => 'Filter records';

  @override
  String historyVehicleMeta(String year, int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Model $year • current mileage $kmString km';
  }

  @override
  String get historyGarageTitle => 'Every vehicle in the garage';

  @override
  String historySelectedTitle(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString chosen vehicles';
  }

  @override
  String historyGarageMeta(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString registered vehicles';
  }

  @override
  String historySummaryYear(String year) {
    return 'Total costs of $year';
  }

  @override
  String get historySummarySixMonths => 'Total costs of the last 6 months';

  @override
  String get historySummaryAll => 'Total costs';

  @override
  String get historySummaryCustom => 'Total costs of the chosen range';

  @override
  String historySummaryCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString records';
  }

  @override
  String get historyToman => 'Toman';

  @override
  String get historyServicesLabel => 'Services and visits';

  @override
  String historyServicesValue(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString services';
  }

  @override
  String get historyFuelLabel => 'Total fuel';

  @override
  String historyFuelValue(String volume) {
    return '$volume L';
  }

  @override
  String get historyTabAll => 'All';

  @override
  String get historyTabService => 'Service & repair';

  @override
  String get historyTabFuel => 'Fuel';

  @override
  String get historyTabExpense => 'Expenses';

  @override
  String get historyInvoiceChip => 'With invoice';

  @override
  String get historyExport => 'Excel/PDF export';

  @override
  String historyPeriodCurrentYear(String year) {
    return 'This year ($year)';
  }

  @override
  String get historyPeriodSixMonths => 'Last 6 months';

  @override
  String get historyPeriodAll => 'All time';

  @override
  String get historyPeriodCustom => 'Custom';

  @override
  String historyMonthCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString items';
  }

  @override
  String historyRowKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString km';
  }

  @override
  String historyRowVolume(String volume, String unit) {
    return '$volume $unit';
  }

  @override
  String historyFullFill(String fuel) {
    return '$fuel (full tank)';
  }

  @override
  String historyEconomy(String value) {
    return '$value L / 100 km';
  }

  @override
  String get historyInvoiceBadge => 'Invoice';

  @override
  String get historyAttachmentBadge => 'Attachment';

  @override
  String historyExpiresAt(String date) {
    return 'Valid until: $date';
  }

  @override
  String historyStart(String date) {
    return 'History starts when the vehicle was added ($date)';
  }

  @override
  String get historyEmpty => 'No records match these filters';

  @override
  String get historyLoadError => 'Could not load the history';

  @override
  String get historyLoadMoreError => 'Could not load more records';

  @override
  String get historyFilterTitle => 'Filter records';

  @override
  String historyFilterActive(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString active';
  }

  @override
  String get historyFilterClear => 'Clear';

  @override
  String get historyFilterClose => 'Close';

  @override
  String get historyFilterVehicles => 'Vehicle';

  @override
  String get historyFilterVehiclesHint => '(search scope)';

  @override
  String historyFilterSelectedVehicles(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Chosen: $countString';
  }

  @override
  String historyFilterMileage(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Last mileage: $kmString km';
  }

  @override
  String get historyFilterAllVehicles => 'Every vehicle in the garage';

  @override
  String historyFilterAllVehiclesHint(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Show all $countString registered vehicles';
  }

  @override
  String get historyFilterCategories => 'Service and expense categories';

  @override
  String get historyFilterSelectAll => 'Select all';

  @override
  String get historyCategoryLegal => 'Legal costs';

  @override
  String get historyCategoryLegalHint => 'Insurance, inspection, tolls';

  @override
  String get historyFilterDocuments => 'Financial documents';

  @override
  String get historyFilterAttachmentsOnly => 'Only records with an attachment / invoice';

  @override
  String get historyFilterAttachmentsHint => 'Invoice photo, receipt, warranty';

  @override
  String get historyFilterPeriod => 'Date range';

  @override
  String get historyFilterCalendar => 'Jalali calendar';

  @override
  String historyFilterRange(String from, String to) {
    return '$from to $to';
  }

  @override
  String get historyFilterFrom => 'From';

  @override
  String get historyFilterTo => 'To';

  @override
  String get historyFilterPickDate => 'Confirm date';

  @override
  String get historyFilterResults => 'Matching records:';

  @override
  String historyFilterResultsValue(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString records';
  }

  @override
  String get historyFilterApply => 'Apply filter';

  @override
  String get navProfile => 'Profile';

  @override
  String get quickAdd => 'Quick add';

  @override
  String get notifications => 'Notifications';

  @override
  String get accountLabel => 'Account';

  @override
  String garageVehicleCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString vehicles',
      one: '1 vehicle',
    );
    return '$_temp0';
  }

  @override
  String get emptyGarageTitle => 'Add a vehicle';

  @override
  String get emptyGarageBody =>
      'Add your first vehicle to the garage to start logging services, invoices and periodic reminders.';

  @override
  String get addVehicle => 'Add vehicle';

  @override
  String get garageBenefitsTitle => 'Your vehicle file features';

  @override
  String garageBenefitsSteps(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString first steps';
  }

  @override
  String get benefitPlateTitle => 'National standard plate';

  @override
  String get benefitPlateBody =>
      'Register an Iranian plate in the official format with its province';

  @override
  String get benefitServiceTitle => 'Smart service book';

  @override
  String get benefitServiceBody => 'Exact due dates for oil, filter and consumable part changes';

  @override
  String get benefitRecordsTitle => 'Transfer records and invoices';

  @override
  String get benefitRecordsBody =>
      'Keep the full financial record when transferring or selling the vehicle';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get vehicleFormIntroTitle => 'Vehicle identity';

  @override
  String get vehicleFormIntroBody => 'Your car\'s technical file in your garage';

  @override
  String get vehicleOptional => '(optional)';

  @override
  String get vehicleRequiredLabel => 'required';

  @override
  String get vehiclePhotoLabel => 'Vehicle photo';

  @override
  String get vehiclePhotoTitle => 'Upload or take a photo of the car';

  @override
  String vehiclePhotoLimits(int mb) {
    final intl.NumberFormat mbNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String mbString = mbNumberFormat.format(mb);

    return 'Up to $mbString MB • JPG or PNG';
  }

  @override
  String get vehiclePhotoGalleryChip => 'Choose from gallery';

  @override
  String get vehiclePhotoCamera => 'Take a photo';

  @override
  String get vehiclePhotoChange => 'Change photo';

  @override
  String get vehiclePhotoRemove => 'Remove photo';

  @override
  String get vehiclePhotoPickFailed => 'Couldn\'t open the gallery or camera';

  @override
  String vehiclePhotoTooLarge(int mb) {
    final intl.NumberFormat mbNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String mbString = mbNumberFormat.format(mb);

    return 'The image is larger than $mbString MB';
  }

  @override
  String get vehiclePhotoInvalid => 'Only JPG or PNG images are accepted';

  @override
  String get vehicleNicknameLabel => 'Nickname or custom title';

  @override
  String get vehicleNicknameBadge => 'Shown on the dashboard';

  @override
  String get vehicleNicknameHint => 'e.g. My grey 206, work Shahin';

  @override
  String get vehicleNicknameHelp => 'A clear name to tell the cars in your garage apart';

  @override
  String vehicleNicknameError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Enter a name (up to $maxString characters)';
  }

  @override
  String get vehiclePlateLabel => 'License plate';

  @override
  String get vehiclePlateBadge => 'Traffic police standard';

  @override
  String get vehiclePlateHelp =>
      'Order: two digits, a letter, three digits and the two-digit province code';

  @override
  String get vehiclePlateTwoDigits => 'Plate two digits';

  @override
  String get vehiclePlateLetter => 'Plate letter';

  @override
  String get vehiclePlateThreeDigits => 'Plate three digits';

  @override
  String get vehiclePlateProvince => 'Plate province code';

  @override
  String get vehiclePlateIran => 'ایران';

  @override
  String get vehiclePlateBandTop => 'I.R.';

  @override
  String get vehiclePlateBandBottom => 'IRAN';

  @override
  String get vehiclePlateError => 'Enter the full plate';

  @override
  String get vehiclePlateTaken => 'This plate is already in your garage';

  @override
  String get vehicleVinLabel => 'Vehicle identification number (VIN)';

  @override
  String vehicleVinBadge(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString Latin characters';
  }

  @override
  String get vehicleVinHint => 'NAAM21CA9KK123456';

  @override
  String get vehicleVinHelp =>
      'The 17-character code on the vehicle card or the edge of the windshield';

  @override
  String vehicleVinError(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'The VIN must be $countString letters or digits (no I, O or Q)';
  }

  @override
  String get vehicleMakeSectionTitle => 'Make and specs';

  @override
  String get vehicleMakeSectionBadge => 'Official factory list';

  @override
  String get vehicleMakeLabel => 'Brand / make';

  @override
  String get vehicleModelLabel => 'Model';

  @override
  String get vehicleTrimLabel => 'Trim and gearbox';

  @override
  String get vehicleMakeHint => 'Choose a brand';

  @override
  String get vehicleModelHint => 'Choose a model';

  @override
  String get vehicleTrimHint => 'Choose a trim';

  @override
  String get vehicleMakeError => 'Choose a brand';

  @override
  String get vehicleModelError => 'Choose a model';

  @override
  String get vehicleTrimError => 'The chosen trim is not valid';

  @override
  String get vehicleCatalogError => 'Couldn\'t load the list of cars';

  @override
  String get vehicleYearLabel => 'Model year (Jalali)';

  @override
  String get vehicleYearBadge => 'Jalali calendar';

  @override
  String get vehicleYearHint => 'Choose a year';

  @override
  String get vehicleYearPickerTitle => 'Choose the model year (Jalali)';

  @override
  String vehicleYearZeroKm(String year) {
    return '$year (brand new)';
  }

  @override
  String get vehicleYearConfirm => 'Confirm year';

  @override
  String get vehicleYearClose => 'Close';

  @override
  String get vehicleYearError => 'Choose the model year';

  @override
  String get vehicleMileageLabel => 'Current odometer';

  @override
  String get vehicleMileageBadge => 'Important';

  @override
  String get vehicleMileageUnit => 'km';

  @override
  String get vehicleMileageHelp =>
      'The basis for every service, oil, insurance and depreciation reminder';

  @override
  String vehicleMileageError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Enter a reading from 0 to $maxString km';
  }

  @override
  String get vehicleColorLabel => 'Body colour';

  @override
  String get vehicleColorWhite => 'White';

  @override
  String get vehicleColorBlack => 'Ebony black';

  @override
  String get vehicleColorSilver => 'Metallic silver';

  @override
  String get vehicleColorBlue => 'Royal blue';

  @override
  String get vehicleColorRed => 'Madder red';

  @override
  String get vehicleColorBeige => 'Titanium beige';

  @override
  String get vehicleColorError => 'The chosen colour is not valid';

  @override
  String get vehicleDefaultTitle => 'Set as default vehicle';

  @override
  String get vehicleDefaultBody =>
      'Quick fuel and service entries and the dashboard use this vehicle first.';

  @override
  String get vehicleDefaultLocked =>
      'To change the default vehicle, make another vehicle the default.';

  @override
  String get vehicleSave => 'Save and add to garage';

  @override
  String get vehicleSaving => 'Saving...';

  @override
  String get vehicleCancel => 'Cancel';

  @override
  String get vehicleAdded => 'Vehicle added';

  @override
  String get vehicleAddedPhotoFailed => 'Vehicle added, but the photo could not be uploaded';

  @override
  String get vehicleSaveInvalid => 'Some details are not valid; check the marked fields';

  @override
  String get vehicleSaveFailed => 'Couldn\'t save the vehicle. Try again';

  @override
  String vehiclePlateText(
    String twoDigits,
    String letter,
    String threeDigits,
    String provinceCode,
  ) {
    return '$twoDigits $letter $threeDigits Iran $provinceCode';
  }

  @override
  String get vehiclePlateLetterHint => 'Letter';

  @override
  String get editVehicle => 'Edit vehicle';

  @override
  String get vehicleOptions => 'Vehicle options';

  @override
  String get vehicleSaveChanges => 'Save changes';

  @override
  String get vehicleUpdated => 'Vehicle updated';

  @override
  String get vehicleUpdatedPhotoFailed => 'Changes saved, but the photo could not be updated';

  @override
  String get odometerTitle => 'Update odometer';

  @override
  String get odometerSubtitle => 'Keeps service due dates and reminders accurate';

  @override
  String get odometerClose => 'Close';

  @override
  String get odometerPickVehicle => 'Choose vehicle';

  @override
  String get activeVehicleBadge => 'Active vehicle';

  @override
  String get odometerCurrentLabel => 'Current odometer';

  @override
  String odometerLastRecorded(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Last recorded: $kmString km';
  }

  @override
  String odometerDiff(String diff) {
    return '$diff km';
  }

  @override
  String get odometerSinceLastUpdate => 'driven since the last update';

  @override
  String odometerSinceLastUpdateOn(String date) {
    return 'driven since the last update ($date)';
  }

  @override
  String get odometerReset => 'Reset';

  @override
  String get odometerQuickAdjust => 'Quick adjust';

  @override
  String get odometerRecordedAtLabel => 'Date and time';

  @override
  String odometerRecordedAtToday(String date, String time) {
    return 'Today, $date — $time';
  }

  @override
  String odometerRecordedAtValue(String date, String time) {
    return '$date — $time';
  }

  @override
  String get odometerChangeDate => 'Change date';

  @override
  String get odometerSubmit => 'Confirm reading';

  @override
  String get odometerCancel => 'Cancel';

  @override
  String odometerBelowCurrent(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'The reading can\'t be lower than the last one ($kmString km)';
  }

  @override
  String get odometerSaved => 'Reading saved';

  @override
  String get odometerSaveFailed => 'Couldn\'t save the reading, try again';

  @override
  String get vehicleDetailsTitle => 'Vehicle details';

  @override
  String get vehicleDetailsLoadError => 'Couldn\'t load the vehicle';

  @override
  String get vehicleDetailsActive => 'Active in garage';

  @override
  String vehicleDetailsModelYear(String year) {
    return 'Model $year';
  }

  @override
  String vehicleDetailsVin(String vin) {
    return 'VIN: $vin';
  }

  @override
  String get vehicleDetailsMileageTitle => 'Current mileage';

  @override
  String get vehicleDetailsMileageBadge => 'Basis for reminders';

  @override
  String get vehicleDetailsUpdateMileage => 'Update mileage';

  @override
  String get vehicleDetailsDueTitle => 'Status and upcoming services';

  @override
  String get vehicleDetailsDueEmpty => 'Nothing to follow up yet';

  @override
  String get vehicleDetailsHistoryTitle => 'Latest services';

  @override
  String get vehicleDetailsHistoryEmpty => 'No services recorded for this vehicle yet';

  @override
  String get vehicleDetailsExport => 'Download report and invoices (PDF)';

  @override
  String get quickActionsTitle => 'Quick actions';

  @override
  String get quickActionsClose => 'Close';

  @override
  String get quickActionsScope => 'Entries are saved for this vehicle';

  @override
  String get quickActionOdometerBody => 'Keep service reminders on time by mileage';

  @override
  String get quickActionServiceTitle => 'Log service & repairs';

  @override
  String get quickActionServiceBody => 'Oil, brake pads, filters and the workshop invoice';

  @override
  String get quickActionFuelTitle => 'Log fuel';

  @override
  String get quickActionFuelBody => 'Regular, super or CNG, and fuel economy';

  @override
  String get quickActionExpenseTitle => 'Log other expense';

  @override
  String get quickActionExpenseBody => 'Insurance, tolls, fines and inspection';

  @override
  String get quickActionAddVehicleTitle => 'Add a new vehicle';

  @override
  String get quickActionAddVehicleBody => 'Register the plate and open a new cost ledger';

  @override
  String get quickActionGarageTag => 'Garage';

  @override
  String get quickActionUnavailable => 'Coming soon';

  @override
  String get odometerPickDateTitle => 'Reading date (Jalali calendar)';

  @override
  String get odometerPickDateConfirm => 'Confirm date';

  @override
  String get homeAppName => 'Car Care';

  @override
  String get homeFleetManage => 'Manage';

  @override
  String get homeCostThisYear => 'Total cost this year';

  @override
  String get currencyToman => 'Toman';

  @override
  String get homeCostFooter => 'Filter in history ›';

  @override
  String get homeInvoicesTitle => 'Invoices';

  @override
  String get homeInvoicesUnit => 'recorded';

  @override
  String get homeInvoicesFooter => 'View documents ›';

  @override
  String get homeAttentionTitle => 'Needs attention';

  @override
  String get homeAttentionUnit => 'urgent items';

  @override
  String get homeAttentionFooter => 'Review items ›';

  @override
  String get valueUnavailable => '—';

  @override
  String get notComputable => 'Can\'t be calculated';

  @override
  String homeSpendTitle(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Spend, last $countString months';
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
  String get homeSpendEmpty => 'No costs recorded yet';

  @override
  String get homeUpdateOdometerHint => 'Pick a vehicle and quickly record its odometer';

  @override
  String homeSpendMonthTotal(String month, String year) {
    return '$month $year (total)';
  }

  @override
  String homeSpendAmount(String amount) {
    return '$amount toman';
  }

  @override
  String get dashboardLoadError => 'Couldn\'t load the dashboard';

  @override
  String profileMemberSince(String month, String year) {
    return 'Member since $month $year';
  }

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileStatVehicles => 'Active vehicles';

  @override
  String get profileStatServices => 'Services recorded';

  @override
  String get profileStatsLoadError => 'Couldn\'t load your stats';

  @override
  String get profileSettingsSection => 'Settings';

  @override
  String get profileReminders => 'Reminder settings';

  @override
  String get profileRemindersHint => 'When to send due-service and insurance messages';

  @override
  String get profileSms => 'SMS notifications';

  @override
  String get profileSmsHint => 'Manage service and fuel text messages';

  @override
  String get profileSecurity => 'Security';

  @override
  String get profileSecurityHint => 'Two-factor sign-in and biometrics';

  @override
  String get profileLegalSection => 'Support & legal';

  @override
  String get profileSupport => 'Support & contact';

  @override
  String get profileSupportHint => 'Online help and support tickets';

  @override
  String get profilePrivacy => 'Terms & privacy';

  @override
  String get profilePrivacyHint => 'Terms of use and data protection';

  @override
  String get profileLogout => 'Sign out of your account';

  @override
  String profileAppVersion(String version) {
    return 'App version $version';
  }

  @override
  String get garageHistoryTooltip => 'Event history';

  @override
  String get garageMyVehicles => 'My vehicles';

  @override
  String garageActiveCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString active vehicles';
  }

  @override
  String get garageDefaultBadge => 'Default vehicle';

  @override
  String get garageSetDefault => 'Set as default';

  @override
  String get garageSetDefaultError => 'Couldn\'t change the default vehicle';

  @override
  String get garageOdometerLabel => 'Current odometer';

  @override
  String garageLastReading(String when) {
    return 'Last update: $when';
  }

  @override
  String relativeDaysAgo(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$daysString days ago',
      one: 'yesterday',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String get garageServiceStatusTitle => 'Service status';

  @override
  String get garageActionService => 'Log service';

  @override
  String get garageActionOdometer => 'Log mileage';

  @override
  String get garageActionRecords => 'Records book';

  @override
  String get garageToolsTitle => 'Garage tools';

  @override
  String get garageToolsSubtitle => 'Documents and transfer';

  @override
  String get garageToolTransferTitle => 'Transfer ownership';

  @override
  String get garageToolTransferBody => 'Hand the records to the new owner without losing data';

  @override
  String get garageToolDocumentsTitle => 'Documents and insurance';

  @override
  String get garageToolDocumentsBody => 'Vehicle card, ownership papers, insurance and inspection';

  @override
  String get garageToolExportTitle => 'Export the vehicle file';

  @override
  String get garageToolExportBody => 'Service and cost history for a sale or an inspection';

  @override
  String get serviceWizardTitle => 'New service';

  @override
  String get serviceStep1Label => 'Items';

  @override
  String get serviceStep2Label => 'Date & mileage';

  @override
  String get serviceStep3Label => 'Details & cost';

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

    return '$countString selected';
  }

  @override
  String get serviceClearAll => 'Clear all';

  @override
  String get serviceSearchHint => 'Search services (e.g. oil, brake pads, spark plugs…)';

  @override
  String get serviceSearchEmpty => 'No service matches that name';

  @override
  String get serviceCatalogLoadError => 'Couldn\'t load the service list';

  @override
  String get serviceFooterLabel => 'Items to record:';

  @override
  String serviceFooterCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString services selected';
  }

  @override
  String get serviceContinueStep2 => 'Continue to step 2 (date & mileage)';

  @override
  String get serviceSelectedItemsLabel => 'Items on this invoice:';

  @override
  String get serviceEditItems => 'Edit items';

  @override
  String get serviceOdometerTitle => 'Invoice mileage';

  @override
  String get serviceOdometerBadge => 'Wear baseline';

  @override
  String get serviceOdometerLabel => 'Odometer at the time of service';

  @override
  String serviceOdometerLastOn(int km, String date, String when) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Last reading: $kmString km ($date — $when)';
  }

  @override
  String serviceOdometerDiff(String diff) {
    return '$diff km driven';
  }

  @override
  String get serviceQuickAdjust => 'Quick adjust by mileage:';

  @override
  String get serviceDateTitle => 'Invoice date';

  @override
  String get serviceDateBadge => 'Jalali calendar';

  @override
  String get serviceDateLabel => 'Service date';

  @override
  String serviceDateValue(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String jalaliWeekday(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '1': 'Saturday',
      '2': 'Sunday',
      '3': 'Monday',
      '4': 'Tuesday',
      '5': 'Wednesday',
      '6': 'Thursday',
      '7': 'Friday',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get serviceDateToday => 'Today';

  @override
  String get serviceDateYesterday => 'Yesterday';

  @override
  String get serviceDateLastWeek => 'Last week';

  @override
  String get serviceDatePick => 'Pick from calendar';

  @override
  String get serviceDatePickTitle => 'Service date (Jalali calendar)';

  @override
  String get serviceStickerTitle => 'Service sticker (optional)';

  @override
  String get serviceStickerBody =>
      'For an exact match, enter the next-service mileage printed on the oil-change sticker.';

  @override
  String get serviceStickerKmLabel => 'Next sticker mileage';

  @override
  String get serviceVisitTimeLabel => 'Visit time';

  @override
  String get serviceVisitTimePickHelp => 'Visit time';

  @override
  String get serviceSyncTitle => 'Invoice and parts in sync';

  @override
  String serviceSyncBody(String items) {
    return 'This mileage and date are the shared baseline for every item on this invoice ($items) and go into the vehicle history.';
  }

  @override
  String get serviceContinueStep3 => 'Continue to step 3 (details & costs)';

  @override
  String get serviceBackToItems => 'Back to items';

  @override
  String get serviceDateInFuture => 'The service date and time can\'t be in the future';

  @override
  String serviceKmValue(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString km';
  }

  @override
  String serviceItemIndex(int index, int count) {
    final intl.NumberFormat indexNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String indexString = indexNumberFormat.format(index);
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Item $indexString of $countString';
  }

  @override
  String get serviceRemoveItem => 'Remove service';

  @override
  String get serviceCostLabel => 'Part and labour cost';

  @override
  String get serviceBrandLabel => 'Brand and specification';

  @override
  String get serviceWorkshopLabel => 'Workshop / service centre';

  @override
  String get serviceNotesLabel => 'Technical notes';

  @override
  String get serviceInvoiceLabel => 'Invoice or receipt photo';

  @override
  String get serviceInvoiceAttach => 'Add invoice photo';

  @override
  String serviceInvoiceAttached(String size) {
    return '$size • attached';
  }

  @override
  String get serviceInvoiceChange => 'Change photo';

  @override
  String get serviceInvoiceRemove => 'Remove photo';

  @override
  String get serviceInvoiceGallery => 'Choose from gallery';

  @override
  String get serviceInvoiceCamera => 'Take a photo';

  @override
  String get serviceInvoicePickFailed => 'Couldn\'t pick a photo';

  @override
  String serviceInvoiceTooLarge(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'The invoice photo is larger than $maxString MB';
  }

  @override
  String get serviceInvoiceInvalid => 'The invoice photo must be a JPG, PNG or WebP';

  @override
  String megabytes(String size) {
    return '$size MB';
  }

  @override
  String get serviceReminderTitle => 'Next reminder';

  @override
  String get serviceReminderHint => 'Whichever comes first';

  @override
  String get serviceReminderKmLabel => 'Next mileage';

  @override
  String get serviceReminderMonthsLabel => 'Time interval';

  @override
  String get serviceReminderMonthsUnit => 'months later';

  @override
  String serviceReminderDueKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Due: $kmString km';
  }

  @override
  String serviceReminderDueDate(String month, String year) {
    return 'Due: $month $year';
  }

  @override
  String get serviceReminderNone => 'No reminder';

  @override
  String get serviceAddAnotherItem => 'Add another service item to this invoice';

  @override
  String serviceTotalLabel(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Invoice total ($countString items)';
  }

  @override
  String get serviceTotalHint => 'Labour and parts included';

  @override
  String get serviceSubmit => 'Save invoice and records';

  @override
  String get serviceSaving => 'Saving…';

  @override
  String serviceWorkshopError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Enter the workshop name (at most $maxString characters)';
  }

  @override
  String get serviceLineItemsError => 'This item\'s values are invalid, please check them';

  @override
  String get serviceSaveInvalid => 'The invoice is invalid, please check the fields';

  @override
  String get serviceSaveFailed => 'Couldn\'t save the service, please try again';

  @override
  String get serviceSaved => 'Service saved';

  @override
  String get serviceSavedInvoiceFailed => 'Service saved, but the invoice photo upload failed';

  @override
  String get serviceDetailsEyebrow => 'Workshop visits';

  @override
  String get serviceDetailsTitle => 'Service invoice';

  @override
  String get serviceDetailsOptions => 'Invoice options';

  @override
  String get serviceDetailsDelete => 'Delete invoice';

  @override
  String get serviceDetailsDeleteConfirmTitle => 'Delete this invoice?';

  @override
  String get serviceDetailsDeleteConfirmBody =>
      'Every item and the invoice photo will be removed. This can\'t be undone.';

  @override
  String get confirmDelete => 'Delete';

  @override
  String get serviceDetailsDateLabel => 'Visit date';

  @override
  String get serviceDetailsOdometerLabel => 'Odometer';

  @override
  String get serviceDetailsWorkshopLabel => 'Workshop / service centre';

  @override
  String get serviceDetailsNotesLabel => 'Notes';

  @override
  String get serviceDetailsHeaderNote =>
      'The invoice header is fixed; the rows below can be edited.';

  @override
  String serviceDetailsItemsTitle(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Items done on this visit ($countString)';
  }

  @override
  String get serviceDetailsEditItem => 'Edit item';

  @override
  String get serviceDetailsDeleteItem => 'Delete item';

  @override
  String serviceDetailsReminder(String value) {
    return 'Next reminder: $value';
  }

  @override
  String serviceDetailsReminderBoth(int km, String month, String year) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString km ($month $year)';
  }

  @override
  String serviceDetailsReminderDate(String month, String year) {
    return '$month $year';
  }

  @override
  String get serviceDetailsAddItem => 'Add an item to this invoice';

  @override
  String get serviceDetailsInvoiceTitle => 'Invoice / receipt photo';

  @override
  String serviceDetailsInvoiceUploaded(String date) {
    return 'Uploaded on $date';
  }

  @override
  String get serviceDetailsInvoiceView => 'View full size';

  @override
  String get serviceDetailsInvoiceEmpty => 'No invoice photo attached';

  @override
  String get serviceDetailsInvoiceAttach => 'Attach invoice photo';

  @override
  String get serviceDetailsInvoiceLoadError => 'Couldn\'t load the invoice photo';

  @override
  String get serviceDetailsInvoiceSaved => 'Invoice photo attached';

  @override
  String get serviceDetailsInvoiceSaveFailed => 'Couldn\'t upload the invoice photo';

  @override
  String get serviceDetailsTotalTitle => 'Parts and labour total:';

  @override
  String get serviceDetailsTotalLabel => 'Invoice amount:';

  @override
  String get serviceDetailsPdf => 'Download invoice PDF';

  @override
  String get serviceDetailsLoadError => 'Couldn\'t load the invoice';

  @override
  String get serviceDetailsLastItem =>
      'The last item can\'t be removed; delete the whole invoice instead';

  @override
  String serviceDetailsDeleteItemConfirmTitle(String item) {
    return 'Delete “$item”?';
  }

  @override
  String get serviceDetailsDeleteItemConfirmBody =>
      'The item is removed and the total recalculated.';

  @override
  String get serviceDetailsUpdated => 'Invoice updated';

  @override
  String get serviceDetailsUpdateFailed => 'Couldn\'t update the invoice';

  @override
  String get serviceDetailsDeleted => 'Invoice deleted';

  @override
  String get serviceDetailsDeleteFailed => 'Couldn\'t delete the invoice';

  @override
  String get serviceEditorTitleEdit => 'Edit item';

  @override
  String get serviceEditorTitleAdd => 'Add item';

  @override
  String get serviceEditorSave => 'Save item';

  @override
  String get serviceEditorPickItem => 'Pick a service';

  @override
  String get serviceEditorNoItemsLeft => 'Every catalog item is already on this invoice';

  @override
  String get serviceHistoryLoadError => 'Couldn\'t load the service history';

  @override
  String serviceHistoryMore(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'and $countString more';
  }

  @override
  String serviceHistoryAmount(int amount) {
    final intl.NumberFormat amountNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString Toman';
  }

  @override
  String get intervalsTitle => 'Service intervals';

  @override
  String intervalsCurrentMileage(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Current mileage: $kmString km';
  }

  @override
  String get intervalsSourceNote => 'Based on the manufacturer\'s manual';

  @override
  String get intervalsResetAll => 'Reset all';

  @override
  String get intervalsResetAllConfirmTitle => 'Reset every interval?';

  @override
  String get intervalsResetAllConfirmBody =>
      'Every interval goes back to its factory default and custom values are removed.';

  @override
  String get intervalsResetConfirm => 'Reset';

  @override
  String get intervalsRuleTitle => 'Whichever comes first';

  @override
  String get intervalsRuleBody =>
      'Countdowns and replacement alerts follow whichever limit is reached first: the distance driven or the months elapsed.';

  @override
  String intervalsDefault(int km, int months) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String monthsString = monthsNumberFormat.format(months);

    return 'Factory default: $kmString km / $monthsString months';
  }

  @override
  String get intervalsResetRow => 'Reset this item';

  @override
  String get intervalsMonthsUnit => 'months';

  @override
  String intervalsKmError(int min, int max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Enter between $minString and $maxString km';
  }

  @override
  String intervalsMonthsError(int min, int max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Enter between $minString and $maxString months';
  }

  @override
  String get intervalsSave => 'Save settings';

  @override
  String get intervalsSaved => 'Service intervals saved';

  @override
  String get intervalsResetDone => 'Every value is back to the factory default';

  @override
  String get intervalsSaveInvalid => 'The interval values are invalid, please check the fields';

  @override
  String get intervalsSaveFailed => 'Couldn\'t save the settings, please try again';

  @override
  String get intervalsResetFailed => 'Couldn\'t reset, please try again';

  @override
  String get intervalsLoadError => 'Couldn\'t load the service intervals';

  @override
  String get dueTitle => 'Services due';

  @override
  String get dueSubtitle => 'Items that need attention';

  @override
  String get dueSavedTitle => 'Mileage saved';

  @override
  String dueSavedDate(String date) {
    return 'Today, $date';
  }

  @override
  String get dueNewMileageBadge => 'New mileage';

  @override
  String dueDelta(String delta) {
    return '$delta km since the last reading';
  }

  @override
  String get dueNoticeTitle => 'Periodic check needed';

  @override
  String dueNoticeBodyAfterUpdate(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'With this mileage, $countString services are due and need a workshop visit.';
  }

  @override
  String dueNoticeBody(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString services are due and need a workshop visit.';
  }

  @override
  String get dueListTitle => 'Items due';

  @override
  String get dueListBasis => 'By mileage';

  @override
  String get dueStatusOverdue => 'Overdue';

  @override
  String get dueStatusDueSoon => 'Due soon';

  @override
  String get dueStatusUpcoming => 'Notice';

  @override
  String dueOverdueKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString km past due';
  }

  @override
  String dueOverdueDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return '$daysString days past due';
  }

  @override
  String dueSoonKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Only $kmString km left';
  }

  @override
  String dueSoonDays(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return 'Only $daysString days left';
  }

  @override
  String dueUpcomingKm(int km, int months) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String monthsString = monthsNumberFormat.format(months);

    return '$kmString km left (about $monthsString months)';
  }

  @override
  String dueUpcomingDays(int days, int months) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String monthsString = monthsNumberFormat.format(months);

    return '$daysString days left (about $monthsString months)';
  }

  @override
  String dueAtKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Due at: $kmString km';
  }

  @override
  String get dueActionOverdue => 'Record this service invoice';

  @override
  String get dueActionRecord => 'Record this service';

  @override
  String get dueArchiveTitle => 'Invoice archive';

  @override
  String get dueArchiveBody => 'After the service, record the items on one combined invoice.';

  @override
  String get dueConfirmBack => 'Confirm and back to dashboard';

  @override
  String get dueRemindLater => 'Remind me later';

  @override
  String get dueEmpty => 'Every service is on time';

  @override
  String get dueLoadError => 'Couldn\'t load the service status';

  @override
  String get vehicleDetailsDueSettings => 'Adjust';

  @override
  String get serviceSharedCardTitle => 'Shared invoice details';

  @override
  String get serviceSharedCardBody =>
      'The workshop and the invoice photo for every item of this visit';

  @override
  String get fuelPageTitle => 'Record fuel';

  @override
  String fuelLastFillFull(String date, int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Last fill-up: $date • $kmString km (full tank)';
  }

  @override
  String fuelLastFillPartial(String date, int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Last fill-up: $date • $kmString km';
  }

  @override
  String get fuelNoLastFill => 'No fill-up recorded yet';

  @override
  String get fuelDateLabel => 'Fill-up date';

  @override
  String get fuelDateOther => 'Pick another date';

  @override
  String get fuelDatePickTitle => 'Fill-up date (Jalali calendar)';

  @override
  String get fuelTimePickHelp => 'Fill-up time';

  @override
  String get fuelTimeHint => 'Change time';

  @override
  String get fuelOdometerLabel => 'Current odometer';

  @override
  String fuelOdometerPrevious(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Previous reading: $kmString';
  }

  @override
  String fuelOdometerSinceLast(String diff) {
    return '$diff km since the previous tank';
  }

  @override
  String get fuelTypeLabel => 'Fuel type';

  @override
  String get fuelTypeRegular => 'Regular';

  @override
  String get fuelTypeSuper => 'Super';

  @override
  String get fuelTypeCng => 'CNG';

  @override
  String get fuelTypeLpg => 'LPG';

  @override
  String get fuelVolumeLabel => 'Volume';

  @override
  String get fuelUnitLitre => 'L';

  @override
  String get fuelUnitCubicMetre => 'm³';

  @override
  String get fuelTotalCostLabel => 'Total paid';

  @override
  String get fuelRateLabel => 'Computed rate:';

  @override
  String fuelRateValue(int amount, String unit) {
    final intl.NumberFormat amountNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString toman / $unit';
  }

  @override
  String get fuelFullFillTitle => 'Tank filled completely (full tank)';

  @override
  String get fuelFullFillBody => 'Turn this on so the consumption per 100 km can be computed.';

  @override
  String get fuelEconomyTitle => 'Average consumption this period:';

  @override
  String fuelEconomyUnit(String unit) {
    return '$unit per 100 km';
  }

  @override
  String fuelEconomyBreakdown(int km, String volume, String unit) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString km driven on $volume $unit of fuel (since the previous full tank)';
  }

  @override
  String get fuelEconomyDisclaimer => 'Without a full tank the figure would read “not computable”.';

  @override
  String get fuelEconomyUnavailable =>
      'Needs a previous full tank of the same fuel type and a full tank now.';

  @override
  String get fuelStationLabel => 'Station';

  @override
  String get fuelPaymentLabel => 'Payment method and quota';

  @override
  String get fuelPaymentPick => 'Choose a payment method';

  @override
  String get fuelPaymentPersonalFuelCard => 'Station terminal (personal fuel card)';

  @override
  String get fuelPaymentStationFuelCard => 'Station fuel card (free rate)';

  @override
  String get fuelPaymentBankCard => 'Bank card';

  @override
  String get fuelPaymentCash => 'Cash';

  @override
  String get fuelNotesLabel => 'Notes (optional)';

  @override
  String get fuelNotesHint => 'e.g. fuel additive used, pump condition…';

  @override
  String get fuelSubmit => 'Save fill-up';

  @override
  String get fuelCancel => 'Cancel and go back';

  @override
  String get fuelSaved => 'Fill-up saved';

  @override
  String get fuelSaveFailed => 'Couldn\'t save the fill-up';

  @override
  String get fuelSaveInvalid => 'Some values are invalid, check the form';

  @override
  String get fuelDateInFuture => 'The fill-up date and time can\'t be in the future';

  @override
  String fuelVolumeError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Enter the volume (more than 0, at most $maxString)';
  }

  @override
  String get fuelTotalCostError => 'Enter the total paid';

  @override
  String fuelStationError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'The station name is at most $maxString characters';
  }

  @override
  String fuelNotesError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Notes are at most $maxString characters';
  }

  @override
  String get fuelSectionTitle => 'Latest fill-ups';

  @override
  String get fuelSectionEmpty => 'No fill-up recorded for this vehicle yet';

  @override
  String get fuelSectionLoadError => 'Couldn\'t load the fill-ups';

  @override
  String fuelRowTitle(String type, String volume, String unit) {
    return '$type • $volume $unit';
  }

  @override
  String fuelRowEconomy(String economy, String unit) {
    return '$economy $unit/100 km';
  }

  @override
  String get expensePageTitle => 'Record expense';

  @override
  String get expenseManualNotice =>
      'Every entry here is typed in by you; nothing is looked up from external systems.';

  @override
  String get expenseCategoryLabel => 'Expense category';

  @override
  String get expenseCategoryBadge => 'Main category';

  @override
  String get expenseCategoryThirdPartyInsurance => 'Third-party insurance';

  @override
  String get expenseCategoryBodyInsurance => 'Body insurance';

  @override
  String get expenseCategoryFine => 'Traffic fine';

  @override
  String get expenseCategoryToll => 'Tolls and zone permits';

  @override
  String get expenseCategoryInspection => 'Inspection';

  @override
  String get expenseCategoryOther => 'Other expenses';

  @override
  String get expenseAmountLabel => 'Amount paid';

  @override
  String get expenseRequired => 'Required';

  @override
  String get expenseRoundAmount => 'Round';

  @override
  String get expenseTitleLabel => 'Title';

  @override
  String get expenseTitleHint => 'Title or heading';

  @override
  String get expenseReferenceLabel => 'Policy or reference number';

  @override
  String get expenseReferenceHint => 'Optional – serial or reference number';

  @override
  String get expensePaidAtLabel => 'Payment / issue date';

  @override
  String get expenseDatePick => 'Pick a date';

  @override
  String get expensePaidAtPickTitle => 'Payment date (Jalali calendar)';

  @override
  String get expenseExpiryTitle => 'Set the expiry or next renewal';

  @override
  String get expenseExpiryBody => 'For periodic reminders';

  @override
  String expenseExpiryOneYear(String date) {
    return '$date (1 year later)';
  }

  @override
  String get expenseExpiryPick => 'Pick the expiry date';

  @override
  String get expenseExpiryPickTitle => 'Expiry date (Jalali calendar)';

  @override
  String expenseDaysLeft(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$daysString days left',
      one: '1 day left',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String get expenseReminderCheck => 'Send a reminder 7, 15 and 30 days before the date';

  @override
  String get expenseAttachmentLabel => 'Attach the document or receipt';

  @override
  String get expenseAttachmentAttached => '1 file attached';

  @override
  String get expenseAttachmentNone => 'No attachment';

  @override
  String get expenseAttachmentAdd => 'Add a document or receipt';

  @override
  String get expenseAttachmentHelp => 'Allowed: PDF, JPG and PNG up to 10 MB.';

  @override
  String get expenseAttachmentRemove => 'Remove file';

  @override
  String expenseAttachmentMeta(String size, String kind) {
    return '$size • $kind';
  }

  @override
  String get expenseAttachmentPdf => 'PDF document';

  @override
  String get expenseAttachmentImage => 'Image';

  @override
  String get expenseAttachmentPickFailed => 'Couldn\'t pick the file';

  @override
  String get expenseAttachmentInvalid => 'Only PDF, JPG or PNG files are allowed';

  @override
  String expenseAttachmentTooLarge(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'The file is larger than $maxString MB';
  }

  @override
  String get expensePaymentLabel => 'Payment method';

  @override
  String get expensePaymentOnline => 'Online payment';

  @override
  String get expensePaymentPos => 'Card terminal / POS';

  @override
  String get expenseIssuerLabel => 'Issuer or agency';

  @override
  String get expenseIssuerHint => 'Agency or inspection centre name';

  @override
  String get expenseSaved => 'Expense saved';

  @override
  String get expenseSavedAttachmentFailed => 'Expense saved, but the attachment was not';

  @override
  String get expenseSaveFailed => 'Couldn\'t save the expense';

  @override
  String get expenseSaveInvalid => 'Some values are invalid, check the form';

  @override
  String get expenseCategoryError => 'Choose a category';

  @override
  String get expenseAmountError => 'Enter the amount';

  @override
  String expenseTitleError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'The title is at most $maxString characters';
  }

  @override
  String expenseReferenceError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'The number is at most $maxString characters';
  }

  @override
  String get expensePaidAtError => 'The payment date can\'t be in the future';

  @override
  String get expenseExpiresAtError => 'The expiry must be after the payment date';

  @override
  String expenseIssuerError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'The issuer is at most $maxString characters';
  }

  @override
  String get expenseSectionTitle => 'Latest expenses';

  @override
  String get expenseSectionEmpty => 'No expense recorded for this vehicle yet';

  @override
  String get expenseSectionLoadError => 'Couldn\'t load the expenses';

  @override
  String notificationsUnreadLabel(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notifications, $countString unread',
      zero: 'Notifications',
    );
    return '$_temp0';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String notificationsNewCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString new notifications',
      one: '1 new notification',
      zero: 'No new notifications',
    );
    return '$_temp0';
  }

  @override
  String get notificationsReadAll => 'Mark all read';

  @override
  String notificationsFilterAll(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'All ($countString)';
  }

  @override
  String get notificationsFilterService => 'Service & maintenance';

  @override
  String get notificationsFilterDocuments => 'Insurance & documents';

  @override
  String get notificationsFilterSystem => 'System';

  @override
  String get notificationsEmptyTitle => 'No notifications in this category';

  @override
  String get notificationsEmptyBody => 'New events and alerts show up here.';

  @override
  String get notificationsShowAll => 'Show all notifications';

  @override
  String get notificationsRetention => 'Notifications are kept for 90 days';

  @override
  String get notificationsLoadError => 'Couldn\'t load the notifications';

  @override
  String get notificationsActionFailed => 'That didn\'t work, try again';

  @override
  String notificationIntervalTitle(String subject, String vehicle) {
    return '$subject due on $vehicle';
  }

  @override
  String notificationIntervalMileage(int mileage) {
    final intl.NumberFormat mileageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String mileageString = mileageNumberFormat.format(mileage);

    return 'The vehicle has reached $mileageString km.';
  }

  @override
  String notificationIntervalRemaining(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return 'Only $kmString km left until the service.';
  }

  @override
  String notificationIntervalOverdueKm(int km) {
    final intl.NumberFormat kmNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kmString = kmNumberFormat.format(km);

    return '$kmString km past due.';
  }

  @override
  String notificationIntervalDueDate(String date) {
    return 'The service is due on $date.';
  }

  @override
  String notificationIntervalOverdueDate(String date) {
    return 'The service was due on $date.';
  }

  @override
  String get notificationAddService => 'Record service';

  @override
  String notificationExpiryTitle(String subject) {
    return '$subject expiring';
  }

  @override
  String notificationExpiryBody(String subject, String vehicle, int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return '$subject of $vehicle expires in $daysString days.';
  }

  @override
  String notificationExpiredBody(String subject, String vehicle) {
    return '$subject of $vehicle has expired.';
  }

  @override
  String notificationDaysLeft(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return '$daysString days left';
  }

  @override
  String get notificationExpired => 'Expired';

  @override
  String get relativeJustNow => 'Just now';

  @override
  String relativeMinutesAgo(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString min ago';
  }

  @override
  String relativeHoursAgo(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString h ago';
  }

  @override
  String relativeYesterday(String time) {
    return 'Yesterday, $time';
  }

  @override
  String get relativeLastWeek => 'Last week';

  @override
  String get documentsTitle => 'Vehicle documents';

  @override
  String get documentsVehicleSubtitle => 'Documents and renewal reminders';

  @override
  String documentsSecureInfo(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString documents are stored encrypted.',
      one: '1 document is stored encrypted.',
    );
    return '$_temp0';
  }

  @override
  String get documentsUploadTitle => 'Upload a new document';

  @override
  String get documentsUploadBody =>
      'A photo or PDF (vehicle card, insurance, inspection, ownership papers or power of attorney)';

  @override
  String get documentsUploadCamera => 'Camera';

  @override
  String get documentsUploadGallery => 'Gallery';

  @override
  String get documentsUploadPdf => 'PDF file';

  @override
  String documentsFilterAll(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'All ($countString)';
  }

  @override
  String documentsGroupInsurance(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Insurance ($countString)';
  }

  @override
  String documentsGroupInspection(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Inspection ($countString)';
  }

  @override
  String documentsGroupIdentity(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Identity ($countString)';
  }

  @override
  String get documentsEmpty => 'No document saved for this vehicle yet';

  @override
  String get documentsFilterEmpty => 'No document in this group';

  @override
  String get documentsLoadError => 'Couldn\'t load the documents';

  @override
  String get documentTypeThirdPartyInsurance => 'Third-party insurance';

  @override
  String get documentTypeBodyInsurance => 'Body insurance';

  @override
  String get documentTypeInspection => 'Technical inspection';

  @override
  String get documentTypeVehicleCard => 'Vehicle card';

  @override
  String get documentTypeGreenSheet => 'Ownership document';

  @override
  String get documentTypePowerOfAttorney => 'Power of attorney';

  @override
  String documentStatusExpired(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return 'Expired — $daysString days ago';
  }

  @override
  String documentStatusDueSoon(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return 'Due soon — $daysString days left';
  }

  @override
  String documentStatusValid(int days) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);

    return 'Valid — $daysString days left';
  }

  @override
  String get documentStatusPermanent => 'Permanent / no expiry';

  @override
  String documentNumber(String number) {
    return 'No.: $number';
  }

  @override
  String documentIssuedAt(String date) {
    return 'Issued: $date';
  }

  @override
  String documentExpiresAt(String date) {
    return 'Expires: $date';
  }

  @override
  String get documentReminderOn => 'Renewal reminder is on';

  @override
  String get documentViewFile => 'View the file';

  @override
  String get documentRenew => 'Record a renewal';

  @override
  String get documentDetails => 'Details';

  @override
  String documentImageCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString images';
  }

  @override
  String get documentFileOpenFailed => 'Couldn\'t open the file';

  @override
  String get documentFormNewTitle => 'Add document';

  @override
  String get documentFormEditTitle => 'Edit document';

  @override
  String get documentTypeLabel => 'Document type';

  @override
  String get documentTitleLabel => 'Title';

  @override
  String get documentTitleHint => 'e.g. Inspection certificate';

  @override
  String get documentIssuerLabel => 'Issuer';

  @override
  String get documentIssuerHint => 'e.g. Iran Insurance';

  @override
  String get documentNumberLabel => 'Document or policy number';

  @override
  String get documentNumberHint => 'e.g. 124/987432';

  @override
  String get documentIssuedAtLabel => 'Issue date';

  @override
  String get documentIssuedAtPick => 'Pick the issue date';

  @override
  String get documentIssuedAtPickTitle => 'Issue date (Jalali calendar)';

  @override
  String get documentIssuedAtClear => 'Clear the issue date';

  @override
  String get documentNotesLabel => 'Notes';

  @override
  String get documentNotesHint => 'Extra details (optional)';

  @override
  String get documentFilesLabel => 'Document files';

  @override
  String documentFilesCount(int count, int max) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return '$countString of $maxString';
  }

  @override
  String get documentFilesAdd => 'Add a file';

  @override
  String documentFilesHelp(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Up to $maxString PDF, JPG or PNG files, 10 MB each.';
  }

  @override
  String documentFileLimit(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'At most $maxString files per document';
  }

  @override
  String get documentSave => 'Save document';

  @override
  String get documentSaved => 'Document saved';

  @override
  String get documentSavedFilesFailed => 'Document saved, but a file couldn\'t be uploaded';

  @override
  String get documentSaveInvalid => 'Check the document details';

  @override
  String get documentSaveFailed => 'Couldn\'t save the document';

  @override
  String get documentTypeError => 'Choose the document type';

  @override
  String documentTitleError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'The title is at most $maxString characters';
  }

  @override
  String documentIssuerError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'The issuer is at most $maxString characters';
  }

  @override
  String documentNumberError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'The number is at most $maxString characters';
  }

  @override
  String documentNotesError(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Notes are at most $maxString characters';
  }

  @override
  String get documentExpiresAtError => 'Pick an expiry after the issue date';

  @override
  String get documentDelete => 'Delete document';

  @override
  String get documentDeleteConfirmTitle => 'Delete this document?';

  @override
  String get documentDeleteConfirmBody => 'The document and all its files are deleted for good.';

  @override
  String get documentDeleteCancel => 'Cancel';

  @override
  String get documentDeleted => 'Document deleted';

  @override
  String get documentDeleteFailed => 'Couldn\'t delete the document';

  @override
  String get documentFileDeleteFailed => 'Couldn\'t remove the file';

  @override
  String get profileStatDocuments => 'Documents in the wallet';

  @override
  String get reportExportTitle => 'Export report';

  @override
  String get reportScopeTitle => 'Report vehicles';

  @override
  String get reportScopeChangeable => 'Changeable';

  @override
  String reportScopeAll(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'All vehicles ($countString)';
  }

  @override
  String get reportPeriodTitle => 'Report period';

  @override
  String get reportJalaliCalendar => 'Jalali calendar';

  @override
  String get reportPeriodThreeMonths => 'Last 3 months';

  @override
  String get reportPeriodSixMonths => 'Last 6 months';

  @override
  String reportPeriodCurrentYear(String year) {
    return 'This year ($year)';
  }

  @override
  String get reportPeriodAll => 'All records';

  @override
  String get reportFrom => 'From';

  @override
  String get reportTo => 'To';

  @override
  String get reportDateUnset => '—';

  @override
  String get reportContentTitle => 'Report content';

  @override
  String get reportSelectAll => 'Select all';

  @override
  String get reportContentServices => 'Services and repairs';

  @override
  String get reportContentServicesHint => 'Invoices, parts, workshop labour';

  @override
  String get reportContentFuel => 'Fill-ups';

  @override
  String get reportContentFuelHint => 'Litres, cost, stations and average economy';

  @override
  String get reportContentExpenses => 'Other expenses';

  @override
  String get reportContentExpensesHint => 'Insurance, annual toll, fines, inspection';

  @override
  String get reportContentImages => 'Invoice images';

  @override
  String get reportContentImagesHint => 'Append the document images at the end of the PDF';

  @override
  String get reportPreviewTitle => 'Export preview';

  @override
  String get reportPreviewIncludes => 'Includes';

  @override
  String get reportPreviewRecords => 'records';

  @override
  String get reportPreviewTotal => 'Total:';

  @override
  String get reportPreviewError => 'Couldn\'t load the preview';

  @override
  String get reportTooLarge => 'The report range is too large';

  @override
  String get reportNoContent => 'Choose at least one item';

  @override
  String get reportDownloadPdf => 'Download official PDF';

  @override
  String get reportDownloadCsv => 'Download spreadsheet (Excel / CSV)';

  @override
  String get reportPdfDone => 'The official PDF was created.';

  @override
  String get reportCsvDone => 'The spreadsheet is ready.';

  @override
  String get reportExportFailed => 'Couldn\'t create the report file';

  @override
  String get reportToastClose => 'Close';

  @override
  String get reportTypeService => 'Service';

  @override
  String get reportTypeFuel => 'Fuel';

  @override
  String get reportTypeExpense => 'Expense';

  @override
  String get reportColumnDate => 'Date';

  @override
  String get reportColumnVehicle => 'Vehicle';

  @override
  String get reportColumnPlate => 'Plate';

  @override
  String get reportColumnType => 'Type';

  @override
  String get reportColumnDescription => 'Description';

  @override
  String get reportColumnKm => 'Km';

  @override
  String get reportColumnAmount => 'Amount (toman)';

  @override
  String get reportTotalRow => 'Total';

  @override
  String reportPdfRange(String from, String to) {
    return 'Report range: $from to $to';
  }

  @override
  String reportPdfVehicles(String vehicles) {
    return 'Vehicles: $vehicles';
  }

  @override
  String reportPdfGeneratedAt(String date) {
    return 'Generated: $date';
  }

  @override
  String get reportPdfEntryCount => 'Records';

  @override
  String get reportPdfTotalCost => 'Total cost';

  @override
  String get reportPdfServiceCount => 'Services';

  @override
  String get reportPdfFuelVolume => 'Fuel (litres)';

  @override
  String reportPdfToman(String amount) {
    return '$amount toman';
  }

  @override
  String get reportPdfOtherFiles => 'Other attached files';

  @override
  String get plansTitle => 'Subscription and plans';

  @override
  String get plansHeroBadge => 'Transparent, no commitment, cancel any time';

  @override
  String get plansHeroTitle => 'Plans and subscriptions';

  @override
  String get plansHeroBody =>
      'Unlimited tools to track costs and technical records and raise your car\'s value';

  @override
  String get plansMonthly => 'Monthly';

  @override
  String get plansYearly => 'Yearly';

  @override
  String get plansYearlyDiscount => '20% off';

  @override
  String get plansPerMonth => 'toman / month';

  @override
  String get plansPerYear => 'toman / year';

  @override
  String get plansCurrent => 'Your current plan';

  @override
  String get plansBasicTag => 'Standard start';

  @override
  String get plansBasicName => 'Basic (always free)';

  @override
  String get plansBasicFeature1 => 'Up to 1 vehicle in the garage';

  @override
  String get plansBasicFeature2 => 'Unlimited services and fill-ups';

  @override
  String get plansBasicFeature3 => 'In-app reminders (no SMS)';

  @override
  String get plansBasicFeature4 => 'Simple text report export';

  @override
  String get plansProBadge => 'Our pick';

  @override
  String get plansProTag => 'Owners\' favourite';

  @override
  String get plansProName => 'Pro (Plus)';

  @override
  String get plansProMonthlyNote => 'Billed monthly, no commitment';

  @override
  String plansProYearlyNote(String amount) {
    return 'Same as $amount toman a month (20% saving)';
  }

  @override
  String get plansProFeature1 => 'Up to 3 vehicles in one garage';

  @override
  String get plansProFeature2 => 'SMS reminders for insurance, inspection and services';

  @override
  String get plansProFeature3 => 'Vehicle health record export (official PDF and Excel)';

  @override
  String get plansProFeature4 => 'Unlimited document wallet in secure cloud storage';

  @override
  String get plansProFeature5 => 'Hand the service records to the buyer when selling';

  @override
  String get plansProCta => 'Choose and upgrade to Pro';

  @override
  String get plansMasterTag => 'Fleet and family';

  @override
  String get plansMasterName => 'Unlimited garage';

  @override
  String get plansMasterMonthlyNote => 'For collectors and multi-vehicle managers';

  @override
  String plansMasterYearlyNote(String amount) {
    return 'Same as $amount toman a month with full priority';
  }

  @override
  String get plansMasterFeature1 => 'Unlimited vehicles in the main panel';

  @override
  String get plansMasterFeature2 => 'SMS reminders to several numbers (drivers)';

  @override
  String get plansMasterFeature3 => 'Dedicated instant phone support';

  @override
  String get plansMasterFeature4 => 'Full financial export for tax and insurance';

  @override
  String get plansMasterCta => 'Choose the unlimited plan';

  @override
  String get plansGuaranteeTitle => 'Transparency and satisfaction guarantee';

  @override
  String get plansGuaranteeBody =>
      'There is no unwanted auto-renewal. Within 7 days of buying a subscription, if you are not fully satisfied, the payment is refunded to your bank account, no questions asked.';

  @override
  String get plansSecurePayment => 'Secure Shaparak payment gateway';

  @override
  String get plansSupport => 'Support 7 days a week';

  @override
  String get profilePlanTitle => 'Basic plan';

  @override
  String get profilePlanBadge => 'Free';

  @override
  String get profilePlanHint => 'Your current plan • always free';

  @override
  String get profilePlanUpgrade => 'Upgrade or renew';

  @override
  String get vehicleTransfer => 'Transfer ownership';

  @override
  String get transferTitle => 'Transfer vehicle ownership';

  @override
  String get transferActiveInGarage => 'Active in garage';

  @override
  String get transferMileage => 'Current mileage:';

  @override
  String get transferKm => 'km';

  @override
  String get transferPhoneTitle => 'New owner\'s (buyer\'s) mobile number';

  @override
  String get transferPhoneHint =>
      'The request shows up in this number\'s account and completes once the buyer accepts.';

  @override
  String get transferPhoneLabel => 'Buyer\'s mobile number';

  @override
  String get transferPhoneNote =>
      'The new owner needs an account with this mobile number, or has to sign up with it, to see the request.';

  @override
  String get transferItemsTitle => 'What moves to the new owner';

  @override
  String get transferItemServices => 'Full service records and invoices';

  @override
  String get transferItemServicesHint => 'Every workshop visit, the parts used and replaced';

  @override
  String get transferItemIntervals => 'Service intervals and current mileage';

  @override
  String get transferItemIntervalsHint => 'Maintenance intervals: oil, timing belt and filters';

  @override
  String get transferItemDocuments => 'Technical documents and active warranty';

  @override
  String get transferItemDocumentsHint => 'Official invoices and remaining warranty terms';

  @override
  String get transferItemFuel => 'Fuel cost history';

  @override
  String get transferItemFuelHint => 'Average economy per 100 km and the fuel types';

  @override
  String get transferItemPrivate =>
      'The previous owner\'s identity and private documents (not transferred)';

  @override
  String get transferItemPrivateHint =>
      'ID card images, personal ownership papers and bank records are removed automatically.';

  @override
  String get transferRulesTitle => 'Privacy and record-keeping rules';

  @override
  String get transferRulesIntro => 'Once the buyer accepts the transfer:';

  @override
  String get transferRule1 =>
      'This vehicle leaves your garage and you lose all access to it right away.';

  @override
  String get transferRule2 =>
      'Before sending, export a PDF or Excel copy of the records from the «Export report» page if you need one.';

  @override
  String get transferRule2Link => 'Open the report export';

  @override
  String get transferRule3 =>
      'The new owner can never change or delete the records from your ownership.';

  @override
  String get transferConsent =>
      'I confirm the buyer\'s number and hand over full control of the vehicle\'s records and invoices.';

  @override
  String get transferSubmit => 'Confirm and send the transfer request';

  @override
  String get transferBack => 'Cancel and back to the garage';

  @override
  String get transferConfirmTitle => 'Send the transfer request?';

  @override
  String transferConfirmBody(String vehicle, String phone) {
    return '«$vehicle» leaves your garage once the owner of $phone accepts.';
  }

  @override
  String get transferConfirmSend => 'Send request';

  @override
  String get transferSent => 'Transfer request sent';

  @override
  String get transferInvalidPhone => 'The mobile number is not valid';

  @override
  String get transferSelf => 'You can\'t transfer a vehicle to your own number';

  @override
  String get transferAlreadyPending => 'This vehicle already has a pending transfer';

  @override
  String get transferFailed => 'Couldn\'t send the request';

  @override
  String get transferPendingTitle => 'Transfer waiting for the buyer';

  @override
  String transferPendingPhone(String phone) {
    return 'Buyer\'s number: $phone';
  }

  @override
  String transferPendingDate(String date) {
    return 'Sent on: $date';
  }

  @override
  String get transferCancelRequest => 'Cancel request';

  @override
  String get transferCancelled => 'Transfer request cancelled';

  @override
  String get transferCancelFailed => 'Couldn\'t cancel the request';

  @override
  String get transfersLoadError => 'Couldn\'t load the transfer requests';

  @override
  String get incomingTransferTitle => 'Vehicle transfer request';

  @override
  String incomingTransferBody(String sender, String vehicle) {
    return '$sender wants to move «$vehicle» to your garage.';
  }

  @override
  String get incomingTransferUnknownSender => 'A user';

  @override
  String get incomingTransferReview => 'Review';

  @override
  String get incomingTransferSheetTitle => 'Ownership transfer to you';

  @override
  String incomingTransferFrom(String sender) {
    return 'From: $sender';
  }

  @override
  String incomingTransferMileage(String km) {
    return 'Mileage: $km km';
  }

  @override
  String get incomingTransferNote =>
      'Accepting moves the vehicle and its records to your garage. The previous owner\'s records can\'t be edited.';

  @override
  String get incomingTransferAccept => 'Accept';

  @override
  String get incomingTransferReject => 'Reject';

  @override
  String get incomingTransferAccepted => 'The vehicle was added to your garage';

  @override
  String get incomingTransferRejected => 'Transfer request rejected';

  @override
  String get incomingTransferFailed => 'Couldn\'t complete the request';

  @override
  String get recordLockedLabel => 'Previous owner';

  @override
  String get recordLockedHint => 'This record belongs to the previous owner and can\'t be edited';
}
