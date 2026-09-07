import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/specialization_model.dart';
import 'specialty_visuals.dart';

/// One tile in the specialty grid on [BookScreen] — centred icon, the
/// specialty name across the full width, and a smaller sub-line under it
/// (the specialization's description, falling back to its sub-specialty
/// count).
class SpecialtyGridTile extends StatelessWidget {
  const SpecialtyGridTile({
    super.key,
    required this.specialization,
    required this.index,
    required this.onTap,
  });

  final SpecializationModel specialization;
  final int index;
  final VoidCallback onTap;

  String? get _subLabel {
    final description = specialization.description?.trim();
    if (description != null && description.isNotEmpty) return description;
    if (specialization.hasSubSpecializations) {
      return LocaleKeys.booking_subSpecialtiesCount
          .tr(namedArgs: {'count': '${specialization.subSpecializations.length}'});
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final visuals = SpecialtyVisuals.resolve(specialization.title, index);
    final accent = visuals.accent.themeColor;
    final subLabel = _subLabel;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            alignment: Alignment.center,
            child: AppSvgIcon(visuals.icon, size: 22.sp, color: accent),
          ),
          10.height,
          AppText(
            specialization.title,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryColor.themeColor,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subLabel != null) ...[
            3.height,
            AppText(
              subLabel,
              fontSize: 10.5,
              color: AppColors.mutedColor.themeColor,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
