import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../booking/data/models/doctor_model.dart';

/// Returns the chosen slot label (e.g. "الآن") if the user confirmed, or
/// null if they dismissed the sheet.
Future<String?> showTelemedSlotSheet(BuildContext context, DoctorModel doctor) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => TelemedSlotSheet(doctor: doctor),
  );
}

class TelemedSlotSheet extends StatefulWidget {
  const TelemedSlotSheet({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<TelemedSlotSheet> createState() => _TelemedSlotSheetState();
}

class _TelemedSlotSheetState extends State<TelemedSlotSheet> {
  int _slotIndex = 0;
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final slots = ['الآن', '4:30 م', '5:00 م', '6:30 م'];
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
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
          AppText('موعد الجلسة',
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          4.height,
          Row(children: [
            AppText('مع ', fontSize: 12.5, color: AppColors.mutedColor.themeColor),
            AppText(widget.doctor.name,
                fontSize: 12.5, fontWeight: FontWeight.w700, color: primary),
          ]),
          16.height,
          Row(
            children: [
              for (var i = 0; i < slots.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _slotIndex = i),
                    child: Container(
                      margin: EdgeInsets.only(left: i == slots.length - 1 ? 0 : 8.w),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: _slotIndex == i ? primary : AppColors.surfaceColor.themeColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        slots[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _slotIndex == i
                              ? Colors.white
                              : AppColors.textPrimaryColor.themeColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          16.height,
          GestureDetector(
            onTap: () => setState(() => _agreed = !_agreed),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(
                    color: _agreed ? primary : Colors.transparent,
                    border: Border.all(
                        color: _agreed ? primary : AppColors.hintColor.themeColor,
                        width: 2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: _agreed
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                10.width,
                Expanded(
                  child: AppText('قرأت اتفاقية الاستشارات عن بعد وأوافق عليها',
                      fontSize: 11, color: AppColors.textSecondaryColor.themeColor),
                ),
              ],
            ),
          ),
          20.height,
          CustomButton(
            title: 'متابعة للدفع',
            color: _agreed ? null : AppColors.hintColor.themeColor,
            onTap: _agreed
                ? () => Navigator.pop(context, slots[_slotIndex])
                : () {},
          ),
        ],
      ),
    );
  }
}
