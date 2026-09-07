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

/// `GET /doctors` ordering options. `closest_available` ranks by soonest slot,
/// or by distance when the request carries `lat`/`lng` ([nearestDistance]).
enum DoctorSort {
  closestAvailable('closest_available', LocaleKeys.booking_sortClosestAvailable),
  nearestDistance('closest_available', LocaleKeys.booking_sortNearestDistance),
  highestRated('highest_rated', LocaleKeys.booking_sortHighestRated),
  lowestPrice('lowest_price', LocaleKeys.booking_sortLowestPrice);

  const DoctorSort(this.value, this.labelKey);

  final String value;
  final String labelKey;

  bool get needsLocation => this == DoctorSort.nearestDistance;
}

/// Square icon button that sits next to the search field and opens
/// [showDoctorSortSheet]. Filled/tinted while a non-default sort is active.
class DoctorSortButton extends StatelessWidget {
  const DoctorSortButton({super.key, required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        width: 46.r,
        height: 46.r,
        decoration: BoxDecoration(
          color: active ? primary : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
              color: active ? Colors.transparent : AppColors.dividerColor.themeColor),
        ),
        alignment: Alignment.center,
        child: AppSvgIcon(
          AppSvgIcons.sortArrows,
          size: 19.sp,
          color: active ? Colors.white : AppColors.textSecondaryColor.themeColor,
        ),
      ),
    );
  }
}

/// A `(sort:)` record — `sort == null` means "default order". A `null` future
/// means the sheet was dismissed without a choice.
Future<({DoctorSort? sort})?> showDoctorSortSheet(
  BuildContext context, {
  DoctorSort? current,
}) {
  return showModalBottomSheet<({DoctorSort? sort})>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _DoctorSortSheet(current: current),
  );
}

class _DoctorSortSheet extends StatelessWidget {
  const _DoctorSortSheet({this.current});

  final DoctorSort? current;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 18.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.hintColor.themeColor,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          AppText(LocaleKeys.booking_sortTitle.tr(),
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              color: AppColors.textPrimaryColor.themeColor),
          16.height,
          _row(context, label: LocaleKeys.booking_sortDefault.tr(), selected: current == null, value: null),
          for (final sort in DoctorSort.values)
            _row(context, label: sort.labelKey.tr(), selected: current == sort, value: sort),
        ],
      ),
    );
  }

  Widget _row(BuildContext context,
      {required String label, required bool selected, required DoctorSort? value}) {
    final primary = AppColors.primaryColor.themeColor;

    return GestureDetector(
      onTap: () => Navigator.pop(context, (sort: value)),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.06)
              : AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: selected ? primary : Colors.transparent, width: 1.6),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(label,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? primary : AppColors.textPrimaryColor.themeColor),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: selected ? primary : AppColors.hintColor.themeColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
