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
import '../../../location_picker/data/models/picked_location.dart';

class HomeVisitLocationCard extends StatelessWidget {
  const HomeVisitLocationCard({
    super.key,
    required this.onTap,
    this.location,
    this.showError = false,
  });

  final VoidCallback onTap;
  final PickedLocation? location;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final errorColor = AppColors.errorColor.themeColor;
    final picked = location;
    final borderColor = showError
        ? errorColor
        : picked != null
            ? primary
            : AppColors.dividerColor.themeColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTapEffect(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: borderColor, width: picked != null ? 1.4 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: AppSvgIcon(AppSvgIcons.mapPin, size: 22.r, color: primary),
                ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        picked?.displayAddress ?? LocaleKeys.homeVisit_pickLocation.tr(),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                      4.height,
                      AppText(
                        picked == null
                            ? LocaleKeys.homeVisit_pickLocationHint.tr()
                            : LocaleKeys.homeVisit_changeLocation.tr(),
                        fontSize: 12.sp,
                        color: AppColors.textSecondaryColor.themeColor,
                      ),
                    ],
                  ),
                ),
                8.width,
                AppSvgIcon(AppSvgIcons.chevronRow, size: 18.r, color: AppColors.hintColor.themeColor),
              ],
            ),
          ),
        ),
        if (showError) ...[
          6.height,
          AppText(LocaleKeys.homeVisit_locationRequired.tr(), fontSize: 12.sp, color: errorColor),
        ],
      ],
    );
  }
}
