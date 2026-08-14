import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/family_member_model.dart';

/// One row on [FamilyScreen] — avatar initial, name, age/phone.
class FamilyMemberCard extends StatelessWidget {
  const FamilyMemberCard({super.key, required this.member, required this.onTap});

  final FamilyMemberModel member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final age = member.age;
    final subtitleParts = [
      if (age != null) '$age ${LocaleKeys.home_ageUnit.tr()}',
      if (member.phone != null && member.phone!.isNotEmpty) member.phone!,
    ];

    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            alignment: Alignment.center,
            child: Text(member.avatarLetter,
                style: TextStyle(
                    fontFamily: AppFonts.headingFont,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: primary)),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(member.name,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor.themeColor),
                if (subtitleParts.isNotEmpty) ...[
                  2.height,
                  AppText(subtitleParts.join(' · '), fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
