import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class HomeVisitInlineError extends StatelessWidget {
  const HomeVisitInlineError({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText(message,
              fontSize: 11,
              color: AppColors.errorColor.themeColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        8.width,
        CustomTapEffect(
          onTap: onRetry,
          child: AppText(LocaleKeys.common_retry.tr(),
              fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primaryColor.themeColor),
        ),
      ],
    );
  }
}
