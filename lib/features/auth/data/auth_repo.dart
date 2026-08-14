import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/storage/local_storage.dart';
import 'models/otp_sent_result.dart';
import 'models/user_model.dart';

class AuthRepo {
  AuthRepo({required DioClient dio, required LocalStorage storage})
      : _dio = dio,
        _storage = storage;

  final DioClient _dio;
  final LocalStorage _storage;

  /// Requests an OTP for [phone] — the single entry point for both the
  /// login and the register flow (the backend tells us which one it is via
  /// `is_new_user`), and also used to resend the code from the OTP screen.
  Future<OtpSentResult> sendOtp({required String phone}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.sendOtp,
        data: {'phone': phone},
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      final user = data['user'] as Map<String, dynamic>?;
      return OtpSentResult(
        phone: user?['phone'] as String? ?? phone,
        isNewUser: data['is_new_user'] as bool? ?? false,
        message: body['message'] as String? ?? '',
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Verifies [otp] for [phone] — logs the user in (creating the account
  /// first if it's new) and persists the session token.
  Future<UserModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {'phone': phone, 'otp': otp},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      final token = data['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await _storage.setToken(token);
        await _storage.setUser(user.toJson());
      }
      return user;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Completes / updates the current user's profile. Only the non-null
  /// fields are sent, so callers can submit as little or as much as they have.
  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? dateOfBirth,
    double? height,
    double? weight,
  }) async {
    try {
      final data = <String, dynamic>{
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
        if (height != null) 'height': height,
        if (weight != null) 'weight': weight,
      };
      final response = await _dio.post(ApiEndpoints.profile, data: data);
      final user =
          UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      await _storage.setUser(user.toJson());
      return user;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Registers/refreshes this device's push-notification token with the
  /// backend — called once on app-shell load for a logged-in user.
  Future<void> updateFcmToken(String fcmToken) async {
    try {
      await _dio.post(ApiEndpoints.fcmToken, data: {'fcm_token': fcmToken});
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Syncs the app's active UI language (`ar`/`en`) with the backend.
  Future<void> updateAppLang(String lang) async {
    try {
      await _dio.post(ApiEndpoints.appLang, data: {'app_lang': lang});
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    } finally {
      await _storage.clearAll();
    }
  }
}
