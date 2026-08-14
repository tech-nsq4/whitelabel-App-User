import 'package:equatable/equatable.dart';

import '../../../family/data/models/family_member_model.dart';
import 'doctor_profile_model.dart';
import 'doctor_time_table_model.dart';

/// A booked appointment from `POST/GET /appointments`.
class AppointmentModel extends Equatable {
  final int id;
  final int doctorId;
  final int timeTableId;
  final int scheduleId;
  final String shiftId; // "first" | "second" | "third"
  final String times; // raw API string, e.g. "09:00 AM"
  final DateTime? date;
  final String status; // "pending" | ...
  final int? familyMemberId;
  final DoctorProfileModel? doctor;
  final DoctorTimeTableModel? timeTable;
  final TimeTableScheduleModel? schedule;
  final FamilyMemberModel? familyMember;
  final DateTime? createdAt;

  const AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.timeTableId,
    required this.scheduleId,
    required this.shiftId,
    required this.times,
    this.date,
    this.status = 'pending',
    this.familyMemberId,
    this.doctor,
    this.timeTable,
    this.schedule,
    this.familyMember,
    this.createdAt,
  });

  /// [date] + [times] combined into one [DateTime] — used to sort/filter
  /// appointments (e.g. the home screen's soonest-upcoming card).
  DateTime? get dateTime {
    final d = date;
    if (d == null) return null;
    final t = parseApiTime12h(times);
    if (t == null) return d;
    return DateTime(d.year, d.month, d.day, t.$1, t.$2);
  }

  /// Arabic-labelled 12h display (e.g. "4:00 م") for [times].
  String get timeLabel => formatApiTimeArabic(times);

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
        id: json['id'] as int,
        doctorId: json['doctor_id'] as int? ?? 0,
        timeTableId: json['time_table_id'] as int? ?? 0,
        scheduleId: json['schedule_id'] as int? ?? 0,
        shiftId: json['shift_id'] as String? ?? '',
        times: json['times'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? ''),
        status: json['status'] as String? ?? 'pending',
        familyMemberId: json['family_member_id'] as int?,
        doctor: json['doctor'] == null ? null : DoctorProfileModel.fromJson(json['doctor'] as Map<String, dynamic>),
        timeTable: json['time_table'] == null
            ? null
            : DoctorTimeTableModel.fromJson(json['time_table'] as Map<String, dynamic>),
        schedule: json['schedule'] == null
            ? null
            : TimeTableScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
        familyMember: json['family_member'] == null
            ? null
            : FamilyMemberModel.fromJson(json['family_member'] as Map<String, dynamic>),
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      );

  @override
  List<Object?> get props => [
        id,
        doctorId,
        timeTableId,
        scheduleId,
        shiftId,
        times,
        date,
        status,
        familyMemberId,
        doctor,
        timeTable,
        schedule,
        familyMember,
        createdAt,
      ];
}
