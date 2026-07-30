import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/doctors_mock_data.dart';

class SpecsScreen extends StatefulWidget {
  const SpecsScreen({super.key, this.initialSpecialty});

  final String? initialSpecialty;

  @override
  State<SpecsScreen> createState() => _SpecsScreenState();
}

class _SpecsScreenState extends State<SpecsScreen> {
  String? _specialty;

  @override
  void initState() {
    super.initState();
    _specialty = widget.initialSpecialty;
  }

  @override
  Widget build(BuildContext context) {
    final specialty = _specialty;
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(
              title: specialty ?? 'اختر التخصص',
              subtitle: specialty == null ? null : '${DoctorsMockData.bySpecialty[specialty]?.length ?? 0} أطباء',
              onBack: specialty == null ? null : () => setState(() => _specialty = null),
            ),
            if (specialty == null)
              for (final s in DoctorsMockData.specialties)
                AppCard(
                  margin: EdgeInsets.only(bottom: 10.h),
                  onTap: () => setState(() => _specialty = s),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText(s,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                      ),
                      AppText('${DoctorsMockData.bySpecialty[s]?.length ?? 0} طبيب',
                          fontSize: 11, color: AppColors.mutedColor.themeColor),
                    ],
                  ),
                )
            else
              for (final doc in DoctorsMockData.bySpecialty[specialty] ?? const [])
                AppCard(
                  margin: EdgeInsets.only(bottom: 10.h),
                  onTap: () => Navigator.pushNamed(context, Routes.doctor,
                      arguments: {'id': doc.id}),
                  child: Row(
                    children: [
                      Container(
                        width: 50.r,
                        height: 50.r,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor.themeColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(doc.avatarLetter,
                            style: TextStyle(
                                fontFamily: AppFonts.headingFont,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: primary)),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(doc.name,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryColor.themeColor),
                            2.height,
                            AppText('${doc.specialty} · ${doc.experienceYears} سنة خبرة',
                                fontSize: 11, color: AppColors.mutedColor.themeColor),
                            5.height,
                            Row(
                              children: [
                                Icon(Icons.star_rounded, color: AppColors.accentGold.themeColor, size: 14.sp),
                                4.width,
                                Text('${doc.rating}',
                                    style: TextStyle(
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimaryColor.themeColor)),
                                4.width,
                                AppText('(${doc.reviewCount})',
                                    fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
