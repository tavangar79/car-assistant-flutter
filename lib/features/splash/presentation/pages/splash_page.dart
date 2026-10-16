import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/splash_providers.dart';
import '../widgets/grid_background.dart';
import '../widgets/splash_emblem.dart';
import '../widgets/splash_loading_bar.dart';
import '../widgets/version_badge.dart';

/// Branded launch screen. Moves to the vehicles page after [splashDelayProvider].
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(ref.read(splashDelayProvider), () {
      if (mounted) context.go(AppRoutes.vehiclesPath);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GridBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(),
                Expanded(child: Center(child: _Brand())),
                _Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Opacity(
        opacity: 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.appTitle, style: style.copyWith(letterSpacing: 0.3)),
            Text(l10n.splashTagline, style: style.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SplashEmblem(),
          const SizedBox(height: 32),
          Text(
            l10n.splashHeadline,
            textAlign: TextAlign.center,
            style: text.displayLarge!.copyWith(
              fontSize: 30,
              height: 36 / 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.75,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              l10n.splashDescription,
              textAlign: TextAlign.center,
              style: text.bodyMedium!.copyWith(height: 1.625, color: scheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 192,
            child: Column(
              children: [
                const SplashLoadingBar(),
                const SizedBox(height: 12),
                Text(
                  l10n.splashLoading,
                  style: text.bodySmall!.copyWith(
                    height: 16 / 12,
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.66), // slate-500 on navy
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends ConsumerWidget {
  const _Footer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ref
              .watch(appVersionProvider)
              .when(
                data: (version) => VersionBadge(version: version),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).splashFooter,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 11,
              height: 1.5,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.44), // slate-600 on navy
            ),
          ),
        ],
      ),
    );
  }
}
