import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class LocationPickerMyLocationButton extends StatelessWidget {
  const LocationPickerMyLocationButton({
    super.key,
    required this.onTap,
    this.loading = false,
  });

  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    return CustomTapEffect(
      onTap: loading ? null : onTap,
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: loading
            ? Center(child: CustomLoadingWidget(color: primary, size: 20.r))
            : Icon(Icons.my_location_rounded, size: 22.r, color: primary),
      ),
    );
  }
}
