import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../logic/location_picker_cubit.dart';

class LocationPickerAddressCard extends StatelessWidget {
  const LocationPickerAddressCard({
    super.key,
    required this.state,
    required this.onConfirm,
  });

  final LocationPickerState state;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final isLoading = state is LocationPickerInitial || state is LocationPickerLoading;
    final (address, note) = switch (state) {
      LocationPickerSuccess(:final location) => (location.displayAddress, null),
      LocationPickerError(:final location, :final message) => (location.coordinatesLabel, message),
      LocationPickerLoading() => (LocaleKeys.locationPicker_resolving.tr(), null),
      LocationPickerInitial() => (LocaleKeys.locationPicker_locating.tr(), null),
    };

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              LocaleKeys.locationPicker_selectedLocation.tr(),
              fontSize: 13.sp,
              color: AppColors.textSecondaryColor.themeColor,
            ),
            10.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: AppSvgIcon(AppSvgIcons.mapPin, size: 20.r, color: primary),
                ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        address,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                      if (note != null) ...[
                        4.height,
                        AppText(note, fontSize: 12.sp, color: AppColors.errorColor.themeColor),
                      ],
                    ],
                  ),
                ),
                if (isLoading) ...[
                  8.width,
                  CustomLoadingWidget(color: primary, size: 20.r),
                ],
              ],
            ),
            18.height,
            Opacity(
              opacity: isLoading ? 0.5 : 1,
              child: CustomButton(
                onTap: isLoading ? () {} : onConfirm,
                title: LocaleKeys.locationPicker_confirmLocation.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
