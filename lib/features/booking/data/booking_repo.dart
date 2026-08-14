import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/appointment_model.dart';
import 'models/doctor_profile_model.dart';
import 'models/doctor_time_table_model.dart';
import 'models/specialization_model.dart';

class BookingRepo {
  BookingRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  /// The specialties tree shown on `SpecsScreen` — top-level specializations,
  /// each optionally carrying its own sub-specializations.
  Future<List<SpecializationModel>> getSpecializations() async {
    try {
      final response = await _dio.get(ApiEndpoints.specializations);
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Doctors, optionally filtered by [specializationId]/[clinicId]/[name],
  /// or sorted nearest-first when [lat]/[lng] are given.
  Future<List<DoctorProfileModel>> getDoctors({
    int? specializationId,
    int? clinicId,
    String? name,
    double? lat,
    double? lng,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.doctors,
        queryParameters: {
          if (specializationId != null) 'specialization_id': specializationId,
          if (clinicId != null) 'clinic_id': clinicId,
          if (name != null && name.isNotEmpty) 'name': name,
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
        },
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => DoctorProfileModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// A single doctor's full profile, shown on `DoctorScreen`.
  Future<DoctorProfileModel> getDoctorById(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.doctorDetails(id));
      return DoctorProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// The clinics/branches list shown on `BranchesScreen` — reuses
  /// [DoctorClinicModel] since `/branches` returns the exact same shape as
  /// a doctor's `clinic`.
  Future<List<DoctorClinicModel>> getBranches() async {
    try {
      final response = await _dio.get(ApiEndpoints.branches);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => DoctorClinicModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// A doctor's recurring weekly schedule(s), for the calendar/time picker
  /// on `BookingSlotsSheet`.
  Future<List<DoctorTimeTableModel>> getDoctorTimeTables(int doctorId) async {
    try {
      final response = await _dio.get(ApiEndpoints.doctorTimeTables(doctorId));
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => DoctorTimeTableModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Books the [date]/[shiftId]/[times] slot picked on `BookingSlotsSheet`.
  /// [familyMemberId] is `null` when booking for the account holder.
  Future<AppointmentModel> createAppointment({
    required int doctorId,
    required int timeTableId,
    required int scheduleId,
    required String shiftId,
    required String times,
    required DateTime date,
    int? familyMemberId,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.appointments, data: {
        'doctor_id': doctorId,
        'time_table_id': timeTableId,
        'schedule_id': scheduleId,
        'shift_id': shiftId,
        'times': times,
        'date': _formatApiDate(date),
        'family_member_id': familyMemberId,
      });
      return AppointmentModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// The account's booked appointments — powers the home screen's
  /// "upcoming appointment" card.
  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _dio.get(ApiEndpoints.appointments);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// A single appointment's full details, shown on `AppointmentDetailScreen`.
  Future<AppointmentModel> getAppointmentById(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.appointmentDetails(id));
      return AppointmentModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// "2026-08-17" — locale-independent, unlike `DateFormat`.
  String _formatApiDate(DateTime date) {
    String pad2(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${pad2(date.month)}-${pad2(date.day)}';
  }
}
