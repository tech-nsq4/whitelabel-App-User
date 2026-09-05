import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/booking_repo.dart';
import '../data/models/doctor_time_table_model.dart';

part 'time_tables_state.dart';

class TimeTablesCubit extends Cubit<TimeTablesState> {
  TimeTablesCubit(this._repo) : super(const TimeTablesInitial());

  final BookingRepo _repo;

  /// Guards against a slower, older [refreshDaySlots] call resolving after
  /// a newer one (e.g. two calendar taps in quick succession) and clobbering
  /// the state with stale data — only the request for whichever date this
  /// currently points at is allowed to `emit`.
  DateTime? _latestRequestedDate;

  /// The calendar-level fetch — no `date`, so the `available` flags it gets
  /// back are just the generic weekly template. Builds the calendar itself
  /// (which days have any schedule at all); [refreshDaySlots] is what
  /// confirms real per-date availability once a day is actually picked.
  Future<void> getTimeTables(int doctorId, {int? clinicId}) async {
    emit(const TimeTablesLoading());
    try {
      final timeTables = await _repo.getDoctorTimeTables(doctorId, clinicId: clinicId);
      emit(TimeTablesSuccess(DoctorAvailability(timeTables)));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(TimeTablesError(msg));
    }
  }

  DoctorAvailability? get _currentAvailability => switch (state) {
        TimeTablesSuccess(:final availability) => availability,
        TimeTablesDaySlotsLoading(:final availability) => availability,
        _ => null,
      };

  /// Re-fetches [date]'s slots with the real booked/available state
  /// (`GET .../time-tables?date=...`) and merges them into the current
  /// calendar — called every time the user picks a different day, since the
  /// template from [getTimeTables] can't reflect which slots are actually
  /// booked on any one specific date.
  Future<void> refreshDaySlots(int doctorId, DateTime date, {int? clinicId}) async {
    final availability = _currentAvailability;
    if (availability == null) return; // no calendar loaded yet
    _latestRequestedDate = date;
    emit(TimeTablesDaySlotsLoading(availability, date));
    try {
      final timeTables = await _repo.getDoctorTimeTables(doctorId, date: date, clinicId: clinicId);
      if (_latestRequestedDate != date) return; // superseded by a newer pick
      final daySlots = DoctorAvailability(timeTables).slotsFor(date);
      emit(TimeTablesSuccess(availability.withDateOverride(date, daySlots)));
    } catch (e) {
      if (_latestRequestedDate != date) return;
      final msg = e is NetworkException ? e.message : e.toString();
      // Non-blocking: keep the sheet usable with the template's slots for
      // this date rather than getting stuck on a transient refresh failure
      // (booking itself still goes through the backend, which is the real
      // guard against double-booking).
      AppOverlay.showError(msg);
      emit(TimeTablesSuccess(availability));
    }
  }
}
