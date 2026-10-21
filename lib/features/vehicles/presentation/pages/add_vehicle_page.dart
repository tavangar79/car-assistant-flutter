import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/plate.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_color.dart';
import '../../domain/entities/vehicle_draft.dart';
import '../../domain/entities/vehicle_failures.dart';
import '../../domain/entities/vehicle_field.dart';
import '../../domain/entities/vehicle_photo.dart';
import '../../domain/entities/vehicle_rules.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/vehicle_form/catalog_section.dart';
import '../widgets/vehicle_form/color_swatches.dart';
import '../widgets/vehicle_form/default_vehicle_toggle.dart';
import '../widgets/vehicle_form/digits_input_formatter.dart';
import '../widgets/vehicle_form/mileage_field.dart';
import '../widgets/vehicle_form/nickname_field.dart';
import '../widgets/vehicle_form/plate_input.dart';
import '../widgets/vehicle_form/vehicle_form_dock.dart';
import '../widgets/vehicle_form/vehicle_form_intro.dart';
import '../widgets/vehicle_form/vehicle_photo_field.dart';
import '../widgets/vehicle_form/vin_field.dart';
import '../widgets/vehicle_form/year_field.dart';
import '../widgets/vehicle_form/year_picker_sheet.dart';

/// Adds a vehicle to the garage, or edits [vehicle] when it is given (Stitch screen
/// `bfe6315dd49945ce98c66b6d32383bc3`, "افزودن و ویرایش خودرو"). In edit mode the form starts
/// filled with the vehicle (Stitch edit screen `25ad5d184ff94cf2976c21640ca21f1f`): the saved photo
/// can be removed, and the current default vehicle keeps its default switch locked on. On save the
/// garage list is refreshed and the page closes.
class AddVehiclePage extends ConsumerStatefulWidget {
  const AddVehiclePage({super.key, this.vehicle});

  /// The vehicle to edit, or `null` to add a new one.
  final Vehicle? vehicle;

  @override
  ConsumerState<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends ConsumerState<AddVehiclePage> {
  final _nickname = TextEditingController();
  final _plateTwo = TextEditingController();
  final _plateThree = TextEditingController();
  final _plateProvince = TextEditingController();
  final _vin = TextEditingController();
  final _mileage = TextEditingController();
  String? _letter;
  String? _makeId;
  String? _modelId;
  String? _trimId;
  int? _year;
  VehicleColor? _color;
  bool _isDefault = true;
  VehiclePhoto? _photo;

  /// The saved photo was removed; it is deleted on save unless a new [_photo] replaces it.
  bool _savedPhotoRemoved = false;

  /// Fields changed since the last save attempt; their errors are hidden until the next one.
  Set<VehicleField> _edited = {};

  bool _prefilled = false;

  bool get _isEditing => widget.vehicle != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vehicle = widget.vehicle;
    if (vehicle == null || _prefilled) return;
    _prefilled = true;
    _prefill(vehicle, AppLocalizations.of(context).localeName);
  }

  /// Fills the form with [vehicle], digits written like the fields write them.
  void _prefill(Vehicle vehicle, String locale) {
    String digits(String value) => DigitsInputFormatter(locale: locale, maxDigits: 0).format(value);
    _nickname.text = vehicle.nickname;
    _plateTwo.text = digits(vehicle.plate.twoDigits);
    _letter = vehicle.plate.letter;
    _plateThree.text = digits(vehicle.plate.threeDigits);
    _plateProvince.text = digits(vehicle.plate.provinceCode);
    _vin.text = vehicle.vin ?? '';
    _makeId = vehicle.make.id;
    _modelId = vehicle.model.id;
    _trimId = vehicle.trim?.id;
    _year = vehicle.yearJalali;
    _mileage.text = DigitsInputFormatter(
      locale: locale,
      maxDigits: 0,
      grouped: true,
    ).format('${vehicle.mileageKm}');
    _color = vehicle.color;
    _isDefault = vehicle.isDefault;
  }

  @override
  void dispose() {
    for (final controller in [_nickname, _plateTwo, _plateThree, _plateProvince, _vin, _mileage]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _edit(Iterable<VehicleField> fields, [VoidCallback? change]) => setState(() {
    change?.call();
    _edited = {..._edited, ...fields};
  });

  VehicleDraft get _draft {
    final mileage = DigitsInputFormatter.digitsOf(_mileage.text);
    return VehicleDraft(
      nickname: _nickname.text,
      plate: Plate(
        twoDigits: DigitsInputFormatter.digitsOf(_plateTwo.text),
        letter: _letter ?? '',
        threeDigits: DigitsInputFormatter.digitsOf(_plateThree.text),
        provinceCode: DigitsInputFormatter.digitsOf(_plateProvince.text),
      ),
      vin: _vin.text,
      makeId: _makeId,
      modelId: _modelId,
      trimId: _trimId,
      yearJalali: _year,
      mileageKm: mileage.isEmpty ? null : int.parse(mileage),
      color: _color,
      isDefault: _isDefault,
    );
  }

  Future<void> _pickYear() async {
    final current = ref.read(currentJalaliYearProvider);
    final picked = await YearPickerSheet.show(
      context,
      initial: _year ?? current,
      first: VehicleRules.minYear,
      last: VehicleRules.maxYear(current),
    );
    if (picked == null || !mounted) return;
    _edit([VehicleField.year], () => _year = picked);
  }

  Future<void> _save() async {
    if (ref.read(addVehicleControllerProvider).isLoading) return;
    setState(() => _edited = {});
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final result = await ref
        .read(addVehicleControllerProvider.notifier)
        .save(
          _draft,
          photo: _photo,
          vehicleId: widget.vehicle?.id,
          removePhoto: _savedPhotoRemoved,
        );
    if (!mounted) return;
    if (result == null) {
      final failure = ref.read(addVehicleControllerProvider).error;
      messenger.showSnackBar(SnackBar(content: Text(_saveErrorMessage(failure, l10n))));
      return;
    }
    final photoFailed = result.photoFailure != null;
    final message = switch ((_isEditing, photoFailed)) {
      (false, false) => l10n.vehicleAdded,
      (false, true) => l10n.vehicleAddedPhotoFailed,
      (true, false) => l10n.vehicleUpdated,
      (true, true) => l10n.vehicleUpdatedPhotoFailed,
    };
    messenger.showSnackBar(SnackBar(content: Text(message)));
    navigator.maybePop();
  }

  static String _saveErrorMessage(Object? failure, AppLocalizations l10n) => switch (failure) {
    VehicleRejectedFailure() => l10n.vehicleDefaultLocked,
    InvalidVehicleFailure() ||
    PlateTakenFailure() ||
    InvalidVehiclePhotoFailure() ||
    VehiclePhotoTooLargeFailure() => l10n.vehicleSaveInvalid,
    _ => l10n.vehicleSaveFailed,
  };

  /// The localized error to show on [field], if the last save failed because of it.
  String? _errorOf(VehicleField field, Failure? failure, AppLocalizations l10n) {
    if (_edited.contains(field)) return null;
    return switch (failure) {
      PlateTakenFailure() when field == VehicleField.plate => l10n.vehiclePlateTaken,
      VehiclePhotoTooLargeFailure() when field == VehicleField.photo => l10n.vehiclePhotoTooLarge(
        VehiclePhoto.maxMegabytes,
      ),
      InvalidVehiclePhotoFailure() when field == VehicleField.photo => l10n.vehiclePhotoInvalid,
      InvalidVehicleFailure(:final fields) when fields.contains(field) => _invalidMessage(
        field,
        l10n,
      ),
      _ => null,
    };
  }

  static String _invalidMessage(VehicleField field, AppLocalizations l10n) => switch (field) {
    VehicleField.nickname => l10n.vehicleNicknameError(VehicleRules.nicknameMaxLength),
    VehicleField.plate => l10n.vehiclePlateError,
    VehicleField.vin => l10n.vehicleVinError(VehicleRules.vinLength),
    VehicleField.make => l10n.vehicleMakeError,
    VehicleField.model => l10n.vehicleModelError,
    VehicleField.trim => l10n.vehicleTrimError,
    VehicleField.year => l10n.vehicleYearError,
    VehicleField.mileage => l10n.vehicleMileageError(VehicleRules.maxMileageKm),
    VehicleField.color => l10n.vehicleColorError,
    VehicleField.photo => l10n.vehiclePhotoInvalid,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(addVehicleControllerProvider);
    final lastError = state.isLoading ? null : state.error;
    final failure = lastError is Failure ? lastError : null;
    String? error(VehicleField field) => _errorOf(field, failure, l10n);
    const gap = SizedBox(height: 24);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        scrolledUnderElevation: 1,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.04),
        leading: IconButton(
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: Text(
          _isEditing ? l10n.editVehicle : l10n.addVehicle,
          style: theme.textTheme.headlineMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const VehicleFormIntro(),
          gap,
          VehiclePhotoField(
            photo: _photo,
            photoUrl: _savedPhotoRemoved ? null : widget.vehicle?.photoUrl,
            error: error(VehicleField.photo),
            onChanged: (photo) => _edit([VehicleField.photo], () {
              _photo = photo;
              if (photo == null && widget.vehicle?.photoUrl != null) _savedPhotoRemoved = true;
            }),
          ),
          gap,
          NicknameField(
            controller: _nickname,
            error: error(VehicleField.nickname),
            onChanged: (_) => _edit([VehicleField.nickname]),
          ),
          gap,
          PlateInput(
            twoDigits: _plateTwo,
            letter: _letter,
            threeDigits: _plateThree,
            provinceCode: _plateProvince,
            error: error(VehicleField.plate),
            onChanged: () => _edit([VehicleField.plate]),
            onLetterChanged: (letter) => _edit([VehicleField.plate], () => _letter = letter),
          ),
          gap,
          VinField(
            controller: _vin,
            error: error(VehicleField.vin),
            onChanged: (_) => _edit([VehicleField.vin]),
          ),
          gap,
          CatalogSection(
            catalog: ref.watch(vehicleCatalogProvider),
            makeId: _makeId,
            modelId: _modelId,
            trimId: _trimId,
            makeError: error(VehicleField.make),
            modelError: error(VehicleField.model),
            trimError: error(VehicleField.trim),
            onRetry: () => ref.invalidate(vehicleCatalogProvider),
            onMakeChanged: (id) =>
                _edit([VehicleField.make, VehicleField.model, VehicleField.trim], () {
                  _makeId = id;
                  _modelId = null;
                  _trimId = null;
                }),
            onModelChanged: (id) => _edit([VehicleField.model, VehicleField.trim], () {
              _modelId = id;
              _trimId = null;
            }),
            onTrimChanged: (id) => _edit([VehicleField.trim], () => _trimId = id),
          ),
          gap,
          YearField(year: _year, onTap: _pickYear, error: error(VehicleField.year)),
          gap,
          MileageField(
            controller: _mileage,
            error: error(VehicleField.mileage),
            onChanged: (_) => _edit([VehicleField.mileage]),
          ),
          gap,
          ColorSwatches(
            selected: _color,
            error: error(VehicleField.color),
            onChanged: (color) => _edit([VehicleField.color], () => _color = color),
          ),
          gap,
          DefaultVehicleToggle(
            value: _isDefault,
            locked: widget.vehicle?.isDefault ?? false,
            onChanged: (value) => setState(() => _isDefault = value),
          ),
        ],
      ),
      bottomNavigationBar: VehicleFormDock(
        submitLabel: _isEditing ? l10n.vehicleSaveChanges : l10n.vehicleSave,
        saving: state.isLoading,
        onSubmit: _save,
        onCancel: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}
