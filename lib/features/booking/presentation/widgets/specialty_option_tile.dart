import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';

/// One selectable row on [SpecsScreen] — used for both the top-level
/// specializations list and, one level deeper, their sub-specializations.
class SpecialtyOptionTile extends StatelessWidget {
  const SpecialtyOptionTile({
    super.key,
    required this.title,
    required this.onTap,
    this.description,
    this.countLabel,
  });

  final String title;
  final String? description;
  final String? countLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                if (description != null && description!.isNotEmpty) ...[
                  3.height,
                  AppText(description!,
                      fontSize: 11,
                      color: AppColors.mutedColor.themeColor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          if (countLabel != null && countLabel!.isNotEmpty) ...[
            10.width,
            AppText(countLabel!, fontSize: 11, color: AppColors.mutedColor.themeColor),
          ],
        ],
      ),
    );
  }
}
