import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'secure_token_storage.dart';
import 'token_storage.dart';

/// Override with a fake in tests.
final tokenStorageProvider = Provider<TokenStorage>((ref) => const SecureTokenStorage());
