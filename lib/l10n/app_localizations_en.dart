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
}
