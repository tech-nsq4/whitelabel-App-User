import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_model.dart';

class BookingSlotResult {
  const BookingSlotResult(this.day, this.time);
  final String day;
  final String time;
}

Future<BookingSlotResult?> showBookingSlotsSheet(
  BuildContext context,
  DoctorModel doctor,
) {
  return showModalBottomSheet<BookingSlotResult>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => BookingSlotsSheet(doctor: doctor),
  );
}

class BookingSlotsSheet extends StatefulWidget {
  const BookingSlotsSheet({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<BookingSlotsSheet> createState() => _BookingSlotsSheetState();
}

class _BookingSlotsSheetState extends State<BookingSlotsSheet> {
  int _dayIndex = 0;
  int? _timeIndex = 0;

  static const _days = ['الخميس 16', 'الجمعة 17', 'السبت 18', 'الأحد 19'];
  static const _times = ['4:00 م', '4:15 م', '4:45 م', '5:15 م', '6:00 م'];

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 18.h),
              decoration: BoxDecoration(
                color: AppColors.hintColor.themeColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          AppText('اختر اليوم والوقت',
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          16.height,
          SizedBox(
            height: 42.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => setState(() {
                  _dayIndex = i;
                  _timeIndex = 0;
                }),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _dayIndex == i ? primary : AppColors.surfaceColor.themeColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(_days[i],
                      style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                          color: _dayIndex == i ? Colors.white : AppColors.textPrimaryColor.themeColor)),
                ),
              ),
            ),
          ),
          16.height,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (var i = 0; i < _times.length; i++)
                GestureDetector(
                  onTap: () => setState(() => _timeIndex = i),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
                    decoration: BoxDecoration(
                      color: _timeIndex == i ? primary : AppColors.cardColor.themeColor,
                      border: Border.all(
                          color: _timeIndex == i
                              ? Colors.transparent
                              : AppColors.dividerColor.themeColor),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(_times[i],
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: _timeIndex == i ? Colors.white : AppColors.textPrimaryColor.themeColor)),
                  ),
                ),
            ],
          ),
          20.height,
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('الطبيب', widget.doctor.name),
                _row('الموعد', '${_days[_dayIndex]} · ${_timeIndex != null ? _times[_timeIndex!] : '—'}'),
                _row('الفرع', widget.doctor.branch),
              ],
            ),
          ),
          16.height,
          CustomButton(
            title: 'متابعة للدفع',
            color: _timeIndex == null ? AppColors.hintColor.themeColor : null,
            onTap: _timeIndex == null
                ? () {}
                : () => Navigator.pop(
                      context,
                      BookingSlotResult(_days[_dayIndex], _times[_timeIndex!]),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: TextStyle(fontSize: 11.sp, color: AppColors.mutedColor.themeColor)),
          Text(v,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor)),
        ],
      ),
    );
  }
}
