import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/content_page_model.dart';

class PagesRepo {
  PagesRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<ContentPageModel> getPage(String slug) async {
    try {
      final response = await _dio.get(ApiEndpoints.page(slug));
      return ContentPageModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
