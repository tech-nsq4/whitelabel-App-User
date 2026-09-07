import 'package:equatable/equatable.dart';

import 'doctor_time_table_model.dart' show formatApiTimeArabic;
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

/// A doctor's soonest open slot — `GET /doctors`' `nearest_available`, shown
/// as a quick "when can I actually see them" hint on [DoctorCard]
/// without needing to open their full schedule first.
class DoctorNearestAvailableModel extends Equatable {
  final DateTime? date;
  final String time; // raw API string, e.g. "05:00 PM"
  final String shiftId;
  final int scheduleId;
  final int timeTableId;
  final int? clinicId;
  final String type; // "clinic" | "video"

  const DoctorNearestAvailableModel({
    this.date,
    required this.time,
    required this.shiftId,
    required this.scheduleId,
    required this.timeTableId,
    this.clinicId,
    required this.type,
  });

  factory DoctorNearestAvailableModel.fromJson(Map<String, dynamic> json) => DoctorNearestAvailableModel(
        date: DateTime.tryParse(json['date'] as String? ?? ''),
        time: json['time'] as String? ?? '',
        shiftId: json['shift_id'] as String? ?? '',
        scheduleId: json['schedule_id'] as int? ?? 0,
        timeTableId: json['time_table_id'] as int? ?? 0,
        clinicId: json['clinic_id'] as int?,
        type: json['type'] as String? ?? '',
      );

  /// Arabic-labelled 12h display (e.g. "5:00 م") instead of the raw
  /// English "05:00 PM" the API returns.
  String get displayTime => formatApiTimeArabic(time);

  @override
  List<Object?> get props => [date, time, shiftId, scheduleId, timeTableId, clinicId, type];
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
  final double? avgRate;
  final List<SpecializationModel> specializations;
  final List<SubSpecializationModel> subSpecializations;
  final List<DoctorClinicModel> clinics;
  final DoctorLocationModel? location;
  final DoctorNearestAvailableModel? nearestAvailable;

  const DoctorProfileModel({
    required this.id,
    required this.name,
    this.description,
    this.experienceYears = 0,
    this.price = 0,
    this.image,
    this.avgRate,
    this.specializations = const [],
    this.subSpecializations = const [],
    this.clinics = const [],
    this.location,
    this.nearestAvailable,
  });

  /// First letter of [name] — used for the fallback avatar when [image] is
  /// missing (e.g. "د" from "د. منى سعيد").
  String get avatarLetter => name.trim().isEmpty ? '' : name.trim()[0];

  /// Comma-joined specialization titles — usually just one.
  String get specialtyLabel => specializations.map((s) => s.title).join('، ');

  DoctorClinicModel? get clinic => clinics.isEmpty ? null : clinics.first;

  DoctorClinicModel? clinicById(int? id) {
    if (id == null) return clinic;
    for (final c in clinics) {
      if (c.id == id) return c;
    }
    return clinic;
  }

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) => DoctorProfileModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        experienceYears: json['experience'] as int? ?? 0,
        price: double.tryParse('${json['price']}') ?? 0,
        image: json['image'] as String?,
        avgRate: (json['avg_rate'] as num?)?.toDouble(),
        specializations: (json['specializations'] as List<dynamic>? ?? [])
            .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        subSpecializations: (json['sub_specializations'] as List<dynamic>? ?? [])
            .map((e) => SubSpecializationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        clinics: (json['clinics'] as List<dynamic>?)
                ?.map((e) => DoctorClinicModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            (json['clinic'] == null
                ? const <DoctorClinicModel>[]
                : [DoctorClinicModel.fromJson(json['clinic'] as Map<String, dynamic>)]),
        location:
            json['location'] == null ? null : DoctorLocationModel.fromJson(json['location'] as Map<String, dynamic>),
        nearestAvailable: json['nearest_available'] == null
            ? null
            : DoctorNearestAvailableModel.fromJson(json['nearest_available'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        experienceYears,
        price,
        image,
        avgRate,
        specializations,
        subSpecializations,
        clinics,
        location,
        nearestAvailable,
      ];
}
