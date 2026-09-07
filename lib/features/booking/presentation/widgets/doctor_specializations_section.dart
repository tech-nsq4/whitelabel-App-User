import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/doctor_profile_model.dart';

/// The doctor's specialties + sub-specialties, each with its description —
/// shown between the "about" card and the tabs on [DoctorScreen].
class DoctorSpecializationsSection extends StatelessWidget {
  const DoctorSpecializationsSection({super.key, required this.doctor});

  final DoctorProfileModel doctor;

  @override
  Widget build(BuildContext context) {
    final specializations = doctor.specializations
        .where((s) => s.title.isNotEmpty)
        .map((s) => (title: s.title, description: s.description))
        .toList();
    final subSpecializations = doctor.subSpecializations
        .where((s) => s.title.isNotEmpty)
        .map((s) => (title: s.title, description: s.description))
        .toList();

    if (specializations.isEmpty && subSpecializations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (specializations.isNotEmpty) ...[
          SectionHeader(title: LocaleKeys.booking_specializations.tr()),
          10.height,
          _BulletCard(items: specializations),
          16.height,
        ],
        if (subSpecializations.isNotEmpty) ...[
          SectionHeader(title: LocaleKeys.booking_subSpecializations.tr()),
          10.height,
          _BulletCard(items: subSpecializations),
          16.height,
        ],
      ],
    );
  }
}

class _BulletCard extends StatelessWidget {
  const _BulletCard({required this.items});

  final List<({String title, String? description})> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) 14.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.themeColor,
                    shape: BoxShape.circle,
                  ),
                ),
                10.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(items[i].title,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryColor.themeColor),
                      if ((items[i].description ?? '').isNotEmpty) ...[
                        3.height,
                        AppText(items[i].description!,
                            fontSize: 11,
                            color: AppColors.textSecondaryColor.themeColor,
                            height: 1.6),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
