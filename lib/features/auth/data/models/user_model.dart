import 'package:equatable/equatable.dart';

class UserVitalSignsModel extends Equatable {
  final int id;
  final String? bloodPressure;
  final int? pulse;
  final double? temperature;
  final int? oxygen;
  final DateTime? updatedAt;

  const UserVitalSignsModel({
    required this.id,
    this.bloodPressure,
    this.pulse,
    this.temperature,
    this.oxygen,
    this.updatedAt,
  });

  factory UserVitalSignsModel.fromJson(Map<String, dynamic> json) => UserVitalSignsModel(
        id: json['id'] as int? ?? 0,
        bloodPressure: json['blood_pressure'] as String?,
        pulse: json['pulse'] as int?,
        temperature: double.tryParse('${json['temperature']}'),
        oxygen: json['oxygen'] as int?,
        updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'blood_pressure': bloodPressure,
        'pulse': pulse,
        'temperature': temperature,
        'oxygen': oxygen,
        'updated_at': updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, bloodPressure, pulse, temperature, oxygen, updatedAt];
}

class UserModel extends Equatable {
  final int id;
  final String phone;
  final String? name;
  final String? email;
  final String? dateOfBirth;
  final double? height;
  final double? weight;
  final String? appLang;
  final int familyMembersCount;
  final bool profileCompleted;
  final String? phoneVerifiedAt;
  final UserVitalSignsModel? userVitalSigns;

  const UserModel({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.appLang,
    this.familyMembersCount = 0,
    this.profileCompleted = false,
    this.phoneVerifiedAt,
    this.userVitalSigns,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        phone: json['phone'] as String? ?? '',
        name: json['name'] as String?,
        email: json['email'] as String?,
        dateOfBirth: json['date_of_birth'] as String?,
        height: _toDouble(json['height']),
        weight: _toDouble(json['weight']),
        appLang: json['app_lang'] as String?,
        familyMembersCount: json['family_members_count'] as int? ?? 0,
        profileCompleted: json['profile_completed'] as bool? ?? false,
        phoneVerifiedAt: json['phone_verified_at'] as String?,
        userVitalSigns: json['user_vital_signs'] == null
            ? null
            : UserVitalSignsModel.fromJson(json['user_vital_signs'] as Map<String, dynamic>),
      );

  /// The API returns `height`/`weight` as numbers before a profile update
  /// but as numeric strings (e.g. `"184.00"`) right after one — accept both.
  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'name': name,
        'email': email,
        'date_of_birth': dateOfBirth,
        'height': height,
        'weight': weight,
        'app_lang': appLang,
        'family_members_count': familyMembersCount,
        'profile_completed': profileCompleted,
        'phone_verified_at': phoneVerifiedAt,
        'user_vital_signs': userVitalSigns?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        phone,
        name,
        email,
        dateOfBirth,
        height,
        weight,
        appLang,
        familyMembersCount,
        profileCompleted,
        phoneVerifiedAt,
        userVitalSigns,
      ];
}
