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
}
