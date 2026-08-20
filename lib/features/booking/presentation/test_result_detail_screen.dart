import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/image/custom_image.dart';
import '../../../core/widgets/list_row_tile.dart' show AppChip;
import '../../../core/widgets/screen_header.dart';
import '../data/models/appointment_model.dart';
import 'widgets/test_result_details_card.dart';

/// A single lab-analysis / x-ray request's full detail — reached by tapping
/// a row on `TestResultsCard` (from `AppointmentDetailScreen` or
/// `TestHistoryScreen`). Replaces just popping the result straight into a
/// bare full-screen photo viewer: shows it large at the top of a proper
/// page, with the report/dates/price underneath and the test name/id at
/// the top.
class TestResultDetailScreen extends StatelessWidget {
  const TestResultDetailScreen({super.key, required this.request});

  final TestRequestModel request;

  Color _rateColor() {
    if (!request.hasResult) return AppColors.accentGold.themeColor;
    return request.resultRate == 'not_normal' ? AppColors.errorColor.themeColor : AppColors.successColor.themeColor;
  }

  String _rateLabel() {
    if (!request.hasResult) return LocaleKeys.booking_resultPending.tr();
    if (request.resultRate == 'not_normal') return LocaleKeys.booking_resultNotNormal.tr();
    if (request.resultRate == 'normal') return LocaleKeys.booking_resultNormal.tr();
    return LocaleKeys.booking_resultReady.tr();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = request.url != null && request.url!.isNotEmpty;
    final title = request.test?.name.isNotEmpty ?? false
        ? request.test!.name
        : (request.isXray ? LocaleKeys.lab_xrayTitle.tr() : LocaleKeys.lab_resultsTitle.tr());
    final color = _rateColor();

    return Scaffold(
      body: SafeArea(
        // `openBottomSheet` below calls `showBottomSheet`, which needs a
        // `Scaffold.of(context)` — the `context` this `build` method receives
        // sits *above* the `Scaffold` returned here, so a `Builder` gets a
        // fresh one that's actually a descendant of it.
        child: Builder(
          builder: (context) => ListView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            children: [
              ScreenHeader(title: title, subtitle: '#${request.id}'),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: hasImage
                    ? GestureDetector(
                        onTap: () => openBottomSheet(context, NetworkImage(request.url!)),
                        child: CustomImage(
                          image: request.url!,
                          width: double.infinity,
                          height: 300.h,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 220.h,
                        color: AppColors.surfaceColor.themeColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppSvgIcon(
                              request.isXray ? AppSvgIcons.xray : AppSvgIcons.flask,
                              size: 32.sp,
                              color: AppColors.mutedColor.themeColor,
                            ),
                            10.height,
                            AppText(LocaleKeys.booking_noResultYet.tr(),
                                fontSize: 12, color: AppColors.mutedColor.themeColor),
                          ],
                        ),
                      ),
              ),
              14.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppChip(
                    label: _rateLabel(),
                    background: color.withValues(alpha: 0.12),
                    color: color,
                  ),
                  if (hasImage)
                    AppText(LocaleKeys.common_tapToZoom.tr(),
                        fontSize: 10.5, color: AppColors.hintColor.themeColor),
                ],
              ),
              16.height,
              TestResultDetailsCard(request: request),
              if (request.appointmentId != null) ...[
                14.height,
                CustomButton(
                  title: LocaleKeys.booking_viewAppointmentAction.tr(),
                  isOutlined: true,
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.appointmentDetail,
                    arguments: {'id': request.appointmentId},
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
