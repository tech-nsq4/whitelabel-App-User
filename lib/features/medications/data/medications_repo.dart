import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../booking/data/models/appointment_model.dart';

/// Reuses [PrescriptionModel] since `/prescriptions/history` returns the
/// exact same shape as an appointment's nested `prescriptions` (see
/// `BookingRepo`), just as a flat, cross-appointment list instead.
class MedicationsRepo {
  MedicationsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  /// The account's full prescription/medication history, shown on
  /// `MedicationsScreen`.
  Future<List<PrescriptionModel>> getPrescriptionsHistory() async {
    try {
      final response = await _dio.get(ApiEndpoints.prescriptionsHistory);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
