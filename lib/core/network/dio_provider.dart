import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../config/app_config.dart';
import '../storage/token_storage_provider.dart';
import 'auth_interceptor.dart';

/// The app's single [Dio]: JSON against [AppConfig.apiBaseUrl], with the bearer token attached.
/// A rejected token (401) signs the user out.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      contentType: Headers.jsonContentType,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: ref.watch(tokenStorageProvider),
      onUnauthorized: () {
        if (ref.mounted) ref.read(authStatusProvider.notifier).handleUnauthorized();
      },
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});
