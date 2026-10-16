import 'package:car_assistant/core/storage/token_storage.dart';

/// In-memory [TokenStorage] for tests. Set [failRead] / [failClear] to simulate a broken keystore.
class FakeTokenStorage implements TokenStorage {
  FakeTokenStorage([this.token]);

  String? token;
  bool failRead = false;
  bool failClear = false;
  int clearCalls = 0;

  @override
  Future<String?> read() async {
    if (failRead) throw Exception('keystore read failed');
    return token;
  }

  @override
  Future<void> write(String token) async => this.token = token;

  @override
  Future<void> clear() async {
    clearCalls++;
    if (failClear) throw Exception('keystore delete failed');
    token = null;
  }
}
