import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/payments_summary_model.dart';

class PaymentsRepo {
  PaymentsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<PaymentsSummaryModel> getPayments() async {
    try {
      final response = await _dio.get(ApiEndpoints.payments);
      return PaymentsSummaryModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
