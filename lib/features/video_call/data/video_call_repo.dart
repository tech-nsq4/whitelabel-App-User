import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/appointment_call_model.dart';

class VideoCallRepo {
  VideoCallRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<AppointmentCallModel?> getCall(int appointmentId) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.appointmentDetails(appointmentId));
      return AppointmentCallModel.maybeFromJson(response.data['data']['call']);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> joinCall(int appointmentId) async {
    try {
      await _dio.post(ApiEndpoints.appointmentCallJoin(appointmentId));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
