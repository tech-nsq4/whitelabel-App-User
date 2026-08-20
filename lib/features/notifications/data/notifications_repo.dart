import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/notification_model.dart';

class NotificationsRepo {
  NotificationsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  /// The account's notifications feed, shown on `NotificationsScreen`.
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get(ApiEndpoints.notifications);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// The account's unread notifications count, for the bell badge on
  /// `HomeHeader`.
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get(ApiEndpoints.notificationsUnreadCount);
      final data = response.data['data'] as Map<String, dynamic>;
      return (data['unread_count'] as num?)?.toInt() ?? 0;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Marks every notification as read.
  Future<void> markAllAsRead() async {
    try {
      await _dio.post(ApiEndpoints.notificationsReadAll);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Marks a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.post(ApiEndpoints.notificationRead(notificationId));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
