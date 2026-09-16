import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

/// Quick-access services grid: book appointment, telemed consultation, and
/// offers. Tapping a tile marks it as the active service (filled style,
/// matching the design) and fires its action.
class HomeServicesGrid extends StatefulWidget {
  const HomeServicesGrid({
    super.key,
    this.onBookTap,
    this.onTelemedTap,
    this.onOffersTap,
  });

  final VoidCallback? onBookTap;
  final VoidCallback? onTelemedTap;
  final VoidCallback? onOffersTap;

  @override
  State<HomeServicesGrid> createState() => _HomeServicesGridState();
}

class _HomeServicesGridState extends State<HomeServicesGrid> {
  int _selected = 0;

  void _onTap(int index, VoidCallback? action) {
    if (_selected != index) setState(() => _selected = index);
    action?.call();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (
        AppSvgIcons.calendar,
        LocaleKeys.home_bookAppointment.tr(),
        LocaleKeys.home_bookAppointmentSubtitle.tr(),
        widget.onBookTap,
        false,
      ),
      (
        AppSvgIcons.videoCam,
        LocaleKeys.home_consultation.tr(),
        LocaleKeys.home_consultationSubtitle.tr(),
        widget.onTelemedTap,
        true,
      ),
      (
        AppSvgIcons.giftBox,
        LocaleKeys.home_offers.tr(),
        LocaleKeys.home_offersSubtitle.tr(),
        widget.onOffersTap,
        false,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) 10.width,
          Expanded(
            child: _ServiceTile(
              icon: tiles[i].$1,
              label: tiles[i].$2,
              subLabel: tiles[i].$3,
              selected: _selected == i,
              comingSoon: tiles[i].$5,
              onTap: () => _onTap(i, tiles[i].$4),
            ),
          ),
        ],
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.selected,
    required this.onTap,
    this.comingSoon = false,
  });

  final String icon;
  final String label;
  final String subLabel;
  final bool selected;
  final bool comingSoon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final iconColor = selected ? Colors.white : primary;
    final labelColor =
        selected ? Colors.white : AppColors.textPrimaryColor.themeColor;
    final subColor = selected
        ? Colors.white.withValues(alpha: 0.7)
        : AppColors.mutedColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: selected ? primary : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
          border: selected
              ? null
              : Border.all(color: AppColors.dividerColor.themeColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimaryColor.themeColor
                  .withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: AppSvgIcon(icon, size: 20.sp, color: iconColor),
            ),
            8.height,
            AppText(
              label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: labelColor,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (comingSoon)
              Container(
                margin: EdgeInsets.only(top: 5.h),
                padding: EdgeInsetsDirectional.only(
                    start: 7.w, end: 7.w, top: 2.h, bottom: 2.h),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.22)
                      : AppColors.secondaryColor.themeColor
                          .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: AppText(
                  LocaleKeys.comingSoon_badge.tr(),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? Colors.white
                      : AppColors.secondaryColor.themeColor,
                ),
              )
            else ...[
              2.height,
              AppText(
                subLabel,
                fontSize: 9.5,
                color: subColor,
                textAlign: TextAlign.center,
                maxLines: 1,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
