import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/splash/presentation/pages/splash_page.dart';
import 'package:car_assistant/features/splash/presentation/providers/splash_providers.dart';
import 'package:car_assistant/core/widgets/grid_background.dart';
import 'package:car_assistant/features/splash/presentation/widgets/splash_emblem.dart';
import 'package:car_assistant/features/splash/presentation/widgets/splash_loading_bar.dart';
import 'package:car_assistant/features/splash/presentation/widgets/version_badge.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const _delay = Duration(seconds: 2);

PackageInfo _packageInfo(String version) => PackageInfo(
  appName: 'car_assistant',
  packageName: 'car_assistant',
  version: version,
  buildNumber: '1',
);

Widget _app({Future<PackageInfo> Function()? packageInfo, Locale locale = const Locale('fa')}) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/home', builder: (context, state) => const Text('home')),
    ],
  );
  final auth = MockAuthRepository();
  when(auth.hasSession).thenAnswer((_) async => false);
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      splashDelayProvider.overrideWithValue(_delay),
      packageInfoProvider.overrideWith(
        (ref) => packageInfo?.call() ?? Future.value(_packageInfo('1.0.0')),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows the design elements', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.byType(GridBackground), findsOneWidget);
    expect(find.byType(SplashEmblem), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(SplashLoadingBar), findsOneWidget);
    expect(find.text('دستیار خودرو'), findsOneWidget);
    expect(find.text('دفترچه اختصاصی'), findsOneWidget);
    expect(find.text('در حال دریافت اطلاعات...'), findsOneWidget);
    expect(find.text('اطلاعات خودرو، همیشه در دسترس شما'), findsOneWidget);

    final title = tester.widget<Text>(find.text('مدیریت خودرو'));
    expect(title.style?.fontWeight, FontWeight.w800);
    expect(title.style?.fontSize, 30);
  });

  testWidgets('shows no offline or local-database claims', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.textContaining('آفلاین'), findsNothing);
    expect(find.textContaining('محلی'), findsNothing);
    expect(find.textContaining('بدون نیاز به اینترنت'), findsNothing);
  });

  testWidgets('shows the app version in Persian digits', (tester) async {
    await tester.pumpWidget(_app(packageInfo: () async => _packageInfo('1.2.30')));
    await tester.pump();

    expect(find.byType(VersionBadge), findsOneWidget);
    expect(find.text('نسخه'), findsOneWidget);
    expect(find.text('۱٫۲٫۳۰'), findsOneWidget);
  });

  testWidgets('renders in Persian (RTL) with the fa locale', (tester) async {
    await tester.pumpWidget(_app(packageInfo: () async => _packageInfo('1.2.30')));
    await tester.pump();

    expect(Directionality.of(tester.element(find.byType(SplashPage))), TextDirection.rtl);
    expect(find.text('مدیریت خودرو'), findsOneWidget);
    expect(find.text('دستیار خودرو'), findsOneWidget);
    expect(find.text('۱٫۲٫۳۰'), findsOneWidget);
  });

  testWidgets('renders in English (LTR) with the en locale', (tester) async {
    await tester.pumpWidget(
      _app(packageInfo: () async => _packageInfo('1.2.30'), locale: const Locale('en')),
    );
    await tester.pump();

    expect(Directionality.of(tester.element(find.byType(SplashPage))), TextDirection.ltr);
    expect(find.text('Car Management'), findsOneWidget);
    expect(find.text('Car Assistant'), findsOneWidget);
    expect(find.text('Your private logbook'), findsOneWidget);
    expect(find.text('Loading your data...'), findsOneWidget);
    expect(find.text("Your car's info, always at hand"), findsOneWidget);
    expect(find.text('Version'), findsOneWidget);
    expect(find.text('1.2.30'), findsOneWidget);
    expect(find.text('مدیریت خودرو'), findsNothing);
  });

  testWidgets('hides the version badge when package info fails', (tester) async {
    await tester.pumpWidget(_app(packageInfo: () => Future.error(Exception('no plugin'))));
    await tester.pump();

    expect(find.byType(VersionBadge), findsNothing);
    expect(find.text('مدیریت خودرو'), findsOneWidget);
  });

  testWidgets('navigates to the home tab after the splash delay', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.pump(_delay - const Duration(milliseconds: 1));
    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('home'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(SplashPage), findsNothing);
    expect(find.text('home'), findsOneWidget);
  });
}
