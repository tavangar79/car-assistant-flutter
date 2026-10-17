import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/auth_failures.dart';
import '../../domain/entities/profile_rules.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_error_text.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/avatar_section.dart';
import '../widgets/birth_date_field.dart';
import '../widgets/bottom_action_dock.dart';
import '../widgets/complete_profile_top_bar.dart';
import '../widgets/jalali_date_picker_sheet.dart';
import '../widgets/primary_cta_button.dart';
import '../widgets/privacy_note_card.dart';
import '../widgets/profile_name_field.dart';
import '../widgets/verified_phone_row.dart';

/// First name, last name and Jalali birth date (Stitch screen `9edba1ec1db3440eaf7e7b04d108dffa`).
/// Shown while the signed-in user's profile is incomplete; on save the router guard moves on to
/// the home tab.
class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  ConsumerState<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  DateTime? _birthDate;

  /// Fields that failed the client check on the last submit; cleared as the user edits them.
  Set<ProfileField> _invalid = {};

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _firstName = TextEditingController(text: user?.firstName ?? '');
    _lastName = TextEditingController(text: user?.lastName ?? '');
    _birthDate = user?.birthDate;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Rebuilds for the initials, and clears the field's error.
  void _edited(ProfileField field) => setState(() => _invalid = {..._invalid}..remove(field));

  /// `علی` + `محمدی` → `ع.م`.
  String get _initials => [
    _firstName.text.trim(),
    _lastName.text.trim(),
  ].where((name) => name.isNotEmpty).map((name) => name[0]).join('.');

  Future<void> _pickBirthDate() async {
    final today = _today;
    final picked = await JalaliDatePickerSheet.show(
      context,
      initial: _birthDate ?? DateTime(today.year - 30, today.month, today.day),
      first: DateTime(ProfileRules.minBirthYear),
      last: today,
    );
    if (picked == null || !mounted) return;
    setState(() => _birthDate = picked);
    _edited(ProfileField.birthDate);
  }

  Future<void> _save() async {
    if (ref.read(completeProfileControllerProvider).isLoading) return;
    final birthDate = _birthDate;
    setState(() {
      _invalid = {
        if (!ProfileRules.isValidName(_firstName.text)) ProfileField.firstName,
        if (!ProfileRules.isValidName(_lastName.text)) ProfileField.lastName,
        if (birthDate == null || !ProfileRules.isValidBirthDate(birthDate, _today))
          ProfileField.birthDate,
      };
    });
    if (_invalid.isNotEmpty) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(completeProfileControllerProvider.notifier)
        .save(firstName: _firstName.text, lastName: _lastName.text, birthDate: birthDate);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(completeProfileControllerProvider);
    final phone = ref.watch(currentUserProvider)?.phone;
    final failure = state.hasError ? state.error : null;
    final failedField = failure is InvalidProfileFailure ? failure.field : null;
    bool invalid(ProfileField field) => _invalid.contains(field) || failedField == field;
    final generalError = switch (failure) {
      null => null,
      InvalidProfileFailure(field: null) => l10n.profileSaveInvalid,
      InvalidProfileFailure() => null,
      _ => l10n.authGenericError,
    };
    return AuthScaffold(
      body: Column(
        children: [
          const CompleteProfileTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Intro(),
                  const SizedBox(height: 24),
                  Center(child: AvatarSection(initials: _initials)),
                  const SizedBox(height: 24),
                  ProfileNameField(
                    label: l10n.profileFirstNameLabel,
                    hint: l10n.profileFirstNameHint,
                    icon: Icons.person_outline,
                    controller: _firstName,
                    onChanged: (_) => _edited(ProfileField.firstName),
                    error: invalid(ProfileField.firstName) ? l10n.profileFirstNameError : null,
                  ),
                  const SizedBox(height: 16),
                  ProfileNameField(
                    label: l10n.profileLastNameLabel,
                    hint: l10n.profileLastNameHint,
                    icon: Icons.badge_outlined,
                    controller: _lastName,
                    onChanged: (_) => _edited(ProfileField.lastName),
                    error: invalid(ProfileField.lastName) ? l10n.profileLastNameError : null,
                  ),
                  const SizedBox(height: 16),
                  BirthDateField(
                    date: _birthDate,
                    onTap: _pickBirthDate,
                    error: invalid(ProfileField.birthDate) ? l10n.profileBirthDateError : null,
                  ),
                  if (phone != null) ...[
                    const SizedBox(height: 16),
                    VerifiedPhoneRow(phone: phone),
                  ],
                  const SizedBox(height: 24),
                  const PrivacyNoteCard(),
                  if (generalError != null) ...[
                    const SizedBox(height: 16),
                    AuthErrorText(generalError),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      dock: BottomActionDock(
        child: PrimaryCtaButton(
          label: l10n.profileSave,
          icon: Icons.done,
          loading: state.isLoading,
          onPressed: _save,
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.profileDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: AppTones.of(context).muted,
          ),
        ),
      ],
    );
  }
}
