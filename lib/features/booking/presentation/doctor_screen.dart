import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import '../../payments/presentation/widgets/payment_sheet.dart';
import '../data/doctors_mock_data.dart';
import 'widgets/booking_confirmed_dialog.dart';
import 'widgets/booking_slots_sheet.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key, required this.doctorId});

  final String doctorId;

  Future<void> _book(BuildContext context) async {
    final doctor = DoctorsMockData.byId(doctorId);
    if (doctor == null) return;
    final slot = await showBookingSlotsSheet(context, doctor);
    if (slot == null || !context.mounted) return;
    final paid = await showPaymentSheet(
      context,
      title: 'كشف ${doctor.specialty}',
      detail: '${doctor.name} · ${slot.day} ${slot.time}',
      amountLabel: '150 ريال',
    );
    if (paid != true || !context.mounted) return;
    showBookingConfirmedDialog(
      context,
      doctor: doctor.name,
      when: '${slot.day} · ${slot.time}',
      branch: doctor.branch,
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = DoctorsMockData.byId(doctorId);
    final primary = AppColors.primaryColor.themeColor;

    if (doctor == null) {
      return const Scaffold(body: Center(child: Text('الطبيب غير متاح')));
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 100.h),
              children: [
                const ScreenHeader(title: 'ملف الطبيب'),
                AppCard(
                  margin: EdgeInsets.only(bottom: 14.h),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 62.r,
                            height: 62.r,
                            decoration:
                                BoxDecoration(color: primary, borderRadius: BorderRadius.circular(20.r)),
                            alignment: Alignment.center,
                            child: Text(doctor.avatarLetter,
                                style: TextStyle(
                                    fontFamily: AppFonts.headingFont,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                          14.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(doctor.name,
                                    isHeading: true,
                                    fontSize: 17,
                                    color: AppColors.textPrimaryColor.themeColor),
                                2.height,
                                AppText(doctor.specialty,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: primary),
                                7.height,
                                Wrap(spacing: 6.w, runSpacing: 6.h, children: [
                                  _pill(doctor.branch),
                                  _pill('${doctor.experienceYears} سنة خبرة'),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                      15.height,
                      Container(
                        padding: EdgeInsets.only(top: 15.h),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: AppColors.dividerColor.themeColor)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_rounded,
                                          color: AppColors.accentGold.themeColor, size: 15.sp),
                                      4.width,
                                      Text('${doctor.rating}',
                                          style: TextStyle(
                                              fontFamily: AppFonts.headingFont,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimaryColor.themeColor)),
                                    ],
                                  ),
                                  AppText('التقييم', fontSize: 9.5, color: AppColors.mutedColor.themeColor),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('${doctor.reviewCount}',
                                      style: TextStyle(
                                          fontFamily: AppFonts.headingFont,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimaryColor.themeColor)),
                                  AppText('تقييمًا', fontSize: 9.5, color: AppColors.mutedColor.themeColor),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(doctor.isAvailableNow ? 'اليوم' : doctor.nextSlotLabel,
                                      style: TextStyle(
                                          fontFamily: AppFonts.headingFont,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: primary)),
                                  AppText('أقرب موعد', fontSize: 9.5, color: AppColors.mutedColor.themeColor),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text('نبذة',
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.mutedColor.themeColor)),
                10.height,
                AppCard(
                  margin: EdgeInsets.only(bottom: 14.h),
                  child: AppText(doctor.bio,
                      fontSize: 12.5, color: AppColors.textSecondaryColor.themeColor, height: 1.8),
                ),
                Text('الحالات التي يستقبلها',
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.mutedColor.themeColor)),
                10.height,
                Wrap(
                  spacing: 7.w,
                  runSpacing: 8.h,
                  children: [for (final c in doctor.conditions) _pill(c)],
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                decoration: BoxDecoration(color: AppColors.backgroundColor.themeColor),
                child: CustomButton(
                  title: 'المواعيد المتاحة',
                  onTap: () => _book(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Builder(builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondaryColor.themeColor)),
      );
    });
  }
}
