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
  String vehicleTileSubtitle(String make, String model, String plate) {
    return '$make $model • $plate';
  }

  @override
  String get vehiclePlateLetterHint => 'Letter';
}
