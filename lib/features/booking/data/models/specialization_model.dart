import 'package:equatable/equatable.dart';

/// One entry under a [SpecializationModel]'s `sub_specializations` — e.g.
/// "تقويم الأسنان" under "الأسنان".
class SubSpecializationModel extends Equatable {
  final int id;
  final int specializationId;
  final String title;
  final String? description;

  const SubSpecializationModel({
    required this.id,
    required this.specializationId,
    required this.title,
    this.description,
  });

  factory SubSpecializationModel.fromJson(Map<String, dynamic> json) =>
      SubSpecializationModel(
        id: json['id'] as int,
        specializationId: json['specialization_id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'specialization_id': specializationId,
        'title': title,
        'description': description,
      };

  @override
  List<Object?> get props => [id, specializationId, title, description];
}

/// A top-level medical specialty from `GET /specializations` (e.g.
/// "الأسنان") — optionally carrying its own [subSpecializations].
class SpecializationModel extends Equatable {
  final int id;
  final String title;
  final String? description;
  final List<SubSpecializationModel> subSpecializations;

  const SpecializationModel({
    required this.id,
    required this.title,
    this.description,
    this.subSpecializations = const [],
  });

  bool get hasSubSpecializations => subSpecializations.isNotEmpty;

  factory SpecializationModel.fromJson(Map<String, dynamic> json) =>
      SpecializationModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        subSpecializations: (json['sub_specializations'] as List<dynamic>? ?? [])
            .map((e) =>
                SubSpecializationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'sub_specializations':
            subSpecializations.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, title, description, subSpecializations];
}
