import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/family_member_model.dart';

class FamilyRepo {
  FamilyRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<FamilyMemberModel>> getFamilyMembers() async {
    try {
      final response = await _dio.get(ApiEndpoints.familyMembers);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => FamilyMemberModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Adds a family member. [medicalFiles] (images) are sent as repeated
  /// `medical_files[]` multipart entries.
  Future<FamilyMemberModel> addFamilyMember({
    required String name,
    required String dateOfBirth,
    required String phone,
    required String idNumber,
    List<XFile> medicalFiles = const [],
  }) async {
    try {
      final form = await _buildForm(
        name: name,
        dateOfBirth: dateOfBirth,
        phone: phone,
        idNumber: idNumber,
        medicalFiles: medicalFiles,
      );
      final response = await _dio.postForm(ApiEndpoints.familyMembers, form);
      return FamilyMemberModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  /// Updates [id]'s details. [medicalFiles], if any, are appended as new
  /// `medical_files[]` attachments alongside whatever the member already has.
  Future<FamilyMemberModel> updateFamilyMember({
    required int id,
    required String name,
    required String dateOfBirth,
    required String phone,
    required String idNumber,
    List<XFile> medicalFiles = const [],
  }) async {
    try {
      final form = await _buildForm(
        name: name,
        dateOfBirth: dateOfBirth,
        phone: phone,
        idNumber: idNumber,
        medicalFiles: medicalFiles,
      );
      final response = await _dio.postForm(ApiEndpoints.familyMemberDetails(id), form);
      return FamilyMemberModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<FormData> _buildForm({
    required String name,
    required String dateOfBirth,
    required String phone,
    required String idNumber,
    required List<XFile> medicalFiles,
  }) async {
    final form = FormData.fromMap({
      'name': name,
      'date_of_birth': dateOfBirth,
      'phone': phone,
      'id_number': idNumber,
    });
    for (final file in medicalFiles) {
      form.files.add(MapEntry(
        'medical_files[]',
        await MultipartFile.fromFile(file.path, filename: file.name),
      ));
    }
    return form;
  }
}
