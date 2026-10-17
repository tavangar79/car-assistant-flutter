import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/auth/domain/entities/auth_failures.dart';
import 'package:car_assistant/features/auth/domain/entities/avatar_file.dart';
import 'package:car_assistant/features/auth/domain/entities/profile_rules.dart';
import 'package:car_assistant/features/auth/domain/entities/user.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/domain/usecases/delete_avatar.dart';
import 'package:car_assistant/features/auth/domain/usecases/upload_avatar.dart';
import 'package:car_assistant/features/auth/domain/usecases/update_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  final user = User(
    id: 'u1',
    phone: '09121234567',
    createdAt: DateTime.utc(2026),
    isProfileComplete: true,
  );
  // Late evening, local time: a UTC comparison could already be "tomorrow".
  final now = DateTime(2026, 10, 17, 23, 30);

  setUpAll(() => registerFallbackValue(DateTime(2000)));
  setUp(() => repository = MockAuthRepository());

  void stubUpdate() => when(
    () => repository.updateProfile(
      firstName: any(named: 'firstName'),
      lastName: any(named: 'lastName'),
      birthDate: any(named: 'birthDate'),
    ),
  ).thenAnswer((_) async => Right(user));

  group('ProfileRules', () {
    test('names are trimmed and 1–50 characters', () {
      expect(ProfileRules.isValidName('  علی '), isTrue);
      expect(ProfileRules.isValidName('   '), isFalse);
      expect(ProfileRules.isValidName('a' * 50), isTrue);
      expect(ProfileRules.isValidName('a' * 51), isFalse);
    });

    test('today (local calendar date) is a valid birth date, tomorrow is not', () {
      expect(ProfileRules.isValidBirthDate(DateTime(2026, 10, 17), now), isTrue);
      expect(ProfileRules.isValidBirthDate(DateTime(2026, 10, 18), now), isFalse);
    });

    test('the birth year must be 1900 or later', () {
      expect(ProfileRules.isValidBirthDate(DateTime(1900), now), isTrue);
      expect(ProfileRules.isValidBirthDate(DateTime(1899, 12, 31), now), isFalse);
    });
  });

  group('UpdateProfile', () {
    UpdateProfile useCase() => UpdateProfile(repository, now: () => now);

    test('sends trimmed names and the birth date', () async {
      stubUpdate();

      final result = await useCase()(
        firstName: ' علی ',
        lastName: 'محمدی  ',
        birthDate: DateTime(1991, 11, 12),
      );

      expect(result, Right<Failure, User>(user));
      verify(
        () => repository.updateProfile(
          firstName: 'علی',
          lastName: 'محمدی',
          birthDate: DateTime(1991, 11, 12),
        ),
      ).called(1);
    });

    test('accepts today and rejects tomorrow with the injected clock', () async {
      stubUpdate();

      final today = await useCase()(
        firstName: 'a',
        lastName: 'b',
        birthDate: DateTime(2026, 10, 17),
      );
      final tomorrow = await useCase()(
        firstName: 'a',
        lastName: 'b',
        birthDate: DateTime(2026, 10, 18),
      );

      expect(today.isRight(), isTrue);
      expect(
        tomorrow,
        const Left<Failure, User>(InvalidProfileFailure(field: ProfileField.birthDate)),
      );
    });

    test('names the first invalid field and does not call the API', () async {
      final cases = {
        ProfileField.firstName: await useCase()(
          firstName: ' ',
          lastName: 'b',
          birthDate: DateTime(1991),
        ),
        ProfileField.lastName: await useCase()(
          firstName: 'a',
          lastName: 'b' * 51,
          birthDate: DateTime(1991),
        ),
        ProfileField.birthDate: await useCase()(firstName: 'a', lastName: 'b', birthDate: null),
      };
      for (final MapEntry(key: field, value: result) in cases.entries) {
        expect(result, Left<Failure, User>(InvalidProfileFailure(field: field)));
      }
      verifyNever(
        () => repository.updateProfile(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          birthDate: any(named: 'birthDate'),
        ),
      );
    });
  });

  group('UploadAvatar', () {
    setUpAll(() => registerFallbackValue(AvatarFile(bytes: Uint8List(1), fileName: 'f')));

    test('uploads a file within the limit', () async {
      final file = AvatarFile(bytes: Uint8List(AvatarFile.maxBytes), fileName: 'me.jpg');
      when(() => repository.uploadAvatar(file)).thenAnswer((_) async => Right(user));

      expect(await UploadAvatar(repository)(file), Right<Failure, User>(user));
    });

    test('refuses an empty or too large file without calling the API', () async {
      final empty = AvatarFile(bytes: Uint8List(0), fileName: 'me.jpg');
      final big = AvatarFile(bytes: Uint8List(AvatarFile.maxBytes + 1), fileName: 'me.jpg');

      expect(
        (await UploadAvatar(repository)(empty)).getLeft().toNullable(),
        isA<InvalidAvatarFailure>(),
      );
      expect(
        await UploadAvatar(repository)(big),
        const Left<Failure, User>(AvatarTooLargeFailure()),
      );
      verifyNever(() => repository.uploadAvatar(any()));
    });
  });

  test('DeleteAvatar removes the photo', () async {
    when(() => repository.deleteAvatar()).thenAnswer((_) async => Right(user));

    expect(await DeleteAvatar(repository)(), Right<Failure, User>(user));
  });
}
