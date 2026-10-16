import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../storage/token_storage_provider.dart';
import 'authenticated_client.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// Use for API calls: attaches the stored bearer token when there is one, and signs the user out
/// when the server rejects it (401).
final authenticatedHttpClientProvider = Provider<http.Client>((ref) {
  return AuthenticatedClient(
    inner: ref.watch(httpClientProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
    onUnauthorized: () {
      if (ref.mounted) ref.read(authStatusProvider.notifier).handleUnauthorized();
    },
  );
});
