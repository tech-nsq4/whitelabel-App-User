import 'package:equatable/equatable.dart';

import 'specialization_model.dart';

class DoctorCityModel extends Equatable {
  final int id;
  final String name;

  const DoctorCityModel({required this.id, required this.name});

  factory DoctorCityModel.fromJson(Map<String, dynamic> json) => DoctorCityModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id, name];
}

class DoctorAreaModel extends Equatable {
  final int id;
  final int cityId;
  final String name;

  const DoctorAreaModel({required this.id, required this.cityId, required this.name});

  factory DoctorAreaModel.fromJson(Map<String, dynamic> json) => DoctorAreaModel(
        id: json['id'] as int,
        cityId: json['city_id'] as int,
        name: json['name'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id, cityId, name];
}

class DoctorLocationModel extends Equatable {
  final int id;
  final String name;
  final DoctorCityModel? city;
  final DoctorAreaModel? area;

  const DoctorLocationModel({required this.id, required this.name, this.city, this.area});

  factory DoctorLocationModel.fromJson(Map<String, dynamic> json) => DoctorLocationModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        city: json['city'] == null ? null : DoctorCityModel.fromJson(json['city'] as Map<String, dynamic>),
        area: json['area'] == null ? null : DoctorAreaModel.fromJson(json['area'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props => [id, name, city, area];
}

class DoctorClinicModel extends Equatable {
  final int id;
  final String name;
  final String? address;
  final double? lat;
  final double? lng;
  final DoctorLocationModel? location;

  const DoctorClinicModel({
    required this.id,
    required this.name,
    this.address,
    this.lat,
    this.lng,
    this.location,
  });

  factory DoctorClinicModel.fromJson(Map<String, dynamic> json) => DoctorClinicModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        address: json['address'] as String?,
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
        location:
            json['location'] == null ? null : DoctorLocationModel.fromJson(json['location'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props => [id, name, address, lat, lng, location];
}

/// A doctor from `GET /doctors` — the real, filterable record (as opposed to
/// the legacy prototype `DoctorModel`/`DoctorsMockData` still used by the
/// not-yet-wired telemed flow).
class DoctorProfileModel extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int experienceYears;
  final double price;
  final String? image;
  final List<SpecializationModel> specializations;
  final DoctorClinicModel? clinic;
  final DoctorLocationModel? location;

  const DoctorProfileModel({
    required this.id,
    required this.name,
    this.description,
    this.experienceYears = 0,
    this.price = 0,
    this.image,
    this.specializations = const [],
    this.clinic,
    this.location,
  });

  /// First letter of [name] — used for the fallback avatar when [image] is
  /// missing (e.g. "د" from "د. منى سعيد").
  String get avatarLetter => name.trim().isEmpty ? '' : name.trim()[0];

  /// Comma-joined specialization titles — usually just one.
  String get specialtyLabel => specializations.map((s) => s.title).join('، ');

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) => DoctorProfileModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        experienceYears: json['experience'] as int? ?? 0,
        price: double.tryParse('${json['price']}') ?? 0,
        image: json['image'] as String?,
        specializations: (json['specializations'] as List<dynamic>? ?? [])
            .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        clinic: json['clinic'] == null ? null : DoctorClinicModel.fromJson(json['clinic'] as Map<String, dynamic>),
        location:
            json['location'] == null ? null : DoctorLocationModel.fromJson(json['location'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props =>
      [id, name, description, experienceYears, price, image, specializations, clinic, location];
}
