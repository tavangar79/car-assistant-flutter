import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:car_assistant/features/notifications/data/models/notification_dto.dart';
import 'package:car_assistant/features/notifications/data/models/notification_inbox_dto.dart';
import 'package:car_assistant/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:car_assistant/features/notifications/domain/entities/notification_inbox.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../notification_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('DTOs', () {
    test('NotificationDto parses the contract sample', () {
      expect(NotificationDto.fromJson(intervalJson()).toEntity(), intervalNotification());
    });

    test('NotificationDto parses an expiry reminder with null interval fields', () {
      expect(
        NotificationDto.fromJson(documentExpiryJson()).toEntity(),
        documentExpiryNotification(),
      );
    });

    test('NotificationInboxDto parses the list and the unread count', () {
      final inbox = NotificationInboxDto.fromJson({
        'notifications': [intervalJson(), documentExpiryJson()],
        'unreadCount': 2,
      }).toEntity();

      expect(
        inbox,
        NotificationInbox(
          notifications: [intervalNotification(), documentExpiryNotification()],
          unreadCount: 2,
        ),
      );
    });
  });

  group('NotificationRepositoryImpl', () {
    late MockDio dio;
    late NotificationRepositoryImpl repository;

    setUp(() {
      dio = MockDio();
      repository = NotificationRepositoryImpl(NotificationRemoteDataSource(dio));
    });

    Response<T> ok<T>(T data) =>
        Response(requestOptions: RequestOptions(), statusCode: 200, data: data);

    test('getNotifications maps the inbox', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/notifications')).thenAnswer(
        (_) async => ok({
          'notifications': [intervalJson()],
          'unreadCount': 1,
        }),
      );

      expect(
        (await repository.getNotifications()).toNullable(),
        NotificationInbox(notifications: [intervalNotification()], unreadCount: 1),
      );
    });

    test('getUnreadCount reads the badge count', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/notifications/unread-count'))
          .thenAnswer((_) async => ok({'unreadCount': 3}));

      expect(await repository.getUnreadCount(), const Right<Failure, int>(3));
    });

    test('markRead patches the notification and maps it', () async {
      when(() => dio.patch<Map<String, dynamic>>('/api/notifications/n1/read'))
          .thenAnswer((_) async => ok({'notification': intervalJson(read: true)}));

      expect((await repository.markRead('n1')).toNullable(), intervalNotification(read: true));
    });

    test('markAllRead returns the updated count', () async {
      when(() => dio.post<Map<String, dynamic>>('/api/notifications/read-all'))
          .thenAnswer((_) async => ok({'updatedCount': 2}));

      expect(await repository.markAllRead(), const Right<Failure, int>(2));
    });

    test('a 404 becomes a Failure', () async {
      when(() => dio.patch<Map<String, dynamic>>(any())).thenAnswer(
        (_) => Future.error(
          DioException.badResponse(
            statusCode: 404,
            requestOptions: RequestOptions(),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 404,
              data: {
                'error': {'message': 'Notification not found'},
              },
            ),
          ),
        ),
      );

      expect((await repository.markRead('x')).isLeft(), isTrue);
    });

    test('a connection error becomes NetworkFailure', () async {
      when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
        ),
      );

      expect(await repository.getUnreadCount(), const Left<Failure, int>(NetworkFailure()));
    });
  });
}
