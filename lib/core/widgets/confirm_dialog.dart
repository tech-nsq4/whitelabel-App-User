import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_button.dart';
import 'app_text.dart';

/// Icon + title + message + cancel/confirm buttons — the app's generic
/// "are you sure?" prompt (e.g. cancelling a booking). Resolves `true` only
/// when confirm is tapped; dismissing or tapping cancel resolves `false`.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  Color? iconColor,
  Color? confirmColor,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => ConfirmDialog(
      icon: icon,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      iconColor: iconColor,
      confirmColor: confirmColor,
    ),
  );
  return confirmed ?? false;
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.iconColor,
    this.confirmColor,
  });

  final IconData icon;
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? iconColor;
  final Color? confirmColor;

  @override
  Widget build(BuildContext context) {
    final color = confirmColor ?? AppColors.errorColor.themeColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: AppColors.cardColor.themeColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68.r,
              height: 68.r,
              decoration: BoxDecoration(
                color: (iconColor ?? color).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor ?? color, size: 32.sp),
            ),
            18.height,
            AppText(
              title,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            10.height,
            AppText(
              message,
              fontSize: 13,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            28.height,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context, false),
                    title: cancelLabel,
                    isOutlined: true,
                    borderColor: AppColors.dividerColor.themeColor,
                    textColor: AppColors.textSecondaryColor.themeColor,
                    color: Colors.transparent,
                  ),
                ),
                12.width,
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context, true),
                    title: confirmLabel,
                    color: color,
                    borderColor: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
