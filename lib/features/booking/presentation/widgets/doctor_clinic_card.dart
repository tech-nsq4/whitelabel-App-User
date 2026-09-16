import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/guest_login_dialog.dart';
import '../../data/models/doctor_profile_model.dart';
import '../../logic/favorites_cubit.dart';

class DoctorClinicCard extends StatelessWidget {
  const DoctorClinicCard({super.key, required this.clinic, this.onBook, this.showFavorite = true});

  final DoctorClinicModel clinic;
  final VoidCallback? onBook;
  final bool showFavorite;

  Future<void> _openDirections() async {
    try {
      await HelperMethods.openGoogleMaps(lat: clinic.lat!, lng: clinic.lng!);
    } catch (_) {
      AppOverlay.showError(LocaleKeys.error_generic.tr());
    }
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    if (kIsGuest) {
      final loggedIn = await requireGuestLogin(context);
      if (!loggedIn || !context.mounted) return;
    }
    if (!context.mounted) return;
    context.read<FavoritesCubit>().toggle(clinic);
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final areaLine = [
      clinic.location?.name,
      clinic.location?.area?.name,
      clinic.location?.city?.name,
    ].where((s) => s != null && s.isNotEmpty).join('، ');
    final hasCoordinates = clinic.lat != null && clinic.lng != null;
    final showActions = onBook != null || hasCoordinates;

    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.location_on_rounded, color: primary, size: 19.sp),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(clinic.name,
                        fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimaryColor.themeColor),
                    if (clinic.address != null && clinic.address!.isNotEmpty) ...[
                      3.height,
                      AppText(clinic.address!,
                          fontSize: 11, color: AppColors.textSecondaryColor.themeColor, height: 1.5),
                    ],
                    if (areaLine.isNotEmpty) ...[
                      2.height,
                      AppText(areaLine, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                    ],
                  ],
                ),
              ),
              if (showFavorite) ...[
                6.width,
                BlocSelector<FavoritesCubit, FavoritesState, bool>(
                  selector: (state) =>
                      state is FavoritesSuccess ? state.contains(clinic.id) : clinic.isFavorite,
                  builder: (context, isFavorite) {
                    return CustomTapEffect(
                      onTap: () => _toggleFavorite(context),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 20.sp,
                        color: isFavorite
                            ? AppColors.errorColor.themeColor
                            : AppColors.mutedColor.themeColor,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
          if (showActions) ...[
            11.height,
            Divider(height: 1, color: AppColors.dividerColor.themeColor),
            11.height,
            Row(
              children: [
                if (onBook != null)
                  Expanded(
                    child: CustomButton(
                      title: LocaleKeys.booking_appointmentsAction.tr(),
                      height: 38,
                      fontSize: 12,
                      onTap: onBook!,
                    ),
                  ),
                if (onBook != null && hasCoordinates) 8.width,
                if (hasCoordinates)
                  Expanded(
                    child: CustomButton(
                      title: LocaleKeys.booking_directions.tr(),
                      isOutlined: true,
                      height: 38,
                      fontSize: 12,
                      onTap: _openDirections,
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
