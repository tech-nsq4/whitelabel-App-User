import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/screen_state_layout.dart';
import '../../../family/data/models/family_member_model.dart';
import '../../../family/logic/family_cubit.dart';
import '../../../offers/data/models/applied_offer.dart';
import '../../data/models/doctor_profile_model.dart';
import '../../data/models/doctor_time_table_model.dart';
import '../../logic/time_tables_cubit.dart';
import 'booking_calendar.dart';
import 'doctor_clinic_selector.dart';
import 'booking_family_member_selector.dart';
import 'booking_summary_card.dart';
import 'booking_time_slot_grid.dart';
import 'no_slots_view.dart';

/// Formats [date] as e.g. "الخميس 16 يوليو" / "Thursday 16 July".
String formatBookingDayLabel(DateTime date, String locale) =>
    '${DateFormat('EEEE', locale).format(date)} ${date.day} ${DateFormat('MMMM', locale).format(date)}';

String formatNearestAvailableDayLabel(DateTime date, String locale) {
  final now = DateTime.now();
  final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
  return isToday ? LocaleKeys.common_today.tr() : formatBookingDayLabel(date, locale);
}

class BookingSlotResult {
  const BookingSlotResult({required this.date, required this.slot, this.clinicId, this.familyMember});

  final DateTime date;
  final TimeTableSlotModel slot;
  final int? clinicId;

  /// The family member this appointment is for — `null` means the account
  /// holder is booking for themselves.
  final FamilyMemberModel? familyMember;

  String dayLabel(String locale) => formatBookingDayLabel(date, locale);
  String get timeLabel => slot.displayLabel;
}

Future<BookingSlotResult?> showBookingSlotsSheet(
  BuildContext context,
  DoctorProfileModel doctor, {
  String? ctaLabel,
  bool showFamilyMemberSelector = true,
  int? clinicId,
  AppliedOffer? offer,
}) {
  return showModalBottomSheet<BookingSlotResult>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => BookingSlotsSheet(
      doctor: doctor,
      ctaLabel: ctaLabel,
      showFamilyMemberSelector: showFamilyMemberSelector,
      clinicId: clinicId,
      offer: offer,
    ),
  );
}

/// "Choose day & time" sheet, backed by `GET /doctors/{id}/time-tables` —
/// a month calendar (each day shows its available-slot count) followed by
/// that day's time-slot grid and a booking summary. Reused as-is for
/// rescheduling ([showFamilyMemberSelector]: `false` — reschedule doesn't
/// change who it's for — with a [ctaLabel] that reads "confirm" instead of
/// "continue to payment").
class BookingSlotsSheet extends StatefulWidget {
  const BookingSlotsSheet({
    super.key,
    required this.doctor,
    this.ctaLabel,
    this.showFamilyMemberSelector = true,
    this.clinicId,
    this.offer,
  });

  final DoctorProfileModel doctor;
  final String? ctaLabel;
  final bool showFamilyMemberSelector;
  final int? clinicId;
  final AppliedOffer? offer;

  @override
  State<BookingSlotsSheet> createState() => _BookingSlotsSheetState();
}

class _BookingSlotsSheetState extends State<BookingSlotsSheet> {
  late final TimeTablesCubit _cubit = getIt<TimeTablesCubit>();
  late final FamilyCubit _familyCubit = getIt<FamilyCubit>();
  late DateTime _displayedMonth = DateTime(_today.year, _today.month);
  late int? _selectedClinicId = widget.clinicId ??
      (widget.doctor.clinics.isEmpty ? null : widget.doctor.clinics.first.id);
  DateTime? _selectedDate;
  TimeTableSlotModel? _selectedSlot;
  FamilyMemberModel? _selectedFamilyMember;
  bool _autoSelected = false;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  double get _finalPrice =>
      widget.offer?.finalPriceFor(widget.doctor.price) ?? widget.doctor.price;

  @override
  void initState() {
    super.initState();
    _cubit.getTimeTables(widget.doctor.id, clinicId: _selectedClinicId);
    // A guest has no `/family-members` to fetch (and the selector already
    // falls back to just "myself" on anything but `FamilySuccess`) — skip
    // the guaranteed-to-401 call entirely, same as `FamilyScreen`.
    if (!kIsGuest) _familyCubit.getFamilyMembers();
  }

  @override
  void dispose() {
    _cubit.close();
    _familyCubit.close();
    super.dispose();
  }

  /// Once the schedule is in, jump straight to the first day (within the
  /// next ~6 months) that actually has an open slot, instead of dropping
  /// the user on an empty calendar they'd have to hunt through themselves.
  void _autoSelectFirstAvailable(DoctorAvailability availability) {
    if (_autoSelected) return;
    _autoSelected = true;
    for (var i = 0; i < 180; i++) {
      final date = _today.add(Duration(days: i));
      if (!availability.hasAvailability(date)) continue;
      _selectDate(date, availability, resetMonth: true);
      return;
    }
  }

  void _changeMonth(int delta) {
    setState(() => _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + delta));
  }

  void _onSelectClinic(int id) {
    if (id == _selectedClinicId) return;
    setState(() {
      _selectedClinicId = id;
      _selectedDate = null;
      _selectedSlot = null;
      _autoSelected = false;
      _displayedMonth = DateTime(_today.year, _today.month);
    });
    _cubit.getTimeTables(widget.doctor.id, clinicId: id);
  }

  void _selectDate(DateTime date, DoctorAvailability availability, {bool resetMonth = false}) {
    if (date == _selectedDate) return; // already selected — no point re-fetching
    setState(() {
      _selectedDate = date;
      // Deliberately not set from `availability.slotsFor(date)` here: that's
      // still just the generic weekly template, not confirmed for this
      // exact date, so nothing gets treated as bookable (CTA stays
      // disabled — see its `onTap` below) until `refreshDaySlots` confirms
      // real availability and `_pickFirstAvailableSlot` runs.
      _selectedSlot = null;
      if (resetMonth) _displayedMonth = DateTime(date.year, date.month);
    });
    _cubit.refreshDaySlots(widget.doctor.id, date, clinicId: _selectedClinicId);
  }

  /// Auto-picks the first available slot once [availability] reflects
  /// backend-confirmed data for [_selectedDate] — covers both the initial
  /// auto-selected day and a manually tapped one, since neither picks a
  /// slot up front anymore (see `_selectDate`). No-ops if something's
  /// already selected, or nothing needs picking yet.
  void _pickFirstAvailableSlot(DoctorAvailability availability) {
    final date = _selectedDate;
    if (date == null || _selectedSlot != null) return;
    // Still just the generic template for this date — wait for
    // `refreshDaySlots` to actually confirm it before picking anything.
    if (!availability.hasConfirmedDate(date)) return;
    for (final s in availability.slotsFor(date)) {
      if (s.available) {
        setState(() => _selectedSlot = s);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        constraints: BoxConstraints(maxHeight: 0.92.sh),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _cubit),
            BlocProvider.value(value: _familyCubit),
          ],
          child: BlocConsumer<TimeTablesCubit, TimeTablesState>(
            listener: (context, state) {
              if (state is TimeTablesSuccess) {
                _autoSelectFirstAvailable(state.availability);
                _pickFirstAvailableSlot(state.availability);
              }
            },
            builder: (context, state) {
              final isDaySlotsLoading = state is TimeTablesDaySlotsLoading;
              final currentAvailability = switch (state) {
                TimeTablesSuccess(:final availability) => availability,
                TimeTablesDaySlotsLoading(:final availability) => availability,
                _ => null,
              };
              final hasNoAppointments = currentAvailability?.isEmpty ?? false;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(LocaleKeys.booking_chooseDateTime.tr(),
                            isHeading: true,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close_rounded, color: AppColors.mutedColor.themeColor),
                      ),
                    ],
                  ),
                  if (widget.doctor.clinics.length > 1) ...[
                    14.height,
                    AppText(LocaleKeys.booking_selectClinic.tr(),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryColor.themeColor),
                    10.height,
                    DoctorClinicSelector(
                      clinics: widget.doctor.clinics,
                      selectedId: _selectedClinicId,
                      onSelect: _onSelectClinic,
                    ),
                  ],
                  16.height,
                  Flexible(
                    child: SingleChildScrollView(
                      child: CustomScreenStateLayout(
                        isLoading: state is TimeTablesLoading || state is TimeTablesInitial,
                        error: state is TimeTablesError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getTimeTables(widget.doctor.id, clinicId: _selectedClinicId),
                        builder: (context) {
                          final availability = currentAvailability!;
                          if (availability.isEmpty) return const NoSlotsView();

                          final selectedDate = _selectedDate;
                          final slots =
                              selectedDate == null ? const <TimeTableSlotModel>[] : availability.slotsFor(selectedDate);
                          final maxEndDate = availability.maxEndDate;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BookingCalendar(
                                month: _displayedMonth,
                                selectedDate: selectedDate,
                                availability: availability,
                                earliestSelectableDate: _today,
                                onSelectDate: (d) => _selectDate(d, availability),
                                onPrevMonth: () => _changeMonth(-1),
                                onNextMonth: () => _changeMonth(1),
                                canGoPrev: _displayedMonth.isAfter(DateTime(_today.year, _today.month)),
                                canGoNext: maxEndDate == null ||
                                    !_displayedMonth.isAfter(DateTime(maxEndDate.year, maxEndDate.month)),
                              ),
                              if (selectedDate != null) ...[
                                18.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(formatBookingDayLabel(selectedDate, locale),
                                        style: TextStyle(
                                            fontSize: 12.5.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimaryColor.themeColor)),
                                    // Hidden while the real count for this
                                    // date is still loading — the template
                                    // count isn't confirmed yet.
                                    if (!isDaySlotsLoading)
                                      Text(
                                          LocaleKeys.booking_availableSlotsCount.tr(namedArgs: {
                                            'count': '${slots.where((s) => s.available).length}'
                                          }),
                                          style: TextStyle(fontSize: 11.sp, color: AppColors.mutedColor.themeColor)),
                                  ],
                                ),
                                12.height,
                                // The calendar's slots are just the generic
                                // weekly template until `refreshDaySlots`
                                // confirms this exact date's real
                                // booked/available state — show a spinner
                                // instead of that unconfirmed data meanwhile.
                                if (isDaySlotsLoading)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24.h),
                                    child: CustomLoadingWidget(size: 32.h, color: AppColors.primaryColor.themeColor),
                                  )
                                else if (slots.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.h),
                                    child: Center(
                                      child: Text(LocaleKeys.booking_noSlotsForDay.tr(),
                                          style: TextStyle(fontSize: 12.sp, color: AppColors.mutedColor.themeColor)),
                                    ),
                                  )
                                else
                                  BookingTimeSlotGrid(
                                    slots: slots,
                                    selected: _selectedSlot,
                                    onSelect: (s) => setState(() => _selectedSlot = s),
                                  ),
                                if (widget.showFamilyMemberSelector) ...[
                                  18.height,
                                  AppText(LocaleKeys.booking_bookForLabel.tr(),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimaryColor.themeColor),
                                  10.height,
                                  BookingFamilyMemberSelector(
                                    selected: _selectedFamilyMember,
                                    onSelect: (m) => setState(() => _selectedFamilyMember = m),
                                  ),
                                ],
                                18.height,
                                BookingSummaryCard(
                                  doctorName: widget.doctor.name,
                                  patientName: _selectedFamilyMember?.name,
                                  whenLabel: _selectedSlot == null
                                      ? '—'
                                      : '${formatBookingDayLabel(selectedDate, locale)} · ${_selectedSlot!.displayLabel}',
                                  clinicName: widget.doctor.clinicById(_selectedClinicId)?.name,
                                  priceLabel: formatPriceLabel(_finalPrice),
                                  strikePriceLabel:
                                      _finalPrice < widget.doctor.price ? formatPriceLabel(widget.doctor.price) : null,
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  if (!hasNoAppointments) ...[
                    16.height,
                    CustomButton(
                      title: widget.ctaLabel ?? LocaleKeys.booking_continueToPayment.tr(),
                      color: _selectedSlot == null ? AppColors.hintColor.themeColor : null,
                      onTap: _selectedSlot == null || _selectedDate == null
                          ? () {}
                          : () => Navigator.pop(
                              context,
                              BookingSlotResult(
                                date: _selectedDate!,
                                slot: _selectedSlot!,
                                clinicId: _selectedClinicId,
                                familyMember: _selectedFamilyMember,
                              )),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
