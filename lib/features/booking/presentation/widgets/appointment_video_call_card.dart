import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/appointment_model.dart';

class AppointmentVideoCallCard extends StatefulWidget {
  const AppointmentVideoCallCard({
    super.key,
    required this.appointment,
    required this.onJoin,
  });

  final AppointmentModel appointment;
  final Future<void> Function() onJoin;

  static const _activeStatuses = {'pending', 'confirmed', 'in_progress'};

  static bool isVisible(AppointmentModel appointment) =>
      appointment.isOnline && _activeStatuses.contains(appointment.status);

  @override
  State<AppointmentVideoCallCard> createState() =>
      _AppointmentVideoCallCardState();
}

class _AppointmentVideoCallCardState extends State<AppointmentVideoCallCard> {
  bool _joining = false;

  Future<void> _handleJoin() async {
    if (_joining) return;
    setState(() => _joining = true);
    await widget.onJoin();
    if (mounted) setState(() => _joining = false);
  }

  @override
  Widget build(BuildContext context) {
    final live = widget.appointment.hasOngoingCall;
    final canResume = widget.appointment.canResumeCall;
    final accent = live
        ? AppColors.successColor.themeColor
        : AppColors.primaryColor.themeColor;

    return AppCard(
      padding: 14.paddingAll,
      borderColor: accent.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.12),
                ),
                child: Icon(Icons.videocam_rounded, color: accent, size: 20.sp),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      LocaleKeys.videoCall_onlineVisit.tr(),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                    3.height,
                    Row(
                      children: [
                        if (live) ...[
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.errorColor.themeColor,
                            ),
                          ),
                          6.width,
                        ],
                        Expanded(
                          child: AppText(
                            (canResume
                                    ? LocaleKeys.videoCall_resumeNotice
                                    : live
                                        ? LocaleKeys.videoCall_liveNotice
                                        : LocaleKeys.videoCall_notStarted)
                                .tr(),
                            fontSize: 12,
                            color: AppColors.textSecondaryColor.themeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (live) ...[
            12.height,
            CustomButton(
              onTap: _handleJoin,
              loading: _joining,
              color: AppColors.successColor.themeColor,
              borderColor: AppColors.successColor.themeColor,
              title: (canResume
                      ? LocaleKeys.videoCall_resume
                      : LocaleKeys.videoCall_join)
                  .tr(),
            ),
          ],
        ],
      ),
    );
  }
}
