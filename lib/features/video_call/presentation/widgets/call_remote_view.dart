import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class CallRemoteView extends StatelessWidget {
  const CallRemoteView({super.key, this.view, required this.showWaiting});

  final Widget? view;
  final bool showWaiting;

  @override
  Widget build(BuildContext context) {
    if (view != null) return view!;
    return Container(
      color: AppColors.callBackgroundColor.themeColor,
      alignment: Alignment.center,
      padding: 24.paddingHorizontal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam_outlined, color: Colors.white38, size: 56.sp),
          12.height,
          if (showWaiting)
            AppText(
              LocaleKeys.videoCall_waitingOther.tr(),
              fontSize: 14,
              color: Colors.white54,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
