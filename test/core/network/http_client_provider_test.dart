import 'package:car_assistant/core/network/http_client_provider.dart';
import 'package:car_assistant/core/storage/token_storage_provider.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_providers.dart';
import 'package:car_assistant/features/auth/presentation/providers/auth_status_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../helpers/fake_token_storage.dart';

void main() {
  test('a 401 on an authenticated call clears the token and signs out', () async {
    final storage = FakeTokenStorage('expired');
    final container = ProviderContainer.test(
      overrides: [
        tokenStorageProvider.overrideWithValue(storage),
        httpClientProvider.overrideWithValue(MockClient((_) async => http.Response('', 401))),
      ],
    );
    container.read(authStatusProvider.notifier).markSignedIn();

    await container.read(authenticatedHttpClientProvider).get(Uri.parse('http://api.test/x'));
    await pumpEventQueue();

    expect(container.read(authStatusProvider), AuthStatus.signedOut);
    expect(storage.token, isNull);
  });
}
