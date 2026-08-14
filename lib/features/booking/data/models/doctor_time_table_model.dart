import 'package:equatable/equatable.dart';

/// Parses a raw API time string ("09:00 AM"/"04:40 PM") into a 24h
/// (hour, minute) pair — shared by [TimeTableSlotModel] and
/// `AppointmentModel`. `null` if [time] doesn't match the expected format.
(int hour, int minute)? parseApiTime12h(String time) {
  final match = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$', caseSensitive: false).firstMatch(time.trim());
  if (match == null) return null;
  var hour = int.parse(match.group(1)!);
  final minute = int.parse(match.group(2)!);
  final period = match.group(3)!.toUpperCase();
  if (period == 'PM' && hour != 12) hour += 12;
  if (period == 'AM' && hour == 12) hour = 0;
  return (hour, minute);
}

/// Arabic-labelled 12h display (e.g. "4:00 م") for a raw API time string
/// ("04:00 PM") — falls back to [time] itself if it doesn't parse.
String formatApiTimeArabic(String time) {
  final t = parseApiTime12h(time);
  if (t == null) return time;
  final (hour24, minute) = t;
  final isPm = hour24 >= 12;
  var hour12 = hour24 % 12;
  if (hour12 == 0) hour12 = 12;
  final minuteStr = minute.toString().padLeft(2, '0');
  return '$hour12:$minuteStr ${isPm ? 'م' : 'ص'}';
}

/// One precomputed time slot inside a [TimeTableScheduleModel.times] list.
class TimeTableSlotModel extends Equatable {
  final String time; // raw API string, e.g. "09:00 AM"
  final bool available;
  final String shift; // "first" | "second" | "third"
  final int scheduleId;

  /// The parent [DoctorTimeTableModel.id] this slot belongs to — not part
  /// of the raw `times` JSON, so it's `0` until [DoctorTimeTableModel.slotsFor]
  /// stamps it via [withTimeTableId]. Needed for `POST /appointments`.
  final int timeTableId;

  const TimeTableSlotModel({
    required this.time,
    required this.available,
    required this.shift,
    required this.scheduleId,
    this.timeTableId = 0,
  });

  factory TimeTableSlotModel.fromJson(Map<String, dynamic> json) => TimeTableSlotModel(
        time: json['time'] as String? ?? '',
        available: ((json['available'] as num?)?.toInt() ?? 0) == 1,
        shift: json['shift'] as String? ?? '',
        scheduleId: json['schedule_id'] as int? ?? 0,
      );

  TimeTableSlotModel withTimeTableId(int id) => TimeTableSlotModel(
        time: time,
        available: available,
        shift: shift,
        scheduleId: scheduleId,
        timeTableId: id,
      );

  /// [time] ("09:00 AM"/"04:40 PM") as a 24h (hour, minute) pair — used for
  /// sorting and for building the actual appointment [DateTime]. `null` if
  /// [time] doesn't match the expected format.
  (int hour, int minute)? get time24 => parseApiTime12h(time);

  /// Arabic-labelled 12h display (e.g. "4:00 م") instead of the raw
  /// English "04:00 PM" the API returns.
  String get displayLabel => formatApiTimeArabic(time);

  @override
  List<Object?> get props => [time, available, shift, scheduleId, timeTableId];
}

/// One weekday's slots inside a [DoctorTimeTableModel].
class TimeTableScheduleModel extends Equatable {
  final int id;
  final String day; // "Saturday".."Friday"
  final List<TimeTableSlotModel> times;

  const TimeTableScheduleModel({required this.id, required this.day, this.times = const []});

  factory TimeTableScheduleModel.fromJson(Map<String, dynamic> json) => TimeTableScheduleModel(
        id: json['id'] as int,
        day: json['day'] as String? ?? '',
        times: (json['times'] as List<dynamic>? ?? [])
            .map((e) => TimeTableSlotModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [id, day, times];
}

/// A date range the clinic is fully closed for.
class TimeTableHolidayModel extends Equatable {
  final int id;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;

  const TimeTableHolidayModel({required this.id, required this.name, this.startDate, this.endDate});

  factory TimeTableHolidayModel.fromJson(Map<String, dynamic> json) => TimeTableHolidayModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        startDate: DateTime.tryParse(json['start_date'] as String? ?? ''),
        endDate: DateTime.tryParse(json['end_date'] as String? ?? ''),
      );

  bool covers(DateTime date) {
    if (startDate == null || endDate == null) return false;
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(startDate!) && !d.isAfter(endDate!);
  }

  @override
  List<Object?> get props => [id, name, startDate, endDate];
}

const _weekdayNames = <int, String>{
  DateTime.monday: 'Monday',
  DateTime.tuesday: 'Tuesday',
  DateTime.wednesday: 'Wednesday',
  DateTime.thursday: 'Thursday',
  DateTime.friday: 'Friday',
  DateTime.saturday: 'Saturday',
  DateTime.sunday: 'Sunday',
};

/// One of a doctor's schedules from `GET /doctors/{id}/time-tables` — the
/// recurring weekly template ([schedules], one entry per weekday) that's
/// valid between [startDate]/[endDate], minus any [holidays].
class DoctorTimeTableModel extends Equatable {
  final int id;
  final String name;
  final String? notes;
  final String type; // "clinic" | ...
  final String scheduleType; // "all_days" | ...
  final DateTime? startDate;
  final DateTime? endDate;
  final int closestDateAfterNoDays;
  final List<TimeTableScheduleModel> schedules;
  final List<TimeTableHolidayModel> holidays;

  const DoctorTimeTableModel({
    required this.id,
    required this.name,
    this.notes,
    required this.type,
    required this.scheduleType,
    this.startDate,
    this.endDate,
    this.closestDateAfterNoDays = 0,
    this.schedules = const [],
    this.holidays = const [],
  });

  factory DoctorTimeTableModel.fromJson(Map<String, dynamic> json) => DoctorTimeTableModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        notes: json['notes'] as String?,
        type: json['type'] as String? ?? '',
        scheduleType: json['schedule_type'] as String? ?? '',
        startDate: DateTime.tryParse(json['start_date'] as String? ?? ''),
        endDate: DateTime.tryParse(json['end_date'] as String? ?? ''),
        closestDateAfterNoDays: json['closest_date_after_no_days'] as int? ?? 0,
        schedules: (json['schedules'] as List<dynamic>? ?? [])
            .map((e) => TimeTableScheduleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        holidays: (json['holidays'] as List<dynamic>? ?? [])
            .map((e) => TimeTableHolidayModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  bool _inRange(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    if (startDate != null && d.isBefore(DateTime(startDate!.year, startDate!.month, startDate!.day))) return false;
    if (endDate != null && d.isAfter(DateTime(endDate!.year, endDate!.month, endDate!.day))) return false;
    return true;
  }

  bool _isHoliday(DateTime date) => holidays.any((h) => h.covers(date));

  /// All of [date]'s weekday slots (available and not) — empty if [date]
  /// falls outside this schedule's date range or on a holiday.
  List<TimeTableSlotModel> slotsFor(DateTime date) {
    if (!_inRange(date) || _isHoliday(date)) return const [];
    final dayName = _weekdayNames[date.weekday];
    for (final schedule in schedules) {
      if (schedule.day == dayName) return schedule.times.map((s) => s.withTimeTableId(id)).toList();
    }
    return const [];
  }

  @override
  List<Object?> get props =>
      [id, name, notes, type, scheduleType, startDate, endDate, closestDateAfterNoDays, schedules, holidays];
}

/// Combines a doctor's `type: "clinic"` time-tables into simple
/// day/slot lookups for the booking calendar (ignores telemed-type
/// schedules, if any — that flow has its own separate mock sheet).
class DoctorAvailability {
  DoctorAvailability(List<DoctorTimeTableModel> timeTables)
      : _timeTables = timeTables.where((t) => t.type == 'clinic').toList();

  final List<DoctorTimeTableModel> _timeTables;

  bool get isEmpty => _timeTables.isEmpty;

  /// The latest `end_date` across all clinic time-tables — caps how far
  /// forward the booking calendar lets you navigate. `null` means no cap.
  DateTime? get maxEndDate {
    DateTime? latest;
    for (final t in _timeTables) {
      final end = t.endDate;
      if (end == null) continue;
      if (latest == null || end.isAfter(latest)) latest = end;
    }
    return latest;
  }

  /// All slots (available and not) across every clinic time-table for
  /// [date], sorted chronologically.
  List<TimeTableSlotModel> slotsFor(DateTime date) {
    final slots = <TimeTableSlotModel>[];
    for (final t in _timeTables) {
      slots.addAll(t.slotsFor(date));
    }
    slots.sort((a, b) {
      final ta = a.time24;
      final tb = b.time24;
      if (ta == null || tb == null) return 0;
      return (ta.$1 * 60 + ta.$2).compareTo(tb.$1 * 60 + tb.$2);
    });
    return slots;
  }

  int availableCountFor(DateTime date) => slotsFor(date).where((s) => s.available).length;

  bool hasAvailability(DateTime date) => availableCountFor(date) > 0;
}
