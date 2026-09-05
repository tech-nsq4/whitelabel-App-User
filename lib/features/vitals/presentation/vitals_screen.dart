import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import 'widgets/vital_stat_card.dart';

class VitalsScreen extends StatelessWidget {
  const VitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vitals = kUserModel?.userVitalSigns;
    final locale = context.locale.languageCode;
    final updatedAt = vitals?.updatedAt;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: LocaleKeys.vitals_title.tr(),
                subtitle: updatedAt == null
                    ? null
                    : LocaleKeys.vitals_updatedOn
                        .tr(namedArgs: {'date': DateFormat('d MMMM', locale).format(updatedAt)}),
              ),
              Expanded(
                child: vitals == null
                    ? AppEmpty(message: LocaleKeys.vitals_empty.tr(), icon: Icons.favorite_border_rounded)
                    : ListView(
                        children: [
                          AppCard(
                            padding: EdgeInsets.all(13.r),
                            color: AppColors.surfaceColor.themeColor,
                            borderColor: Colors.transparent,
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: AppText(
                              LocaleKeys.vitals_description.tr(),
                              fontSize: 11,
                              color: AppColors.textSecondaryColor.themeColor,
                              height: 1.6,
                            ),
                          ),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
                            childAspectRatio: 1.55,
                            children: [
                              if (vitals.pulse != null)
                                VitalStatCard(
                                  label: LocaleKeys.vitals_pulse.tr(),
                                  value: '${vitals.pulse}',
                                  unit: LocaleKeys.vitals_pulseUnit.tr(),
                                ),
                              if (vitals.bloodPressure != null && vitals.bloodPressure!.isNotEmpty)
                                VitalStatCard(
                                  label: LocaleKeys.vitals_bloodPressure.tr(),
                                  value: vitals.bloodPressure!,
                                  unit: LocaleKeys.vitals_bloodPressureUnit.tr(),
                                ),
                              if (vitals.temperature != null)
                                VitalStatCard(
                                  label: LocaleKeys.vitals_temperature.tr(),
                                  value: vitals.temperature!.toStringAsFixed(1),
                                  unit: LocaleKeys.vitals_temperatureUnit.tr(),
                                ),
                              if (vitals.oxygen != null)
                                VitalStatCard(
                                  label: LocaleKeys.vitals_oxygen.tr(),
                                  value: '${vitals.oxygen}',
                                  unit: LocaleKeys.vitals_oxygenUnit.tr(),
                                ),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
