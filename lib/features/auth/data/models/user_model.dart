import 'package:equatable/equatable.dart';

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
      ];
}
