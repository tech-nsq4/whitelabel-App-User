import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';

class DoctorOnlineConsultCard extends StatelessWidget {
  const DoctorOnlineConsultCard({super.key, required this.onBook});

  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return AppCard(
      padding: 14.paddingAll,
      borderColor: primary.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.12),
                ),
                child: Icon(Icons.videocam_rounded, color: primary, size: 20.sp),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      LocaleKeys.booking_onlineConsultationTitle.tr(),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                    3.height,
                    AppText(
                      LocaleKeys.booking_onlineConsultationSubtitle.tr(),
                      fontSize: 11,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.height,
          CustomButton(
            title: LocaleKeys.booking_bookOnlineAction.tr(),
            height: 38,
            fontSize: 12,
            onTap: onBook,
          ),
        ],
      ),
    );
  }
}
