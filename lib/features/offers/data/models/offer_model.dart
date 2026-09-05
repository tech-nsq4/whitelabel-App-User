import 'package:equatable/equatable.dart';

import '../../../booking/data/models/doctor_profile_model.dart';
import '../../../booking/data/models/specialization_model.dart';
import 'applied_offer.dart';

class OfferBookingTargetModel extends Equatable {
  final int? specializationId;
  final int? clinicId;
  final int? doctorId;

  const OfferBookingTargetModel({this.specializationId, this.clinicId, this.doctorId});

  factory OfferBookingTargetModel.fromJson(Map<String, dynamic> json) => OfferBookingTargetModel(
        specializationId: json['specialization_id'] as int?,
        clinicId: json['clinic_id'] as int?,
        doctorId: json['doctor_id'] as int?,
      );

  @override
  List<Object?> get props => [specializationId, clinicId, doctorId];
}

class OfferModel extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? cover;
  final String discountType;
  final double discountValue;
  final double? maxDiscountAmount;
  final String scope;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool showOnHome;
  final OfferBookingTargetModel booking;
  final List<DoctorClinicModel> clinics;
  final List<DoctorProfileModel> doctors;
  final List<SpecializationModel> specializations;

  const OfferModel({
    required this.id,
    required this.name,
    this.description,
    this.cover,
    required this.discountType,
    this.discountValue = 0,
    this.maxDiscountAmount,
    this.scope = 'all',
    this.startsAt,
    this.endsAt,
    this.showOnHome = false,
    this.booking = const OfferBookingTargetModel(),
    this.clinics = const [],
    this.doctors = const [],
    this.specializations = const [],
  });

  bool get isPercentage => discountType == 'percentage';
  bool get isFixed => discountType == 'fixed';
  bool get isSpecialPrice => discountType == 'special_price';

  bool get isPermanent => endsAt == null;

  AppliedOffer get appliedOffer => AppliedOffer(
        id: id,
        discountType: discountType,
        discountValue: discountValue,
        maxDiscountAmount: maxDiscountAmount,
      );

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        cover: json['cover'] as String?,
        discountType: json['discount_type'] as String? ?? '',
        discountValue: double.tryParse('${json['discount_value']}') ?? 0,
        maxDiscountAmount:
            json['max_discount_amount'] == null ? null : double.tryParse('${json['max_discount_amount']}'),
        scope: json['scope'] as String? ?? 'all',
        startsAt: json['starts_at'] == null ? null : DateTime.tryParse(json['starts_at'] as String),
        endsAt: json['ends_at'] == null ? null : DateTime.tryParse(json['ends_at'] as String),
        showOnHome: json['show_on_home'] as bool? ?? false,
        booking: json['booking'] == null
            ? const OfferBookingTargetModel()
            : OfferBookingTargetModel.fromJson(json['booking'] as Map<String, dynamic>),
        clinics: (json['clinics'] as List<dynamic>? ?? [])
            .map((e) => DoctorClinicModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        doctors: (json['doctors'] as List<dynamic>? ?? [])
            .map((e) => DoctorProfileModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        specializations: (json['specializations'] as List<dynamic>? ?? [])
            .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        cover,
        discountType,
        discountValue,
        maxDiscountAmount,
        scope,
        startsAt,
        endsAt,
        showOnHome,
        booking,
        clinics,
        doctors,
        specializations,
      ];
}
