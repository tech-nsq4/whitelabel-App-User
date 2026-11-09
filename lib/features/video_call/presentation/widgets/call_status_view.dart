import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_loading_widget.dart';

class CallStatusView extends StatelessWidget {
  const CallStatusView.connecting({super.key})
      : errorMessage = null,
        onClose = null;

  const CallStatusView.error({
    super.key,
    required String this.errorMessage,
    required VoidCallback this.onClose,
  });

  final String? errorMessage;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final message = errorMessage;
    return Center(
      child: Padding(
        padding: 24.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message == null) ...[
              const CustomLoadingWidget(color: Colors.white),
              16.height,
              AppText(LocaleKeys.videoCall_connecting.tr(),
                  fontSize: 14, color: Colors.white70),
            ] else ...[
              Icon(Icons.error_outline, color: Colors.white70, size: 48.sp),
              16.height,
              AppText(message,
                  fontSize: 14,
                  color: Colors.white70,
                  textAlign: TextAlign.center),
              24.height,
              TextButton(
                onPressed: onClose,
                child: AppText(LocaleKeys.videoCall_close.tr(),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
