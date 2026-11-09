import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../booking/data/models/doctor_profile_model.dart';
import 'home_visit_area_cost_row.dart';

class HomeVisitAreasCard extends StatelessWidget {
  const HomeVisitAreasCard({super.key, required this.doctor, this.highlightedAreaId, this.onBook});

  final DoctorProfileModel doctor;
  final int? highlightedAreaId;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final cityName = doctor.homeVisitCity?.name;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.home_rounded, size: 18.sp, color: AppColors.primaryColor.themeColor),
              8.width,
              Expanded(
                child: AppText(LocaleKeys.homeVisit_areas.tr(),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
              ),
              if (cityName != null && cityName.isNotEmpty)
                AppText(cityName, fontSize: 11, color: AppColors.mutedColor.themeColor),
            ],
          ),
          10.height,
          for (final area in doctor.homeVisitAreas)
            HomeVisitAreaCostRow(area: area, highlighted: area.id == highlightedAreaId),
          if (onBook != null) ...[
            6.height,
            CustomButton(
              title: LocaleKeys.homeVisit_bookHomeVisit.tr(),
              isOutlined: true,
              height: 40,
              fontSize: 13,
              onTap: onBook!,
            ),
          ],
        ],
      ),
    );
  }
}
