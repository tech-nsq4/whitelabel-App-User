import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_profile_model.dart';

/// Clinic name/address/area card on [DoctorScreen], built from
/// `doctor.clinic`.
class DoctorClinicCard extends StatelessWidget {
  const DoctorClinicCard({super.key, required this.clinic});

  final DoctorClinicModel clinic;

  @override
  Widget build(BuildContext context) {
    final areaLine = [clinic.location?.area?.name, clinic.location?.city?.name]
        .where((s) => s != null && s.isNotEmpty)
        .join('، ');

    return AppCard(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(clinic.name,
              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor),
          if (clinic.address != null && clinic.address!.isNotEmpty) ...[
            4.height,
            AppText(clinic.address!, fontSize: 11.5, color: AppColors.textSecondaryColor.themeColor),
          ],
          if (areaLine.isNotEmpty) ...[
            4.height,
            AppText(areaLine, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
          ],
        ],
      ),
    );
  }
}
