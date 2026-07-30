import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';

Future<void> showLanguageSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => LanguageSheet(parentContext: context),
  );
}

class LanguageSheet extends StatefulWidget {
  const LanguageSheet({super.key, required this.parentContext});

  final BuildContext parentContext;

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  late String _selected = widget.parentContext.locale.languageCode;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 18.h),
            decoration: BoxDecoration(
              color: AppColors.hintColor.themeColor,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          AppText('تغيير اللغة',
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          18.height,
          _option('ar', '🇸🇦', 'العربية', primary),
          10.height,
          _option('en', '🇬🇧', 'English', primary),
          20.height,
          CustomButton(
            title: 'تأكيد',
            onTap: () async {
              Navigator.pop(context);
              await getIt<LocalStorage>().setLang(_selected);
              await widget.parentContext.setLocale(Locale(_selected));
              if (!widget.parentContext.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  widget.parentContext, Routes.splashScreen, (_) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _option(String code, String flag, String label, Color primary) {
    final selected = _selected == code;
    return GestureDetector(
      onTap: () => setState(() => _selected = code),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: selected ? primary.withValues(alpha: 0.06) : AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: selected ? primary : Colors.transparent, width: 1.6),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 24.sp)),
            12.width,
            AppText(label,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? primary : AppColors.textPrimaryColor.themeColor),
            const Spacer(),
            Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                color: selected ? primary : AppColors.hintColor.themeColor),
          ],
        ),
      ),
    );
  }
}
