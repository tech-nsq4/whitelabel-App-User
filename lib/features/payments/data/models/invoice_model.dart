import 'package:equatable/equatable.dart';

import '../../../booking/data/models/doctor_profile_model.dart';
import '../../../booking/data/models/doctor_time_table_model.dart' show formatApiTimeArabic;
import '../../../family/data/models/family_member_model.dart';

class InvoiceModel extends Equatable {
  final int id;
  final int appointmentId;
  final DateTime? date;
  final String time;
  final String shiftId;
  final String status;
  final double amount;
  final DoctorProfileModel? doctor;
  final DoctorClinicModel? clinic;
  final FamilyMemberModel? familyMember;

  const InvoiceModel({
    required this.id,
    this.appointmentId = 0,
    this.date,
    this.time = '',
    this.shiftId = '',
    this.status = '',
    this.amount = 0,
    this.doctor,
    this.clinic,
    this.familyMember,
  });

  bool get isPaid => status == 'completed' || status == 'paid';

  String get timeLabel => formatApiTimeArabic(time);

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json['id'] as int,
        appointmentId: json['appointment_id'] as int? ?? 0,
        date: DateTime.tryParse(json['date'] as String? ?? ''),
        time: json['time'] as String? ?? '',
        shiftId: json['shift_id'] as String? ?? '',
        status: json['status'] as String? ?? '',
        amount: double.tryParse('${json['amount']}') ?? 0,
        doctor: json['doctor'] == null ? null : DoctorProfileModel.fromJson(json['doctor'] as Map<String, dynamic>),
        clinic: json['clinic'] == null ? null : DoctorClinicModel.fromJson(json['clinic'] as Map<String, dynamic>),
        familyMember: json['family_member'] == null
            ? null
            : FamilyMemberModel.fromJson(json['family_member'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props =>
      [id, appointmentId, date, time, shiftId, status, amount, doctor, clinic, familyMember];
}
