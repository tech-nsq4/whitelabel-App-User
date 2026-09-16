import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/banner_model.dart';

class BannersRepo {
  BannersRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await _dio.get(ApiEndpoints.banners);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
