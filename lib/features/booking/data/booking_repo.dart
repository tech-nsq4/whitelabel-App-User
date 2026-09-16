import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/appointment_model.dart';
import 'models/appointment_quote_model.dart';
import 'models/doctor_profile_model.dart';
import 'models/doctor_review_model.dart';
import 'models/doctor_time_table_model.dart';
import 'models/specialization_model.dart';

class BookingRepo {
  BookingRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  /// The specialties tree shown on `SpecsScreen` — top-level specializations,
  /// each optionally carrying its own sub-specializations. [name] filters the
  /// list server-side by specialization title.
  Future<List<SpecializationModel>> getSpecializations({String? name}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.specializations,
        queryParameters: {
          if (name != null && name.isNotEmpty) 'name': name,
        },
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Doctors, optionally filtered by [specializationId] (a top-level
  /// specialization), [subSpecializationId] (one of its sub-specialties),
  /// [clinicId]/[name] and ordered by [sort] (`highest_rated` |
  /// `closest_available` | `lowest_price` — `closest_available` ranks by
  /// distance when [lat]/[lng] are sent, otherwise by soonest open slot).
  Future<List<DoctorProfileModel>> getDoctors({
    int? specializationId,
    int? subSpecializationId,
    int? clinicId,
    String? name,
    String? sort,
    double? lat,
    double? lng,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.doctors,
        queryParameters: {
          if (specializationId != null) 'specialization_id': specializationId,
          if (subSpecializationId != null) 'sub_specialization_id': subSpecializationId,
          if (clinicId != null) 'clinic_id': clinicId,
          if (name != null && name.isNotEmpty) 'name': name,
          if (sort != null && sort.isNotEmpty) 'sort': sort,
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

  Future<List<DoctorReviewModel>> getDoctorReviews(int doctorId) async {
    try {
      final response = await _dio.get(ApiEndpoints.doctorReviews(doctorId));
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => DoctorReviewModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// The clinics/branches list shown on `BranchesScreen` — reuses
  /// [DoctorClinicModel] since `/branches` returns the exact same shape as
  /// a doctor's `clinic`. [name] filters the list server-side by branch name.
  Future<List<DoctorClinicModel>> getBranches({String? name}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.branches,
        queryParameters: {
          if (name != null && name.isNotEmpty) 'name': name,
        },
      );
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => DoctorClinicModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// The account's favorite clinics — same shape as [getBranches], shown on
  /// `FavoritesScreen` and backing the heart toggle's state on `BranchCard`.
  Future<List<DoctorClinicModel>> getFavoriteBranches() async {
    try {
      final response = await _dio.get(ApiEndpoints.favoriteBranches);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => DoctorClinicModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> addFavoriteBranch(int clinicId) async {
    try {
      await _dio.post(ApiEndpoints.favoriteBranch(clinicId));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> removeFavoriteBranch(int clinicId) async {
    try {
      await _dio.delete(ApiEndpoints.favoriteBranch(clinicId));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// A doctor's recurring weekly schedule(s), for the calendar/time picker
  /// on `BookingSlotsSheet`. Called once with no [date] to build the
  /// calendar itself (a generic weekly template — its `available` flags
  /// aren't tied to any one real date), then again with [date] set every
  /// time the user picks a day, so that day's `available` flags reflect
  /// what's actually booked on that specific date rather than the template.
  Future<List<DoctorTimeTableModel>> getDoctorTimeTables(int doctorId, {DateTime? date, int? clinicId}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.doctorTimeTables(doctorId),
        queryParameters: {
          if (date != null) 'date': _formatApiDate(date),
          if (clinicId != null) 'clinic_id': clinicId,
        },
      );
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
    int? clinicId,
    int? familyMemberId,
    int? offerId,
    String? promoCode,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.appointments, data: {
        'doctor_id': doctorId,
        'time_table_id': timeTableId,
        'schedule_id': scheduleId,
        'shift_id': shiftId,
        'times': times,
        'date': _formatApiDate(date),
        if (clinicId != null) 'clinic_id': clinicId,
        'family_member_id': familyMemberId,
        if (offerId != null) 'offer_id': offerId,
        if (promoCode != null && promoCode.isNotEmpty) 'promo_code': promoCode,
      });
      return AppointmentModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<AppointmentQuoteModel> getAppointmentQuote({
    required int doctorId,
    required DateTime date,
    int? clinicId,
    String? promoCode,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.appointmentQuote, data: {
        'doctor_id': doctorId,
        'date': _formatApiDate(date),
        if (clinicId != null) 'clinic_id': clinicId,
        if (promoCode != null && promoCode.isNotEmpty) 'promo_code': promoCode,
      });
      return AppointmentQuoteModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// The account's booked appointments — powers the home screen's
  /// "upcoming appointment" card and `MyBookingsScreen`'s status tabs.
  /// [status] is one of the API's filter values ("pending" | "confirmed" |
  /// "completed" | "cancelled") — `null`/empty fetches every appointment.
  Future<List<AppointmentModel>> getAppointments({String? status}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.appointments,
        queryParameters: {
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );
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

  /// Reschedules [appointmentId] to the new doctor/slot picked on
  /// `BookingSlotsSheet` — same fields as [createAppointment], minus
  /// `family_member_id` (who it's for doesn't change on reschedule).
  Future<void> rescheduleAppointment({
    required int appointmentId,
    required int doctorId,
    required int timeTableId,
    required int scheduleId,
    required String shiftId,
    required String times,
    required DateTime date,
    int? clinicId,
  }) async {
    try {
      await _dio.post(ApiEndpoints.appointmentReschedule(appointmentId), data: {
        'doctor_id': doctorId,
        'time_table_id': timeTableId,
        'schedule_id': scheduleId,
        'shift_id': shiftId,
        'times': times,
        'date': _formatApiDate(date),
        if (clinicId != null) 'clinic_id': clinicId,
      });
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Cancels an appointment that hasn't happened yet.
  Future<void> cancelAppointment(int appointmentId) async {
    try {
      await _dio.post(ApiEndpoints.appointmentCancel(appointmentId));
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Rates a completed appointment — [comment] is optional.
  Future<void> rateAppointment({
    required int appointmentId,
    required int rate,
    String? comment,
  }) async {
    try {
      await _dio.post(ApiEndpoints.appointmentRate(appointmentId), data: {
        'rate': rate,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      });
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
