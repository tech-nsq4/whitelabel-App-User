import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/list_row_tile.dart';
import '../../data/models/appointment_model.dart';

/// The lab-analysis / x-ray requests attached to a completed appointment on
/// `AppointmentDetailScreen` (`test_requests` from `GET /appointments/{id}`)
/// — or the flat cross-appointment lists on `TestHistoryScreen`
/// (`GET /analyses|xrays/history`). Every row opens `TestResultDetailScreen`
/// — the image full-size (or a "no result yet" placeholder) plus the
/// report/dates/price, whether or not a result is in yet.
class TestResultsCard extends StatelessWidget {
  const TestResultsCard({super.key, required this.requests});

  final List<TestRequestModel> requests;

  Color _rateColor(TestRequestModel r) {
    if (!r.hasResult) return AppColors.accentGold.themeColor;
    return r.resultRate == 'not_normal' ? AppColors.errorColor.themeColor : AppColors.successColor.themeColor;
  }

  String _rateLabel(TestRequestModel r) {
    if (!r.hasResult) return LocaleKeys.booking_resultPending.tr();
    if (r.resultRate == 'not_normal') return LocaleKeys.booking_resultNotNormal.tr();
    if (r.resultRate == 'normal') return LocaleKeys.booking_resultNormal.tr();
    return LocaleKeys.booking_resultReady.tr();
  }

  String? _subtitle(TestRequestModel r) {
    final parts = [
      if (r.test?.description != null && r.test!.description!.isNotEmpty) r.test!.description!,
      if (r.note != null && r.note!.isNotEmpty) r.note!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  /// "16 أغسطس · 9:12 م" — date *and* time; a bare date would hide when
  /// same-day requests were actually made relative to each other.
  String _dateTimeLabel(DateTime dateTime, String locale) =>
      '${DateFormat('d MMM', locale).format(dateTime)} · ${DateFormat('h:mm a', locale).format(dateTime)}';

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          for (var i = 0; i < requests.length; i++)
            ListRowTile(
              icon: requests[i].isXray ? AppSvgIcons.xray : AppSvgIcons.flask,
              title: requests[i].test?.name ?? '',
              subtitle: _subtitle(requests[i]),
              showDivider: i != requests.length - 1,
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppChip(
                        label: _rateLabel(requests[i]),
                        background: _rateColor(requests[i]).withValues(alpha: 0.12),
                        color: _rateColor(requests[i]),
                      ),
                      6.width,
                      AppSvgIcon(AppSvgIcons.chevronRow, size: 14.sp, color: AppColors.hintColor.themeColor),
                    ],
                  ),
                  if (requests[i].createdAt != null) ...[
                    4.height,
                    AppText(
                      _dateTimeLabel(requests[i].createdAt!, locale),
                      fontSize: 9.5,
                      color: AppColors.hintColor.themeColor,
                    ),
                  ],
                  if ((requests[i].test?.price ?? 0) > 0) ...[
                    2.height,
                    AppText(
                      '${requests[i].test!.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedColor.themeColor,
                    ),
                  ],
                ],
              ),
              onTap: () => Navigator.pushNamed(
                context,
                Routes.testResultDetail,
                arguments: {'request': requests[i]},
              ),
            ),
        ],
      ),
    );
  }
}
