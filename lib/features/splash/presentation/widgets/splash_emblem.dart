import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../l10n/app_localizations.dart';

/// App logo inside a rounded tile with a soft amber glow behind it.
class SplashEmblem extends StatelessWidget {
  const SplashEmblem({super.key});

  static const logoAsset = 'assets/images/logo.svg';
  static const _size = 112.0;
  static const _radius = BorderRadius.all(Radius.circular(24));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          left: -8,
          top: -8,
          right: -8,
          bottom: -8,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24, tileMode: TileMode.decal),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.15),
                borderRadius: _radius,
              ),
            ),
          ),
        ),
        Container(
          width: _size,
          height: _size,
          padding: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: scheme.surfaceContainer.withValues(alpha: 0.9),
            borderRadius: _radius,
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.25),
                offset: const Offset(0, 25),
                blurRadius: 50,
                spreadRadius: -12,
              ),
            ],
          ),
          child: SvgPicture.asset(
            logoAsset,
            semanticsLabel: AppLocalizations.of(context).splashLogoLabel,
          ),
        ),
      ],
    );
  }
}
