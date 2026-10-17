import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import 'token_storage.dart';

/// Debug builds only: stores [token] (the `DEV_TOKEN` define) so the app opens signed in as that user.
/// Does nothing in release/profile builds or when no token is defined.
Future<void> seedDevToken(
  TokenStorage storage, {
  String token = AppConfig.devToken,
  bool debug = kDebugMode,
}) async {
  if (!debug || token.isEmpty) return;
  await storage.write(token);
}
