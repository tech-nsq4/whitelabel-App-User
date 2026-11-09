import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/home_visit_area_model.dart';
import 'models/home_visit_city_model.dart';

class HomeVisitRepo {
  HomeVisitRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<HomeVisitCityModel>> getCities() async {
    try {
      final response = await _dio.get(ApiEndpoints.cities);
      final data = response.data['data'] as List<dynamic>? ?? const [];
      return data.whereType<Map<String, dynamic>>().map(HomeVisitCityModel.fromJson).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<List<HomeVisitAreaModel>> getAreas(int cityId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.areas,
        queryParameters: {'city_id': cityId},
      );
      return HomeVisitAreaModel.listFromJson(response.data['data']);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
