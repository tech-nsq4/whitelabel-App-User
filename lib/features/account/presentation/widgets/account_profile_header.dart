import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../profile/logic/profile_cubit.dart';

/// The avatar + name/phone + edit-button row at the top of [AccountScreen].
/// Reflects the live [ProfileCubit] state so it refreshes as soon as the
/// user saves changes on [Routes.profile], without needing a manual reload.
class AccountProfileHeader extends StatelessWidget {
  const AccountProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Fall back to the cached `kUserModel` while a fetch/save is in
        // flight (or if it failed) so the header never flashes empty.
        final user = state is ProfileSuccess ? state.user : kUserModel;
        final isGuest = user == null;
        final hasName = !isGuest && (user.name?.trim().isNotEmpty ?? false);
        final displayName = isGuest
            ? LocaleKeys.profile_guestName.tr()
            : (hasName ? user.name!.trim() : user.phone);
        final subtitle =
            isGuest ? LocaleKeys.profile_guestSubtitle.tr() : user.phone;

        return Row(
          children: [
            Container(
              width: 58.r,
              height: 58.r,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(19.r),
              ),
              alignment: Alignment.center,
              child: hasName
                  ? Text(
                      displayName[0],
                      style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  : Icon(Icons.person_rounded, color: Colors.white, size: 26.sp),
            ),
            14.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(displayName,
                      isHeading: true,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.textPrimaryColor.themeColor),
                  2.height,
                  AppText(subtitle,
                      fontSize: 13,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.mutedColor.themeColor),
                ],
              ),
            ),
            if (!isGuest)
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.cardColor.themeColor,
                  borderRadius: BorderRadius.circular(13.r),
                  border: Border.all(color: AppColors.dividerColor.themeColor),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pushNamed(context, Routes.profile),
                  icon: Icon(Icons.edit_outlined,
                      size: 16.sp, color: AppColors.mutedColor.themeColor),
                ),
              ),
          ],
        );
      },
    );
  }
}
