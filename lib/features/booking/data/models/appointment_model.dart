import 'package:equatable/equatable.dart';

import '../../../family/data/models/family_member_model.dart';
import 'doctor_profile_model.dart';
import 'doctor_time_table_model.dart';

/// One drug entry inside [AppointmentModel.prescriptions] — the itemized
/// medications a doctor prescribed during a completed appointment.
class PrescriptionModel extends Equatable {
  final int id;
  final String drugName;
  final String dosage;
  final String duration;
  final DateTime? date;

  const PrescriptionModel({
    required this.id,
    required this.drugName,
    required this.dosage,
    required this.duration,
    this.date,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) => PrescriptionModel(
        id: json['id'] as int,
        drugName: json['drug_name'] as String? ?? '',
        dosage: json['dosage'] as String? ?? '',
        duration: json['duration'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? ''),
      );

  @override
  List<Object?> get props => [id, drugName, dosage, duration, date];
}

/// The lab/x-ray test a [TestRequestModel] is for.
class TestModel extends Equatable {
  final int id;
  final String name;
  final String? description;
  final double price;

  const TestModel({required this.id, required this.name, this.description, this.price = 0});

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        price: double.tryParse('${json['price']}') ?? 0,
      );

  @override
  List<Object?> get props => [id, name, description, price];
}

/// A lab analysis or x-ray request — attached to an appointment inside
/// [AppointmentModel.testRequests], and also the shape of each entry on
/// `GET /analyses/history` / `GET /xrays/history` (flat, cross-appointment
/// lists, hence [appointmentId] here too). `has_result` flips once the
/// clinic uploads a result via [url] (an image/PDF), optionally rated
/// [resultRate].
class TestRequestModel extends Equatable {
  final int id;
  final int? appointmentId;
  final String type; // "analysis" | "xray"
  final bool hasResult;
  final String? resultRate; // e.g. "normal" | "not_normal", null until resulted
  final String? note;
  final String? url;
  final DateTime? resultedAt;
  final DateTime? createdAt;
  final TestModel? test;

  const TestRequestModel({
    required this.id,
    this.appointmentId,
    required this.type,
    this.hasResult = false,
    this.resultRate,
    this.note,
    this.url,
    this.resultedAt,
    this.createdAt,
    this.test,
  });

  bool get isXray => type == 'xray';

  factory TestRequestModel.fromJson(Map<String, dynamic> json) => TestRequestModel(
        id: json['id'] as int,
        appointmentId: json['appointment_id'] as int?,
        type: json['type'] as String? ?? '',
        hasResult: json['has_result'] as bool? ?? false,
        resultRate: json['result_rate'] as String?,
        note: json['note'] as String?,
        url: json['url'] as String?,
        resultedAt: DateTime.tryParse(json['resulted_at'] as String? ?? ''),
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
        test: json['test'] == null ? null : TestModel.fromJson(json['test'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props =>
      [id, appointmentId, type, hasResult, resultRate, note, url, resultedAt, createdAt, test];
}

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

  /// Attached signed-prescription file/date — separate from the itemized
  /// [prescriptions] list, both only populated once [status] is "completed".
  final DateTime? prescriptionDate;
  final String? prescriptionImage;
  final List<PrescriptionModel> prescriptions;
  final List<TestRequestModel> testRequests;

  /// The account's 1-5 rating for this appointment (`POST
  /// /appointments/{id}/rate`) — `null` until rated, only offered once
  /// [status] is "completed".
  final int? rate;
  final String? comment;
  final DateTime? ratedAt;

  bool get isRated => rate != null;

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
    this.prescriptionDate,
    this.prescriptionImage,
    this.prescriptions = const [],
    this.testRequests = const [],
    this.rate,
    this.comment,
    this.ratedAt,
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
        prescriptionDate: DateTime.tryParse(json['prescription_date'] as String? ?? ''),
        prescriptionImage: json['prescription_image'] as String?,
        prescriptions: (json['prescriptions'] as List<dynamic>? ?? [])
            .map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        testRequests: (json['test_requests'] as List<dynamic>? ?? [])
            .map((e) => TestRequestModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        rate: json['rate'] as int?,
        comment: json['comment'] as String?,
        ratedAt: json['rated_at'] == null ? null : DateTime.tryParse(json['rated_at'] as String),
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
        prescriptionDate,
        prescriptionImage,
        prescriptions,
        testRequests,
        rate,
        comment,
        ratedAt,
      ];
}
