import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble.user(this.text, {super.key})
      : isUser = true,
        warning = null;

  const ChatBubble.ai(this.text, {super.key, this.warning}) : isUser = false;

  final String text;
  final bool isUser;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        constraints: BoxConstraints(maxWidth: 0.82.sw),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryColor.themeColor : AppColors.cardColor.themeColor,
          border: isUser ? null : Border.all(color: AppColors.dividerColor.themeColor),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(isUser ? 18.r : 4.r),
            bottomRight: Radius.circular(isUser ? 4.r : 18.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontFamily: AppFonts.bodyFont,
                fontSize: 12.5.sp,
                height: 1.8,
                color: isUser ? Colors.white : AppColors.textPrimaryColor.themeColor,
              ),
            ),
            if (warning != null) ...[
              8.height,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor.themeColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 14.sp, color: AppColors.warningColor.themeColor),
                    6.width,
                    Expanded(
                      child: Text(
                        warning!,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          color: AppColors.textSecondaryColor.themeColor,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
