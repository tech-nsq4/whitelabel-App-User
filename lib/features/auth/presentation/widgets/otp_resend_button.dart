import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

/// "Didn't get the code?" action under the OTP boxes — shows a live mm:ss
/// countdown while the resend cooldown is running, and turns into a
/// tappable resend button once it reaches zero.
class OtpResendButton extends StatelessWidget {
  const OtpResendButton({
    super.key,
    required this.secondsLeft,
    required this.isResending,
    required this.onResend,
  });

  final int secondsLeft;
  final bool isResending;
  final VoidCallback onResend;

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final canResend = secondsLeft <= 0 && !isResending;
    final color = canResend
        ? AppColors.accentGold.themeColor
        : AppColors.mutedColor.themeColor;

    return Center(
      child: TextButton(
        onPressed: canResend ? onResend : null,
        child: AppText(
          canResend
              ? LocaleKeys.auth_otpResend.tr()
              : LocaleKeys.auth_otpResendIn
                  .tr(namedArgs: {'time': _format(secondsLeft)}),
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
