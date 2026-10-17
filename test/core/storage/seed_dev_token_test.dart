import 'package:car_assistant/core/storage/seed_dev_token.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_token_storage.dart';

void main() {
  test('stores the dev token in debug when it is set', () async {
    final storage = FakeTokenStorage();

    await seedDevToken(storage, token: 'dev-jwt', debug: true);

    expect(storage.token, 'dev-jwt');
  });

  test('does nothing in debug when the token is empty', () async {
    final storage = FakeTokenStorage('existing');

    await seedDevToken(storage, token: '', debug: true);

    expect(storage.token, 'existing');
  });

  test('does nothing outside debug builds', () async {
    final storage = FakeTokenStorage();

    await seedDevToken(storage, token: 'dev-jwt', debug: false);

    expect(storage.token, isNull);
  });
}
