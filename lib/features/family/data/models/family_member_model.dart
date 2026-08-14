import 'package:equatable/equatable.dart';

class FamilyMemberModel extends Equatable {
  final int id;
  final String name;
  final String? dateOfBirth;
  final String? phone;
  final String? idNumber;
  final List<String> medicalFiles;
  final String? createdAt;
  final String? updatedAt;

  const FamilyMemberModel({
    required this.id,
    required this.name,
    this.dateOfBirth,
    this.phone,
    this.idNumber,
    this.medicalFiles = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// First letter of [name] — used for the fallback avatar.
  String get avatarLetter => name.trim().isEmpty ? '' : name.trim()[0];

  /// Age in whole years, computed from [dateOfBirth] — `null` if missing/unparsable.
  int? get age {
    final dob = dateOfBirth == null ? null : DateTime.tryParse(dateOfBirth!);
    if (dob == null) return null;
    final now = DateTime.now();
    var years = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) years--;
    return years;
  }

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) => FamilyMemberModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        dateOfBirth: json['date_of_birth'] as String?,
        phone: json['phone'] as String?,
        idNumber: json['id_number'] as String?,
        medicalFiles: (json['medical_files'] as List<dynamic>? ?? []).map(_fileUrl).whereType<String>().toList(),
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
      );

  /// `medical_files` entries may come back as plain URL strings or as
  /// `{url|path|file: "..."}` objects depending on the backend — accept both.
  static String? _fileUrl(dynamic entry) {
    if (entry is String) return entry;
    if (entry is Map) {
      final map = entry;
      return (map['url'] ?? map['path'] ?? map['file']) as String?;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date_of_birth': dateOfBirth,
        'phone': phone,
        'id_number': idNumber,
        'medical_files': medicalFiles,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  @override
  List<Object?> get props => [id, name, dateOfBirth, phone, idNumber, medicalFiles, createdAt, updatedAt];
}
