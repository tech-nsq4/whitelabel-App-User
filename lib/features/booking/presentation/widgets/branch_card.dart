import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_profile_model.dart';

/// One clinic on [BranchesScreen] — address/area, "Directions" (opens Maps
/// with the clinic's real coordinates) and "View Doctors" (→
/// `DoctorSearchScreen` filtered by this clinic's id).
class BranchCard extends StatelessWidget {
  const BranchCard({super.key, required this.branch, required this.onViewDoctors});

  final DoctorClinicModel branch;
  final VoidCallback onViewDoctors;

  Future<void> _openDirections() async {
    try {
      await HelperMethods.openGoogleMaps(lat: branch.lat!, lng: branch.lng!);
    } catch (_) {
      AppOverlay.showError(LocaleKeys.error_generic.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final areaLine = [branch.location?.area?.name, branch.location?.city?.name]
        .where((s) => s != null && s.isNotEmpty)
        .join('، ');
    final hasCoordinates = branch.lat != null && branch.lng != null;

    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_rounded, color: primary, size: 20.sp),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(branch.name,
                        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor),
                    if (branch.address != null && branch.address!.isNotEmpty) ...[
                      2.height,
                      AppText(branch.address!, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                    ],
                    if (areaLine.isNotEmpty) ...[
                      2.height,
                      AppText(areaLine, fontSize: 10, color: AppColors.mutedColor.themeColor),
                    ],
                  ],
                ),
              ),
            ],
          ),
          10.height,
          Row(
            children: [
              if (hasCoordinates) ...[
                Expanded(
                  child: CustomButton(
                    title: LocaleKeys.booking_directions.tr(),
                    isOutlined: true,
                    height: 36,
                    fontSize: 11.5,
                    onTap: _openDirections,
                  ),
                ),
                8.width,
              ],
              Expanded(
                child: CustomButton(
                  title: LocaleKeys.booking_viewDoctors.tr(),
                  height: 36,
                  fontSize: 11.5,
                  onTap: onViewDoctors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
