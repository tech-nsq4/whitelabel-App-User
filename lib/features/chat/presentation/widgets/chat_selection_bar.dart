import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class ChatSelectionBar extends StatelessWidget {
  const ChatSelectionBar({
    super.key,
    required this.count,
    required this.onClose,
    required this.onDelete,
  });

  final int count;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        border: Border(bottom: BorderSide(color: AppColors.dividerColor.themeColor)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            CustomTapEffect(
              onTap: onClose,
              child: Icon(Icons.close, size: 22.sp, color: AppColors.textPrimaryColor.themeColor),
            ),
            14.width,
            Expanded(
              child: AppText(
                LocaleKeys.chat_selectedCount.tr(namedArgs: {'count': '$count'}),
                isHeading: true,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor,
              ),
            ),
            CustomTapEffect(
              onTap: onDelete,
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 24.sp,
                  color: AppColors.errorColor.themeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
