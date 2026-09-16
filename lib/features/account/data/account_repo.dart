import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/contact_info_model.dart';

class AccountRepo {
  AccountRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<ContactInfoModel> getContactInfo() async {
    try {
      final response = await _dio.get(ApiEndpoints.contactInfo);
      return ContactInfoModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> sendContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      await _dio.post(ApiEndpoints.contactMessages, data: {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
      });
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
