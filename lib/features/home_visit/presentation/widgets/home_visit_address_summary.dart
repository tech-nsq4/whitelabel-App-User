import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/home_visit_address.dart';

class HomeVisitAddressSummary extends StatelessWidget {
  const HomeVisitAddressSummary({
    super.key,
    required this.address,
    this.onEdit,
  });

  final HomeVisitAddress address;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final muted = AppColors.mutedColor.themeColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: AppSvgIcon(AppSvgIcons.mapPin, size: 17.r, color: primary),
        ),
        10.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                LocaleKeys.homeVisit_addressTitle.tr(),
                fontSize: 11,
                color: muted,
              ),
              2.height,
              AppText(
                address.address,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                color: AppColors.textPrimaryColor.themeColor,
              ),
              if (address.notes.isNotEmpty) ...[
                2.height,
                AppText(
                  address.notes,
                  fontSize: 11,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  color: muted,
                ),
              ],
            ],
          ),
        ),
        if (onEdit != null) ...[
          8.width,
          CustomTapEffect(
            onTap: onEdit,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: primary),
              ),
              child: AppText(
                LocaleKeys.homeVisit_changeAddress.tr(),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
