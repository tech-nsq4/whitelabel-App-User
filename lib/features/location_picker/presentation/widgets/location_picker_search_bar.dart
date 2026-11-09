import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class LocationPickerSearchBar extends StatelessWidget {
  const LocationPickerSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onBack,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final cardColor = AppColors.cardColor.themeColor;
    return Row(
      children: [
        CustomTapEffect(
          onTap: onBack,
          child: Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.r,
              color: AppColors.textPrimaryColor.themeColor,
            ),
          ),
        ),
        10.width,
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: CustomTextField(
              hint: LocaleKeys.locationPicker_searchHint.tr(),
              controller: controller,
              fillColor: cardColor,
              textInputAction: TextInputAction.search,
              onSubmitted: onSearch,
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.r),
                child: AppSvgIcon(AppSvgIcons.search, size: 20.r, color: AppColors.hintColor.themeColor),
              ),
              suffixIcon: IconButton(
                onPressed: () => onSearch(controller.text),
                icon: Icon(Icons.arrow_forward_rounded, color: AppColors.primaryColor.themeColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
