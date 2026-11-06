import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/pages/blocked_page.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const _message = 'حساب کاربری شما مسدود شده است. با پشتیبانی تماس بگیرید.';

void main() {
  late MockAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockAuthRepository();
    when(() => repository.clearSession()).thenAnswer((_) async => const Right(unit));
  });

  Future<void> pumpPage(WidgetTester tester, {String? message}) async {
    container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    if (message != null) await container.read(authStatusProvider.notifier).handleBlocked(message);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('fa'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const BlockedPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the icon, the title, the server message and one 64dp action', (tester) async {
    await pumpPage(tester, message: 'پیام سرور');

    expect(find.byIcon(Icons.block), findsOneWidget);
    expect(find.text('حساب مسدود شده'), findsOneWidget);
    expect(find.text('پیام سرور'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.text('بازگشت به ورود'), findsOneWidget);
    expect(tester.getSize(find.byType(FilledButton)).height, greaterThanOrEqualTo(64));
  });

  testWidgets('falls back to the localized message when the server sent none', (tester) async {
    await pumpPage(tester);

    expect(find.text(_message), findsOneWidget);
  });

  testWidgets('back to sign in leaves the blocked state', (tester) async {
    await pumpPage(tester, message: _message);
    expect(container.read(authStatusProvider), AuthStatus.blocked);

    await tester.tap(find.text('بازگشت به ورود'));
    await tester.pump();

    expect(container.read(authStatusProvider), AuthStatus.signedOut);
    expect(container.read(blockedMessageProvider), isNull);
  });
}
