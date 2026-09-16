import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/splash_item_model.dart';

class OnboardingRepo {
  OnboardingRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<SplashItemModel>> getSplashes() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.splashes,
        options: Options(
          receiveTimeout: const Duration(seconds: 6),
          sendTimeout: const Duration(seconds: 6),
        ),
      );
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data.map((e) => SplashItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
