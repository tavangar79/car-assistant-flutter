import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/storage/secure_token_storage.dart';
import 'core/storage/seed_dev_token.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Before the splash checks the session, so a debug DEV_TOKEN signs the app in.
  await seedDevToken(const SecureTokenStorage());
  runApp(const ProviderScope(child: CarAssistantApp()));
}
