import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/screen_state_layout.dart';
import '../../../family/data/models/family_member_model.dart';
import '../../../family/logic/family_cubit.dart';
import '../../data/models/doctor_profile_model.dart';
import '../../data/models/doctor_time_table_model.dart';
import '../../logic/time_tables_cubit.dart';
import 'booking_calendar.dart';
import 'booking_family_member_selector.dart';
import 'booking_summary_card.dart';
import 'booking_time_slot_grid.dart';
import 'no_slots_view.dart';

/// Formats [date] as e.g. "الخميس 16 يوليو" / "Thursday 16 July".
String formatBookingDayLabel(DateTime date, String locale) =>
    '${DateFormat('EEEE', locale).format(date)} ${date.day} ${DateFormat('MMMM', locale).format(date)}';

class BookingSlotResult {
  const BookingSlotResult({required this.date, required this.slot, this.familyMember});

  final DateTime date;
  final TimeTableSlotModel slot;

  /// The family member this appointment is for — `null` means the account
  /// holder is booking for themselves.
  final FamilyMemberModel? familyMember;

  String dayLabel(String locale) => formatBookingDayLabel(date, locale);
  String get timeLabel => slot.displayLabel;
}

Future<BookingSlotResult?> showBookingSlotsSheet(
  BuildContext context,
  DoctorProfileModel doctor,
) {
  return showModalBottomSheet<BookingSlotResult>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => BookingSlotsSheet(doctor: doctor),
  );
}

/// "Choose day & time" sheet, backed by `GET /doctors/{id}/time-tables` —
/// a month calendar (each day shows its available-slot count) followed by
/// that day's time-slot grid and a booking summary.
class BookingSlotsSheet extends StatefulWidget {
  const BookingSlotsSheet({super.key, required this.doctor});

  final DoctorProfileModel doctor;

  @override
  State<BookingSlotsSheet> createState() => _BookingSlotsSheetState();
}

class _BookingSlotsSheetState extends State<BookingSlotsSheet> {
  late final TimeTablesCubit _cubit = getIt<TimeTablesCubit>();
  late final FamilyCubit _familyCubit = getIt<FamilyCubit>();
  late DateTime _displayedMonth = DateTime(_today.year, _today.month);
  DateTime? _selectedDate;
  TimeTableSlotModel? _selectedSlot;
  FamilyMemberModel? _selectedFamilyMember;
  bool _autoSelected = false;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _cubit.getTimeTables(widget.doctor.id);
    _familyCubit.getFamilyMembers();
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
      final slots = availability.slotsFor(date);
      TimeTableSlotModel firstAvailable = slots.first;
      for (final s in slots) {
        if (s.available) {
          firstAvailable = s;
          break;
        }
      }
      setState(() {
        _selectedDate = date;
        _selectedSlot = firstAvailable;
        _displayedMonth = DateTime(date.year, date.month);
      });
      return;
    }
  }

  void _changeMonth(int delta) {
    setState(() => _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + delta));
  }

  void _selectDate(DateTime date, DoctorAvailability availability) {
    final slots = availability.slotsFor(date);
    TimeTableSlotModel? firstAvailable;
    for (final s in slots) {
      if (s.available) {
        firstAvailable = s;
        break;
      }
    }
    setState(() {
      _selectedDate = date;
      _selectedSlot = firstAvailable;
    });
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
              if (state is TimeTablesSuccess) _autoSelectFirstAvailable(state.availability);
            },
            builder: (context, state) {
              final hasNoAppointments = state is TimeTablesSuccess && state.availability.isEmpty;

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
                  16.height,
                  Flexible(
                    child: SingleChildScrollView(
                      child: CustomScreenStateLayout(
                        isLoading: state is TimeTablesLoading || state is TimeTablesInitial,
                        error: state is TimeTablesError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getTimeTables(widget.doctor.id),
                        builder: (context) {
                          final availability = (state as TimeTablesSuccess).availability;
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
                                    Text(
                                        LocaleKeys.booking_availableSlotsCount.tr(namedArgs: {
                                          'count': '${slots.where((s) => s.available).length}'
                                        }),
                                        style: TextStyle(fontSize: 11.sp, color: AppColors.mutedColor.themeColor)),
                                  ],
                                ),
                                12.height,
                                if (slots.isEmpty)
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
                                18.height,
                                BookingSummaryCard(
                                  doctorName: widget.doctor.name,
                                  patientName: _selectedFamilyMember?.name,
                                  whenLabel: _selectedSlot == null
                                      ? '—'
                                      : '${formatBookingDayLabel(selectedDate, locale)} · ${_selectedSlot!.displayLabel}',
                                  clinicName: widget.doctor.clinic?.name,
                                  priceLabel: '${widget.doctor.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
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
                      title: LocaleKeys.booking_continueToPayment.tr(),
                      color: _selectedSlot == null ? AppColors.hintColor.themeColor : null,
                      onTap: _selectedSlot == null || _selectedDate == null
                          ? () {}
                          : () => Navigator.pop(
                              context,
                              BookingSlotResult(
                                date: _selectedDate!,
                                slot: _selectedSlot!,
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
