import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../data/models/appointment_model.dart';
import 'appointment_detail_actions.dart';
import 'appointment_status_badge.dart';

/// One row on [MyBookingsScreen] — date block + doctor/clinic info + status,
/// matching the design's appointment-card look (same family as the home
/// screen's `UpcomingAppointmentTile`, but for the full booking history).
/// [AppointmentDetailActions] underneath mirrors the same reschedule/cancel/
/// book-again buttons shown on `AppointmentDetailScreen`, so those actions
/// don't require opening the booking to reach.
class AppointmentListTile extends StatelessWidget {
  const AppointmentListTile({
    super.key,
    required this.appointment,
    this.onTap,
    required this.onReschedule,
    required this.onCancel,
    required this.onRate,
    required this.onBookAgain,
  });

  final AppointmentModel appointment;
  final VoidCallback? onTap;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;
  final VoidCallback onRate;
  final VoidCallback onBookAgain;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final dateTime = appointment.dateTime ?? appointment.date;
    final doctor = appointment.doctor;
    final subtitle = [
      if (doctor?.specialtyLabel.isNotEmpty ?? false) doctor!.specialtyLabel,
      if (doctor?.clinic?.name != null) doctor!.clinic!.name,
    ].join(' · ');

    return AppCard(
      margin: EdgeInsets.only(bottom: 12.h),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(end: 14.w),
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    end: BorderSide(color: AppColors.dividerColor.themeColor),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      dateTime == null ? '—' : DateFormat('d', locale).format(dateTime),
                      style: TextStyle(
                        fontFamily: AppFonts.headingFont,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor.themeColor,
                        height: 1,
                      ),
                    ),
                    if (dateTime != null)
                      AppText(
                        DateFormat('MMMM', locale).format(dateTime),
                        fontSize: 10,
                        color: AppColors.mutedColor.themeColor,
                      ),
                  ],
                ),
              ),
              14.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      doctor?.name ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimaryColor.themeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (doctor?.avgRate != null) ...[
                      3.height,
                      Row(
                        children: [
                          StarRating(value: doctor!.avgRate!, size: 11, spacing: 1.5),
                          4.width,
                          AppText(
                            doctor.avgRate!.toStringAsFixed(1),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryColor.themeColor,
                          ),
                        ],
                      ),
                    ],
                    if (subtitle.isNotEmpty) ...[
                      3.height,
                      AppText(
                        subtitle,
                        fontSize: 11,
                        color: AppColors.mutedColor.themeColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (appointment.familyMember != null) ...[
                      3.height,
                      AppText(
                        appointment.familyMember!.name,
                        fontSize: 10.5,
                        color: AppColors.mutedColor.themeColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    '#${appointment.id}',
                    fontSize: 9.5,
                    color: AppColors.mutedColor.themeColor,
                  ),
                  4.height,
                  AppointmentStatusBadge(status: appointment.status),
                  6.height,
                  AppText(
                    appointment.timeLabel,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                ],
              ),
            ],
          ),
          if (AppointmentDetailActions.hasActions(appointment)) ...[
            14.height,
            Divider(height: 1, color: AppColors.dividerColor.themeColor),
            14.height,
            AppointmentDetailActions(
              appointment: appointment,
              onReschedule: onReschedule,
              onCancel: onCancel,
              onRate: onRate,
              onBookAgain: onBookAgain,
            ),
          ],
        ],
      ),
    );
  }
}
