import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// How long the splash screen stays before moving on.
final splashDelayProvider = Provider<Duration>((ref) => const Duration(seconds: 2));

final packageInfoProvider = FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

/// The raw app version, e.g. `1.0.0`. Widgets format it for the current locale.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await ref.watch(packageInfoProvider.future);
  return info.version;
});
