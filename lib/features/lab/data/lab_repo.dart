import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../booking/data/models/appointment_model.dart';

/// Lab-analysis / x-ray history — reuses [TestRequestModel] since these
/// endpoints return the exact same shape as an appointment's nested
/// `test_requests` (see `BookingRepo`), just as a flat, cross-appointment
/// list instead.
class LabRepo {
  LabRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  /// The account's full lab-analysis history, shown on `TestHistoryScreen`.
  Future<List<TestRequestModel>> getAnalysesHistory() async {
    try {
      final response = await _dio.get(ApiEndpoints.analysesHistory);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => TestRequestModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// The account's full x-ray history, shown on `TestHistoryScreen`.
  Future<List<TestRequestModel>> getXraysHistory() async {
    try {
      final response = await _dio.get(ApiEndpoints.xraysHistory);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => TestRequestModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
